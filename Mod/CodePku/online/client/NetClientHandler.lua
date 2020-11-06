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

local NetClientHandler = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.NetClientHandler"), commonlib.gettable("Mod.CodePku.Online.Client.NetClientHandler"));
local Packets = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Packets")

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
        GGS.INFO(packetGeneral);

        if cmd == "WorldInfo" then
            local worldInfo = packetGeneral.data.data.worlds;
            local currWorld = packetGeneral.data.data.current;
            commonlib.setfield("System.Codepku.branch.worldInfo", worldInfo)
            commonlib.setfield("System.Codepku.branch.currWorld", currWorld)
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
    self:AddToSendQueue(Packets.PacketPlayerLogin:new():Init({
        username = options.username,
        password = options.password,
        worldId = options.worldId,
        worldName = options.worldName,
        worldType = options.worldType,
        worldKey = options.worldId.."_"..(options.worldName or "1").."_"..(options.no or "1"),
        options = {
            isSyncBlock = options.isSyncBlock,
            isSyncForceBlock = options.isSyncForceBlock,
            isSyncCmd = options.isSyncCmd,
            areaSize = options.areaSize,
        }
    }));
end