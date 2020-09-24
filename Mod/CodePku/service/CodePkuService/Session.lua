--[[
Title: KeepworkService Session
Author(s):  big
Date:  2019.09.22
Place: Foshan
use the lib:
------------------------------------------------------------
local KeepworkServiceSession = NPL.load("(gl)Mod/WorldShare/service/KeepworkService/Session.lua")
------------------------------------------------------------
]]

local CodePkuService = NPL.load("(gl)Mod/CodePku/service/CodePkuService.lua")
local CodePkuUsersApi = NPL.load("(gl)Mod/CodePku/api/Codepku/Users.lua")
local CodePkuWorldsApi = NPL.load("(gl)Mod/CodePku/api/Codepku/Worlds.lua")
local SessionsData = NPL.load("(gl)Mod/CodePku/database/SessionsData.lua")
local Config = NPL.load("(gl)Mod/CodePku/config/Config.lua")

local Encoding = commonlib.gettable("commonlib.Encoding")

local CodePkuServiceSession = NPL.export({});

CodePkuServiceSession.captchaKey = ''

function CodePkuServiceSession:Login(account, verifyCode, mobileToken, visitorId, callback)
    CodePkuUsersApi:Login(account, verifyCode, mobileToken, visitorId, callback, callback)
end

function CodePkuServiceSession:LoginWithPwd(account, password, callback)
    CodePkuUsersApi:LoginWithPwd(account, password, callback, callback)
end

function CodePkuServiceSession:QuickLogin(visitor_id, app_market, callback)
    CodePkuUsersApi:QuickLogin(visitor_id, app_market, callback, callback)
end

function CodePkuServiceSession:LoginWithToken(token, callback)
    CodePkuUsersApi:LoginWithToken(token, callback, callback)
end

function CodePkuServiceSession:LoginResponse(response, err, callback)    
    if err == 400 or err == 422 or err == 500 then
        Mod.CodePku.MsgBox:Close()
        local errorMsg = response.message or "用户名或者密码错误"
        GameLogic.AddBBS(nil, errorMsg, 3000, "255 0 0", 21)
        return false
    end

    if type(response) ~= "table" then
        Mod.CodePku.MsgBox:Close()
        GameLogic.AddBBS(nil, L"服务器连接失败", 3000, "255 0 0", 21)
        return false
    end
    
    local token = response["data"]["token"] or System.User.codepkuToken
    local userId = response["data"]["id"] or 0    
    local nickname = response["data"]["nickname"] or ""
    local mobile = response["data"]["mobile"] or ""


    if response.vip and response.vip == 1 then
        Mod.CodePku.Store:Set("user/userType", 'vip')
    elseif response.tLevel and response.tLevel > 0 then
        Mod.CodePku.Store:Set("user/userType", 'teacher')
        Mod.CodePku.Store:Set("user/tLevel", response.tLevel)
    else
        Mod.CodePku.Store:Set("user/userType", 'plain')
    end

    local SetUserinfo = Mod.CodePku.Store:Action("user/SetUserinfo")
    SetUserinfo(token, response.data)    
    if type(callback) == "function" then
        callback()
    end
    self:ResetIndulge()
end

function CodePkuServiceSession:Logout()
    if CodePkuService:IsSignedIn() then
        local account = CodePkuService:GetAccount()
        SessionsData:RemoveSession(account)
        local Logout = Mod.CodePku.Store:Action("user/Logout")
        Logout()
        self:ResetIndulge()
    end
end

function CodePkuServiceSession:GetPhoneCaptcha(phone, callback)
    if not phone or type(phone) ~= 'string' then
        return false
    end

    CodePkuUsersApi:CellphoneCaptcha(phone, callback, callback)
end


-- @param usertoken: keepwork user token
function CodePkuServiceSession:Profile(callback, token)
    CodePkuUsersApi:Profile(token, callback, callback)
end

function CodePkuServiceSession:GetCurrentUserToken()
    if Mod.CodePku.Store:Get("user/token") then
        return Mod.CodePku.Store:Get("user/token")
    else
        return System.User and System.User.codepkuToken
    end
