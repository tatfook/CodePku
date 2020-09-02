--[[
Title: SessionsData
Author(s):  big
Date: 2019.07.24
place: Foshan
Desc: 
use the lib:
------------------------------------------------------------
local SessionsData = NPL.load("(gl)Mod/CodePku/database/SessionsData.lua")
------------------------------------------------------------
]] local Utils = NPL.load("(gl)Mod/CodePku/helper/Utils.lua")
local Store = NPL.load("(gl)Mod/CodePku/store/Store.lua")

local SessionsData = NPL.export()

-- session struct
--[[
{
    selectedUser = "1111",
    allUsers = {
        {
            value = "1111",
            text = "1111",
            session = {
                account = "1111",
                loginServer = "ONLINE",
                password = "12345678",
                autoLogin = true,
                rememberMe = true,
                token = "jwttoken"
            }
        },
        {
            value = "2222",
            text = "2222",
            session = {
                account = "2222",
                loginServer = "STAGE",
                autoLogin = false,
                rememberMe = true,
                token = "jwttoken"
            }
        },
        {
            value = "3333",
            text = "3333",
            session = {
                account = "3333",
                loginServer = "ONLINE",
                autoLogin = false,
                rememberMe = false,
                password = "123456",
                token = "jwttoken"
            }
        },
    }
}
]]
function SessionsData:GetSessions()
    local playerController = GameLogic.GetPlayerController()

    return playerController:LoadLocalData("sessions", {
        selectedUser = "",
        allUsers = {}
    }, true)
end

function SessionsData:RemoveSession(username)
    local sessionsData = self:GetSessions()

    if sessionsData.selectedUser == username then
        sessionsData.selectedUser = ""
    end

    local newAllUsers = commonlib.Array:new(sessionsData.allUsers);

    for key, item in ipairs(newAllUsers) do
        if item.value == username then
            newAllUsers:remove(key)
            break
        end
    end

    sessionsData.allUsers = newAllUsers

    GameLogic.GetPlayerController():SaveLocalData("sessions", sessionsData, true)
end

function SessionsData:SaveSession(session)
    if not session or not session.account or not session.loginServer then
        return false
    end

    session.account = string.lower(session.account)

    local sessionsData = self:GetSessions()
    sessionsData.selectedUser = session.account

    local beExist = false

    for key, item in ipairs(sessionsData.allUsers) do
        if item.value == session.account then
            item.session = session
            beExist = true
        end
    end

    if not beExist then
        sessionsData.allUsers[#sessionsData.allUsers + 1] = {
            value = session.account,
            text = session.account,
            session = session
        }
    end

    GameLogic.GetPlayerController():SaveLocalData("sessions", sessionsData, true)
end

function SessionsData:ChangeVisitorToUser( account )
    if not account then
        return false
    end

    account = string.lower(account)

    local sessionsData = self:GetSessions()
    -- 空字符串是为那天的紧急版本上线买单  以后时间久了可以直接去了
    if sessionsData.selectedUser == "quickLogin" or sessionsData.selectedUser == "" then
    -- if sessionsData.selectedUser == "quickLogin" then
        sessionsData.selectedUser = account
    else
        return false
    end

    for key, item in ipairs(sessionsData.allUsers) do
        if item.value == "quickLogin" or item.value == "" then
            item.session.account = account
            item.value = account
            item.text = account
        end
    end

    GameLogic.GetPlayerController():SaveLocalData("sessions", sessionsData, true)
end

function SessionsData:GetSessionByUsername(username)
    local sessionsData = SessionsData:GetSessions()

    if not sessionsData or not sessionsData.allUsers then
        return false
    end

    for key, item in ipairs(sessionsData.allUsers) do
        if item.value == username then
            return item.session
        end
    end

    return false
end
