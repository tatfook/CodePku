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

    --当跳转分线的时候才强制初始化options.worldkey,其余的时候不用,因为在一开始初始化的worldkey中途被置空了  这里重新生成下
    if tonumber(options.manual) == 1 then
        options.worldKey = options.worldKey or ((options.worldId or "1").."_"..(options.worldName or "1").."_"..(options.no or "1")) -- worldKey每次重写
    else
        options.worldKey = options.worldKey
    end

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
            manual = options.manual,
            no = options.no
        }
    }));
end

function NetClientHandler:handlePlayerLogin(packetPlayerLogin)
    self._super.handlePlayerLogin(self, packetPlayerLogin)
end

function NetClientHandler:handlePlayerLogout(packetPlayerLogout)
    self._super.handlePlayerLogout(self, packetPlayerLogout)
end

-- 玩家离线状态
function NetClientHandler:Offline()
    -- self._super.Offline(self, packetPlayerLogout)
    -- -- 清除其它玩家
    self:GetPlayerManager():ClearPlayers();

    -- 调整当前玩家样式
    if (not self:GetPlayer()) then return end;
    
    -- 分线切换的时候不切换为灰色名字
    if tonumber(self:GetClient():GetOptions().manual) ~= 1 then
        -- 灰化用户名
        self:GetPlayer():SetHeadOnDisplay({url=ParaXML.LuaXML_ParseString(string.format([[
        <pe:mcml>
            <div style="width: 200px; margin-left: -100px; margin-top:-40px;">
                <div style="text-align:center; color: #b1b1b1; base-font-size:20px; font-size:20px;">%s</div>
                <div style="text-align:center; color: #ff0000; base-font-size:14px; font-size:14px;">已掉线, 处于离线模式中.</div>
            </div>
        </pe:mcml>]], self:GetUserName()))});
    end
end