end

-- @param info: if nil, we will delete the login info.
function CodePkuServiceSession:SaveSigninInfo(info)
    if not info then
        return false
    end    

    SessionsData:SaveSession(info)
end

-- @return nil if not found or {account, password, loginServer, autoLogin}
function CodePkuServiceSession:LoadSigninInfo()
    local sessionsData = SessionsData:GetSessions()

    if sessionsData and sessionsData.selectedUser then
        for key, item in ipairs(sessionsData.allUsers) do
            if item.value == sessionsData.selectedUser then
                return item.session
            end
        end
    else
        return nil
    end
end

-- return nil or user token in url protocol
function CodePkuServiceSession:GetUserTokenFromUrlProtocol()
    local cmdline = ParaEngine.GetAppCommandLine()
    local urlProtocol = string.match(cmdline or "", "paracraft://(.*)$")
    urlProtocol = Encoding.url_decode(urlProtocol or "")

    local usertoken = urlProtocol:match('usertoken="([%S]+)"')

    if usertoken then
        local SetToken = Mod.CodePku.Store:Action("user/SetToken")
        SetToken(usertoken)
    end

    return usertoken
end

function CodePkuServiceSession:CheckTokenExpire(callback)
    if not CodePkuService:IsSignedIn() then
        return false
    end
    
    local token = Mod.CodePku.Store:Get('user/token')
    local tokeninfo = System.Encoding.jwt.decode(token)
    local exp = tokeninfo.exp and tokeninfo.exp or 0

    local function ReEntry()
        self:Logout()

        local currentUser = self:LoadSigninInfo()

        if not currentUser or not currentUser.account or not currentUser.password then
            return false
        end

        self:Login(
            currentUser.account,
            currentUser.password,
            function(response, err)
                if err ~= 200 then
                    if type(callback) == "function" then
                        callback(false)
                    end
                    return false
                end

                self:LoginResponse(response, err, function()
                    if type(callback) == "function" then
                        callback(true)
                    end
                end)
            end
        )
    end

    -- we will not fetch token if token is expire
    if exp <= (os.time() + 1 * 24 * 3600) then
        ReEntry()
        return false
    end

    self:Profile(function(data, err)
        if err ~= 200 then
            ReEntry()
            return false
        end

        if type(callback) == "function" then
            callback(true)
        end
    end, token)
end

function CodePkuServiceSession:RenewToken()
    self:CheckTokenExpire()

    Mod.CodePku.Utils.SetTimeOut(function()
        self:RenewToken()
    end, 3600 * 1000)
end

function CodePkuServiceSession:PreventIndulge(callback)
    local function Handle()
        local times = 1000
        self.gameTime = (self.gameTime or 0) + 1

        -- 40 minutes
        if self.gameTime == (40 * 60) then
            if type(callback) == 'function' then
                callback('40MINS')
            end
        end

        -- 2 hours
        if self.gameTime == (2 * 60 * 60) then
            if type(callback) == 'function' then
                callback('2HOURS')
            end
        end

        -- 4 hours
        if self.gameTime == (4 * 60 * 60) then
            if type(callback) == 'function' then
                callback('4HOURS')
            end
        end

        -- 22:30
        if os.date("%H:%M", os.time()) == '22:30' then
            if type(callback) == 'function' then
                callback('22:30')
            end

            times = 60 * 1000
        end

        Mod.CodePku.Utils.SetTimeOut(function()
            Handle()
        end, times)
    end

    Handle()
end

function CodePkuServiceSession:ResetIndulge()
    self.gameTime = 0
end

function CodePkuServiceSession:getMobileCode(mobile, callback)        
    CodePkuUsersApi:GetMobileCode(mobile, callback, callback)
end

function CodePkuServiceSession:CourseEntryWorld(callback)
    CodePkuWorldsApi:GetCourseEntryWorld(callback, callback)
end

function CodePkuServiceSession:CourseWorldByKeepworkId(keepworkProjectId, callback)
    CodePkuWorldsApi:GetByKeepworkProjectId(keepworkProjectId, callback, callback)
end