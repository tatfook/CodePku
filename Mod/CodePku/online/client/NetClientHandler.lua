--[[
Author:{zouren}
Date: 2020-10-31 10:45:33
Des:
use the lib:
------------------------------------
NPL.load("Mod/CodePku/online/client/NetClientHandler.lua");
local NetClientHandler = commonlib.gettable("Mod.CodePku.Online.Client.NetClientHandler");
-----------------------------------
]]--
NPL.load("Mod/GeneralGameServerMod/Core/Client/NetClientHandler.lua");
NPL.load("(gl)script/apps/Aries/Creator/Game/Entity/EntityManager.lua");
NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/ChooseBranch.lua")

local NetClientHandler = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.NetClientHandler"), commonlib.gettable("Mod.CodePku.Online.Client.NetClientHandler"));
local Packets = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Packets")
local BroadcastHelper = commonlib.gettable("CommonCtrl.BroadcastHelper");
local EntityMainPlayer = commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer");
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager");
local ChooseBranch = commonlib.gettable("Mod.CodePku.GUI.ChooseBranch")

local PlayerLoginLogoutDebug = GGS.PlayerLoginLogoutDebug;

function NetClientHandler:ctor() 

end

-- create a tcp connection to server. 
function NetClientHandler:Init(world)
    self._super.Init(self, world)

	return self;
end

function NetClientHandler:handleGeneral(packetGeneral)
    local action = packetGeneral.action;
    if (action == "WanXueShiJie") then 
        local cmd = packetGeneral.data.cmd;
        -- GGS.INFO(packetGeneral);

        if cmd == "WorldInfo" then
            local worldInfo = packetGeneral.data.servers;
            local currWorld = packetGeneral.data.current_world;
            local currServer = packetGeneral.data.current_server;
            commonlib.setfield("System.Codepku.branch.worldInfo", worldInfo)
            commonlib.setfield("System.Codepku.branch.currWorld", currWorld)
            commonlib.setfield("System.Codepku.branch.currServer", currServer)
            -- 如果分线界面开启着  直接刷新分线数据和界面
            NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/ChooseBranch.lua")
            local ChooseBranch = commonlib.gettable("Mod.CodePku.GUI.ChooseBranch")
            if ChooseBranch.ui then
                ChooseBranch:DealBranchStateData()
                ChooseBranch.ui:Refresh()
            end

        elseif cmd == "WorldKey" then
            local currWorld = packetGeneral.data.data;
            commonlib.setfield("System.Codepku.branch.currWorld", currWorld)
        end
    else
        self._super.handleGeneral(self, packetGeneral)
    end
end

-- 登录
function NetClientHandler:Login()
    local options = self:GetClient():GetOptions();
    options.worldKey = options.worldKey or ((options.worldId or "1").."_"..(options.worldName or "1").."_"..(options.no or "1"))

    GGS.INFO(options);
    self:AddToSendQueue(Packets.PacketPlayerLogin:new():Init({
        username = options.username,
        password = options.password,
        worldId = options.worldId,
        worldName = options.worldName,
        worldType = options.worldType,
        worldKey = options.worldKey,
        options = {
            isSyncBlock = options.isSyncBlock,
            isSyncForceBlock = options.isSyncForceBlock,
            isSyncCmd = options.isSyncCmd,
            areaSize = options.areaSize,
        }
    }));
end

