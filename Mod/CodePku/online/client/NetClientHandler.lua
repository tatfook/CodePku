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
            manual = options.manual,
            no = options.no
        }
    }));
end

function NetClientHandler:handlePlayerLogin(packetPlayerLogin)
    self._super.handlePlayerLogin(self, packetPlayerLogin)
    -- commonlib.setfield("System.Codepku.IsGGSConnected", true)
end

function NetClientHandler:handlePlayerLogout(packetPlayerLogout)
    self._super.handlePlayerLogout(self, packetPlayerLogout)
    -- commonlib.setfield("System.Codepku.IsGGSConnected", false)
end