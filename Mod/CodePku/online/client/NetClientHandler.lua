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


function NetClientHandler:ctor() 

end

-- create a tcp connection to server. 
function NetClientHandler:Init(world)
    self._super.Init(self, world)

	return self;
end

-- 处理方块点击
function NetClientHandler:handleGeneral(packetGeneral)
    local action = packetGeneral.action;
    if (action == "CodePKU") then 
        local cmd = packetGeneral.data.cmd;
        local worldInfo = packetGeneral.data.worldInfo;
        GGS.INFO(cmd, worldInfo);
    else
        self._super.handleGeneral(self, packetGeneral)
    end
end