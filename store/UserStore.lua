--[[
Title: user store
Author(s): big
Date: 2018.8.17
City: Foshan 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/WorldShare/store/User.lua")
local UserStore = commonlib.gettable('Mod.WorldShare.store.User')
------------------------------------------------------------
]]

local UserStore = commonlib.gettable('Mod.CodePku.store.User')

function UserStore:Action()
    return {
        SetToken = function(token)
            self.token = token
            commonlib.setfield("System.User.codepkuToken", token)
        end,
        SetUserinfo = function(token, userId, username, nickname)
            self.token = token
            self.userId = userId
            self.username = username
            self.nickname = nickname

            -- if self.userType == 'vip' then
            --     -- true or nil
            --     commonlib.setfield("System.User.isVip", true)
            -- end

            commonlib.setfield("System.User.codepkuToken", token)
            commonlib.setfield("System.User.username", username)
            commonlib.setfield("System.User.codepkuUsername", username)
            commonlib.setfield("System.User.NickName", nickname)
            -- commonlib.setfield("System.User.userType", self.userType)
        end,
        SetPlayerController = function(playerController)
            self.playerController = playerController
        end,
        Logout = function()
            self.token = nil
            self.userId = nil
            self.username = nil
            self.nickname = nil            

            commonlib.setfield("System.User.codepkuToken", nil)
            commonlib.setfield("System.User.username", nil)
            commonlib.setfield("System.User.codepkuUsername", nil)
            commonlib.setfield("System.User.nickName", nil)            
        end
    }
end

function UserStore:Getter()
    return {
        GetPlayerController = function()
            return self.playerController
        end,
        GetClientPassword = function()
            if not self.clientPassword then
                self.clientPassword = os.time()
            end

            return self.clientPassword
        end
    }
end