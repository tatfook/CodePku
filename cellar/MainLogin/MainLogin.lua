--[[
Title: Main Login
Author: big  
Date: 2019.12.25
place: Foshan
Desc: 
use the lib:
------------------------------------------------------------
local MainLogin = NPL.load("(gl)Mod/WorldShare/cellar/MainLogin/MainLogin.lua")
------------------------------------------------------------
]]
local ParaWorldLessons = commonlib.gettable("MyCompany.Aries.Game.MainLogin.ParaWorldLessons")
local GameMainLogin = commonlib.gettable("MyCompany.Aries.Game.MainLogin")

local CodePkuServiceSession = NPL.load("(gl)Mod/CodePku/service/CodePkuService/Session.lua")
local CodePkuService = NPL.load("(gl)Mod/CodePku/service/CodePkuService.lua")
local SessionsData = NPL.load("(gl)Mod/CodePku/database/SessionsData.lua")

local MainLogin = NPL.export()

function MainLogin:Show()
    Mod.CodePku.Utils.ShowWindow({
        url = "Mod/CodePku/cellar/MainLogin/MainLogin.html", 
        name = "MainLogin", 
        isShowTitleBar = false,
        DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
        style = CommonCtrl.WindowFrame.ContainerStyle,
        zorder = -1,
        allowDrag = false,
        directPosition = true,
            align = "_fi",
            x = 0,
            y = 0,
            width = 0,
            height = 0,
        cancelShowAnimation = true,
    })

    local MainLoginPage = Mod.CodePku.Store:Get('page/MainLogin')
    
    if not MainLoginPage then
        return false
    end

    local PWDInfo = CodePkuServiceSession:LoadSigninInfo()

    if PWDInfo then
        MainLoginPage:SetValue('autoLogin', PWDInfo.autoLogin or false)
        MainLoginPage:SetValue('rememberMe', PWDInfo.rememberMe or false)
        MainLoginPage:SetValue('password', PWDInfo.password or '')
        MainLoginPage:SetValue('showaccount', PWDInfo.account or '')

        self.loginServer = PWDInfo.loginServer
        self.account = PWDInfo.account
    end

    self:Refresh()

    if not self.notFirstTimeShown then
        self.notFirstTimeShown = true

        if System.User.codepkuToken then
            Mod.CodePku.MsgBox:Show(L"正在登陆，请稍后...", 8000, L"链接超时", 300, 120)

            CodePkuServiceSession:LoginWithToken(
                System.User.codepkuToken,
                function(response, err)
                    Mod.CodePku.MsgBox:Close()

                    if(err == 200 and type(response) == "table" and response.username) then
                        self:EnterUserConsole()
                    else
                        -- token expired
                        System.User.codepkuToken = nil;
                    end
                end
            )

            return
        end

        if PWDInfo and PWDInfo.autoLogin then
            Mod.CodePku.Utils.SetTimeOut(function()
                self:EnterUserConsole()
            end, 100)
        end
    end
end

function MainLogin:Refresh(times)
    local MainLoginPage = Mod.CodePku.Store:Get('page/MainLogin')

    if MainLoginPage then
        MainLoginPage:Refresh(times or 0.01)
    end
end

function MainLogin:Close()
    local MainLoginPage = Mod.CodePku.Store:Get('page/MainLogin')

    if MainLoginPage then
        MainLoginPage:CloseWindow()
    end
end

function MainLogin:LoginAction()            
    local MainLoginPage = Mod.CodePku.Store:Get("page/MainLogin")

    if not MainLoginPage then
        return false
    end
    
    local loginServer = CodePkuService:GetEnv()    
    local account = MainLoginPage:GetValue("account")
    local verify_code = MainLoginPage:GetValue("verify_code")    

    if not account or account == "" then
        GameLogic.AddBBS(nil, L"账号不能为空", 3000, "255 0 0")
        return false
    end

    if not verify_code or verify_code == "" then
        GameLogic.AddBBS(nil, L"验证码不能为空", 3000, "255 0 0")
        return false
    end

    if not loginServer then
        return false
    end

    Mod.CodePku.MsgBox:Show(L"正在登陆，请稍后...", 8000, L"链接超时", 300, 120)

    local function HandleLogined()
        LOG.std('handle logined', "info", "codepku")
        Mod.CodePku.MsgBox:Close()
        local token = Mod.CodePku.Store:Get("user/token") or ""

        CodePkuServiceSession:SaveSigninInfo(
            {
                loginServer = loginServer,
                account = account,               
                token = token,                
            }
        )
        
        LOG.std('save sign in info')
        self:EnterUserConsole()

        if not Mod.CodePku.Store:Get('user/isVerified') then
            -- RegisterModal:ShowBindingPage()
        end

        local AfterLogined = Mod.CodePku.Store:Get('user/AfterLogined')

        if type(AfterLogined) == 'function' then
            AfterLogined(true)
            Mod.CodePku.Store:Remove('user/AfterLogined')
        end
    end

    
    CodePkuServiceSession:Login(
        account,
        verify_code,
        function(response, err)                        
            if err == 503 then
                Mod.CodePku.MsgBox:Close()
                return false
            end

            CodePkuServiceSession:LoginResponse(response, err, HandleLogined)
        end
    )
