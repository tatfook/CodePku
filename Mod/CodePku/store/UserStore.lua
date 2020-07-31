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
        SetUserinfo = function(token, user)            
            if type(user) ~= 'table' then
                return false;
            end
            -- username => mobile
            self.token = token or System.User.codepkuToken
            self.userId = user.id
            self.username = user.mobile
            self.nickname = user.nickname
            self.mobile = user.mobile
            self.info = user

            commonlib.setfield("System.User.codepkuToken", token)
            commonlib.setfield("System.User.mobile", user.mobile)
            commonlib.setfield("System.User.username", user.username or user.mobile)
            commonlib.setfield('System.User.id', user.id)
            commonlib.setfield("System.User.nickName", user.nickname)
            commonlib.setfield("System.User.info", user)  
        end,
        SetPlayerController = function(playerController)
            self.playerController = playerController
        end,
        Logout = function()
            self.token = nil
            self.userId = nil
            self.username = nil
            self.nickname = nil    
            self.mobile = nil
            self.info = nil      

            commonlib.setfield("System.User.codepkuToken", nil)
            commonlib.setfield("System.User.mobile", nil)
            commonlib.setfield("System.User.username", nil)
            commonlib.setfield("System.User.id", nil)            
            commonlib.setfield("System.User.nickName", nil)
            commonlib.setfield("System.User.info", nil)
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