function NetClientHandler:handlePlayerLogin(packetPlayerLogin)
    local result = packetPlayerLogin.result;
    local errmsg = packetPlayerLogin.errmsg or "";
    local username = packetPlayerLogin.username;
    local entityId = packetPlayerLogin.entityId;
    local areaSize = packetPlayerLogin.areaSize;

    GGS.INFO(packetPlayerLogin);

    -- 登录失败
    if (result ~= "ok") then
        local text = "登录失败! " .. errmsg;
        BroadcastHelper.PushLabel({id="NetClientHandler", label = text, max_duration=7000, color = "255 0 0", scaling=1.1, bold=true, shadow=true,});
        PlayerLoginLogoutDebug("登录失败, 退出联机世界");
		return self:GetWorld():Logout();
    end

    PlayerLoginLogoutDebug.Format("player login success, username: %s, entityId: %s, areaSize: %s", username, entityId, areaSize);
    
    -- 登录成功
    local options = self:GetClient():GetOptions();
    options.worldId = packetPlayerLogin.worldId;                       -- 世界ID
    options.worldName = packetPlayerLogin.worldName;                   -- 平行世界名  可能被客户端改掉
    options.username = packetPlayerLogin.username;
    options.areaSize = packetPlayerLogin.areaSize or 0; 

    self:SetUserName(options.username);

    -- 只能仿照客户端做  不能使用EntityPlayerMP 内部会触发后端数据维护
    GameLogic:event(System.Core.Event:new():init("ps_client_login"));

    -- 获取旧当前玩家
    local oldEntityPlayer = EntityManager.GetPlayer();
    -- 创建当前玩家
    local EntityMainPlayerClass = self:GetClient():GetEntityMainPlayerClass() or EntityMainPlayer;
    local entityPlayer = EntityMainPlayerClass:new():init(self:GetWorld(), self, entityId);
    local x, y, z = 20000, -128, 20000;
    if(oldEntityPlayer) then
        local oldMainAssetPath = oldEntityPlayer:GetMainAssetPath();
        entityPlayer:SetMainAssetPath(if_else(not oldMainAssetPath or oldMainAssetPath == "", "character/CC/02human/paperman/boy01.x", oldMainAssetPath));
        entityPlayer:SetSkin(oldEntityPlayer:GetSkin());
        entityPlayer:SetGravity(oldEntityPlayer:GetGravity());
        entityPlayer:SetScaling(oldEntityPlayer:GetScaling());
        entityPlayer:SetSpeedScale(oldEntityPlayer:GetSpeedScale());
        x, y, z = oldEntityPlayer:GetPosition();
        if (not oldEntityPlayer:isa(EntityMainPlayerClass)) then
            local randomRange = 5;
            x = x + math.random(-randomRange, randomRange);
            z = z + math.random(-randomRange, randomRange);
        end
        entityPlayer:SetPosition(x, y, z);
    end

    if (self:GetClient():GetMainPlayerEntityScale()) then entityPlayer:SetScaling(self:GetClient():GetMainPlayerEntityScale()) end
    if (self:GetClient():GetMainPlayerEntityAsset()) then entityPlayer:SetMainAssetPath(self:GetClient():GetMainPlayerEntityAsset()) end
    if (self:GetClient():GetMainPlayerEntitySkin()) then entityPlayer:SetSkin(self:GetClient():GetMainPlayerEntitySkin()) end

    -- 构建玩家信息
    local playerInfo = {
        state = "online",
        username = username,
        isAnonymousUser = self:GetClient():IsAnonymousUser(),
        userinfo = self:GetClient():GetUserInfo(),
    }
    
    -- 上报玩家实体信息
    local dataWatcher = entityPlayer:GetDataWatcher();
    local bx, by, bz = entityPlayer:GetBlockPos();
    self:AddToSendQueue(Packets.PacketPlayerEntityInfo:new():Init({
        entityId = entityId,
        x = x, y = y, z = z,
        bx = bx, by = by, bz = bz,
        name = username or tostring(entityId),
        facing = math.floor(entityPlayer.rotationYaw or entityPlayer.facing or 0),
        pitch = math.floor(entityPlayer.rotationPitch or 0),
        playerInfo = playerInfo,
    }, dataWatcher, true));

    -- 清空玩家列表
    self:GetPlayerManager():ClearPlayers();

    -- 设置主玩家
    entityPlayer:Attach();
    GameLogic.GetPlayerController():SetMainPlayer(entityPlayer);  -- 内部会销毁旧当前玩家
    self:GetPlayerManager():SetMainPlayer(entityPlayer);
    self:GetPlayerManager():SetAreaSize(areaSize);
    self:SetPlayer(entityPlayer);

    -- 设置玩家信息
    entityPlayer:SetPlayerInfo(playerInfo);
    
    -- echo("====ChooseBranch.jumpToWorldKey====")
    -- echo(ChooseBranch.jumpToWorldKey)
    -- echo(options.worldKey)
    -- GameLogic.AddBBS(nil, L"你选择的服务器已满，按顺序进入到下一个服务器", 3000, "255 0 0")
    if ChooseBranch.jumpToWorldKey and ChooseBranch.jumpToWorldKey ~= options.worldKey then
        ChooseBranch.jumpToWorldKey = nil
        GameLogic.AddBBS(nil, string.format("你选择的分线已满，你已进入%s", ChooseBranch:getBranchNameByWorldKey(options.worldKey)), 3000, "255 0 0")
    end

    return;
end