end

function MainLogin:EnterUserConsole()
    ParaWorldLessons.CheckShowOnStartup(function(bBeginLessons)
        if not bBeginLessons then
            System.options.loginmode = "local"

            local MainLoginPage = Mod.CodePku.Store:Get("page/MainLogin")

            if MainLoginPage then
                MainLoginPage:CloseWindow()
            end

            GameMainLogin:next_step({IsLoginModeSelected = true})
        end
    end)
end

function MainLogin:SetAutoLogin()
    local LoginModalPage = Mod.CodePku.Store:Get("page/LoginModal")

    if not LoginModalPage then
        return false
    end

    local autoLogin = LoginModalPage:GetValue("autoLogin")
    local rememberMe = LoginModalPage:GetValue("rememberMe")
    local password = LoginModalPage:GetValue("password")
    self.loginServer = CodePkuService:GetEnv()
    self.account = string.lower(LoginModalPage:GetValue("account"))

    if autoLogin then
        LoginModalPage:SetValue("rememberMe", true)
    else
        LoginModalPage:SetValue("rememberMe", rememberMe)
    end
    
    LoginModalPage:SetValue("autoLogin", autoLogin)
    LoginModalPage:SetValue("password", password)

    self:Refresh()
end

function MainLogin:SetRememberMe()
    local LoginModalPage = Mod.CodePku.Store:Get("page/LoginModal")

    if not LoginModalPage then
        return false
    end

    local loginServer = CodePkuService:GetEnv()
    local password = LoginModalPage:GetValue("password")
    local rememberMe = LoginModalPage:GetValue("rememberMe")
    self.loginServer = CodePkuService:GetEnv()
    self.account = string.lower(LoginModalPage:GetValue("account"))

    if rememberMe then
        LoginModalPage:SetValue("autoLogin", autoLogin)
    else
        LoginModalPage:SetValue("autoLogin", false)
    end

    LoginModalPage:SetValue("rememberMe", rememberMe)
    LoginModalPage:SetValue("password", password)

    self:Refresh()
end

function MainLogin:GetHistoryUsers()
    LOG.std('history users', "info", "codepku", NPL.ToJson(SessionsData:GetSessions().allUsers))
    if self.account and #self.account > 0 then
        local allUsers = commonlib.Array:new(SessionsData:GetSessions().allUsers)
        local beExist = false

        for key, item in ipairs(allUsers) do
            item.selected = nil

            if item.value == self.account then
                item.selected = true
                beExist = true
            end
        end

        if not beExist then
            allUsers:push_front({ text = self.account, value = self.account, selected = true })
        end

        return allUsers
    else
        return SessionsData:GetSessions().allUsers
    end
end

function MainLogin:SelectAccount(username)
    local MainLoginPage = Mod.CodePku.Store:Get('page/MainLogin')

    if not MainLoginPage then
        return false
    end

    local session = SessionsData:GetSessionByUsername(username)

    if not session then
        return false
    end

    self.loginServer = session and session.loginServer or 'ONLINE'
    self.account = session and session.account or ''

    MainLoginPage:SetValue("autoLogin", session.autoLogin)
    MainLoginPage:SetValue("rememberMe", session.rememberMe)
    MainLoginPage:SetValue("password", session.password)
    MainLoginPage:SetValue('showaccount', session.account or '')

    self:Refresh()
end

function MainLogin:RemoveAccount(username)
    local MainLoginPage = Mod.CodePku.Store:Get('page/MainLogin')

    if not MainLoginPage then
        return false
    end

    SessionsData:RemoveSession(username)

    if self.account == username then
        self.account = nil
        self.loginServer = nil

        MainLoginPage:SetValue("autoLogin", false)
        MainLoginPage:SetValue("rememberMe", false)
        MainLoginPage:SetValue("password", "")
        MainLoginPage:SetValue("showaccount", "")
    end

    self:Refresh()
end

function MainLogin:getMobileCode()
    local MainLoginPage = Mod.CodePku.Store:Get("page/MainLogin")

    if not MainLoginPage then
        return false
    end
        
    local mobile = MainLoginPage:GetValue("account")
    LOG.std(nil, "info", "codepku", "get mobile code: %s", mobile)

    if not mobile or mobile == "" then
        GameLogic.AddBBS(nil, L"手机号码不能为空", 3000, "255 0 0")
        return false
    end

    Mod.CodePku.MsgBox:Show(L"正在获取验证码...", 8000, L"链接超时", 300, 120)

    CodePkuServiceSession:getMobileCode(
        mobile, 
        function (response, err)
            echo(err, true)    
            Mod.CodePku.MsgBox:Close()       
            GameLogic.AddBBS(nil, L"验证码获取成功", 3000, "255 0 0")         
            LOG.std(nil, "info", "codepku", "get mobile code success")            
            return false
        end
    )
end