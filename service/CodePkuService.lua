--[[
Title: KeepworkService
Author(s):  big
Date:  2018.06.21
Place: Foshan
use the lib:
------------------------------------------------------------
local KeepworkService = NPL.load("(gl)Mod/WorldShare/service/KeepworkService.lua")
------------------------------------------------------------
]]


local Config = NPL.load("(gl)Mod/CodePku/config/Config.lua")
local CodePkuService = NPL.export({});

function CodePkuService:GetEnv()
    for key, item in pairs(Config.env) do
        if key == Config.defaultEnv then
            return Config.defaultEnv
        end
    end

	return Config.env.ONLINE
end

function CodePkuService:IsSignedIn()
    local token = Mod.CodePku.Store:Get("user/token")

    return token ~= nil
end

function CodePkuService:GetToken()
    local token = Mod.CodePku.Store:Get('user/token')

    return token or ''
end

function CodePkuService:GetAccount()
    local account = Mod.CodePku.Store:Get('user/username') or System.User.username
    return account or ''
end