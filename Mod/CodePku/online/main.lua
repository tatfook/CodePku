--[[
Title: 联机模块 
Author(s): John Mai
Date: 2020-07-10 16:23:49
Desc: 玩学世界联机模块
Example:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/online/main.lua");
local Online = commonlib.gettable("Mod.CodePku.Online");
Online:init();
-------------------------------------------------------
]]

-- NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");
-- local Online = commonlib.gettable("Mod.CodePku.Online");
-- local Commands = commonlib.gettable("MyCompany.Aries.Game.Commands");
-- local Config = NPL.load("./Config.lua");
-- local CmdParser = commonlib.gettable("MyCompany.Aries.Game.CmdParser");	
-- local Log = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Log");
-- local GeneralGameServerMod = commonlib.gettable("Mod.GeneralGameServerMod");

-- NPL.load("Mod/GeneralGameServerMod/App/Client/AppGeneralGameClient.lua");
-- local AppGeneralGameClient = commonlib.gettable("Mod.GeneralGameServerMod.App.Client.AppGeneralGameClient");

-- function Online:Init()
-- 	NPL.load("(gl)Mod/GeneralGameServerMod/main.lua");                                    -- 此行可省略 GGS是内置模块, 程序启动会自动加载
-- 	local GeneralGameServerMod = commonlib.gettable("Mod.GeneralGameServerMod");      -- 获取GGS模块

-- 	NPL.load("(gl)Mod/CodePku/online/OnlineClient.lua");
-- 	local OnlineClient = commonlib.gettable("Mod.CodePku.Online.OnlineClient");
-- 	GeneralGameServerMod:RegisterClientClass("CodePku", OnlineClient);

-- 	self:RegisterCommand();
-- end


-- function Online:RegisterCommand()
--     Commands["connectCodePku"] = {
-- 		mode_deny = "",  
-- 		name="connectCodePku",
-- 		quick_ref="/connectCodePku [worldId] [parallelWorldName]", 
-- 		desc=[[进入联机玩学世界 
-- worldId 为世界ID(未指定或为0则联机当前世界或默认世界)
-- parallelWorldName 平行世界名, 可选. 指定世界的副本世界
-- 示例:
-- connectCodePku                        # 联机进入当前世界或默认世界
-- connectCodePku 145                    # 联机进入世界ID为145的世界
-- connectCodePku 145 parallel           # 联机进入世界ID为145的平行世界 parallel
-- ]], 
-- 		handler = function(cmd_name, cmd_text, cmd_params, fromEntity)		
--             Log:Info("run cmd: %s %s", cmd_name, cmd_text);
--             local ggsCmd = string.format("/ggs connect -app=CodePku %s", cmd_text);
--             Log:Info("run ggs connect cmd: %s", ggsCmd);
--             GameLogic.RunCommand(string.format("/ggs connect -app=CodePku %s", cmd_text));
-- 		end,
-- 	}
-- end
NPL.load("(gl)Mod/GeneralGameServerMod/main.lua"); 
NPL.load("(gl)Mod/CodePku/online/client/GeneralGameClient.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");

local GeneralGameServerMod = commonlib.gettable("Mod.GeneralGameServerMod");
local GeneralGameClient = commonlib.gettable("Mod.CodePku.Online.Client.GeneralGameClient");
local Online = commonlib.gettable("Mod.CodePku.Online");
local Commands = commonlib.gettable("MyCompany.Aries.Game.Commands");
local Log = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Log");

function Online:Init()
	GeneralGameServerMod:RegisterClientClass("CodePku", GeneralGameClient);
	self:RegisterCommand();
end
function Online:RegisterCommand()
    Commands["connectCodePku"] = {
		mode_deny = "",  
		name="connectCodePku",
		quick_ref="/connectCodePku [worldId] [parallelWorldName]", 
		desc=[[进入联机玩学世界 
worldId 为世界ID(未指定或为0则联机当前世界或默认世界)
parallelWorldName 平行世界名, 可选. 指定世界的副本世界
示例:
connectCodePku                        # 联机进入当前世界或默认世界
connectCodePku 145                    # 联机进入世界ID为145的世界
connectCodePku 145 parallel           # 联机进入世界ID为145的平行世界 parallel
]], 
		handler = function(cmd_name, cmd_text, cmd_params, fromEntity)		
            Log:Info("run cmd: %s %s", cmd_name, cmd_text);
            local ggsCmd = string.format("/ggs connect -app=CodePku %s", cmd_text);
            Log:Info("run ggs connect cmd: %s", ggsCmd);
            GameLogic.RunCommand(string.format("/ggs connect -app=CodePku %s", cmd_text));
		end,
	}
end
