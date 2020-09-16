--[[
Title: 联机配置
Author(s): John Mai
Date: 2020-07-10 16:23:49
Desc: 玩学世界联机配置
Example:
------------------------------------------------------------
local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");
-------------------------------------------------------
]]

local Config = NPL.export()

Config.env = {
  ONLINE = "ONLINE",
  STAGE = "STAGE",
  STAGING = "STAGING",
  DEV = "DEV",
  RELEASE = "RELEASE",
  LOCAL = "LOCAL"
}

Config.defaultEnv = (ParaEngine.GetAppCommandLineByParam("codepkuenv", nil) or Config.env.RELEASE)

Config.onlineServer = {
    [Config.env.DEV] = {
        host = "gameserver.dev.codepku.com",
        port = 9900,
        defaultWorldId = 1
    },
    [Config.env.RELEASE] = {
        host = "steve.codemc.cn",
        port = 9900
    },
    [Config.env.LOCAL] = {
        host = "gameserver.dev.codepku.com",
        port = 9900,
        defaultWorldId = 1
    },
};

Config.defaultOnlineServer = Config.onlineServer[Config.defaultEnv];