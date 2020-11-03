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
    if (action == "CodePKU") then 
        local cmd = packetGeneral.data.cmd;
        local worldInfo = packetGeneral.data.worldInfo;
        GGS.INFO(cmd, worldInfo);
        commonlib.setfield("System.Codepku.branch.worldInfo", worldInfo)
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
        options = {
            isSyncBlock = options.isSyncBlock,
            isSyncForceBlock = options.isSyncForceBlock,
            isSyncCmd = options.isSyncCmd,
            areaSize = options.areaSize,
            no = options.no or "1"
        }
    }));
end