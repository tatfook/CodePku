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
        SetUserinfo = function(token, userId, mobile, nickname)
            -- username => mobile
            self.token = token
            self.userId = userId
            self.username = mobile
            self.nickname = nickname
            self.mobile = mobile

            commonlib.setfield("System.User.codepkuToken", token)
            commonlib.setfield("System.User.mobile", mobile)
            commonlib.setfield("System.User.username", mobile)
            commonlib.setfield('System.User.id', userId)            
            commonlib.setfield("System.User.nickName", nickname)            
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

            commonlib.setfield("System.User.codepkuToken", nil)
            commonlib.setfield("System.User.mobile", nil)
            commonlib.setfield("System.User.username", nil)
            commonlib.setfield("System.User.id", nil)            
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