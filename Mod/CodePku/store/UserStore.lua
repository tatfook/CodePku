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
local Config = NPL.load("(gl)Mod/Codepku/config/Config.lua")

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
            self.random_name = user.random_name
            self.isvisitor = user.visitor_id and (user.mobile == nil)
            self.info = user

            
            commonlib.setfield("System.User.codepkuToken", token or System.User.codepkuToken)
            commonlib.setfield("System.User.mobile", user.mobile)
            commonlib.setfield("System.User.username", user.nickname or user.no)
            commonlib.setfield('System.User.id', user.id)
            commonlib.setfield("System.User.nickName", user.nickname)
            commonlib.setfield("System.User.randomName", user.random_name)
            commonlib.setfield("System.User.isVisitor", self.isvisitor)
            commonlib.setfield("System.User.info", user)

            -- if Config.defaultEnv ~= Config.env.DEV then
                GameLogic.GetFilters():add_filter(
                    "HandleGlobalKeyByRETURN",
                    function()
                        return user.is_employee == 0;
                    end
                );
            
                GameLogic.GetFilters():add_filter(
                    "HandleGlobalKeyBySLASH",
                    function()
                        return user.is_employee == 0;
                    end
                );
            -- end
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
            self.random_name = nil
            self.isvisitor = nil
            self.info = nil      

            commonlib.setfield("System.User.codepkuToken", nil)
            commonlib.setfield("System.User.mobile", nil)
            commonlib.setfield("System.User.username", nil)
            commonlib.setfield("System.User.id", nil)            
            commonlib.setfield("System.User.nickName", nil)
            commonlib.setfield("System.User.randomName", nil)
            commonlib.setfield("System.User.isVisitor", nil)
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