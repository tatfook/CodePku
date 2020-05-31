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

    if CodePkuService:IsSignedIn() then
        self:EnterUserConsole()
    end

    local PWDInfo = CodePkuServiceSession:LoadSigninInfo()
    echo(PWDInfo)
    local token = System.User.codepkuToken or PWDInfo and PWDInfo.token    
       
    if token then
        Mod.CodePku.MsgBox:Show(L"正在登录，请稍后...", 8000, L"链接超时", 300, 120)
        CodePkuServiceSession:LoginWithToken(
            token,
            function(response, err)
                Mod.CodePku.MsgBox:Close()
                if err == 200 then                    
                    local userId = response["data"]["id"] or 0    
                    local nickname = response["data"]["nickname"] or ""
                    local mobile = response["data"]["mobile"] or ""
                    local SetUserinfo = Mod.CodePku.Store:Action("user/SetUserinfo")

                    SetUserinfo(token, userId, mobile, nickname)
                    Mod.CodePku.Utils.SetTimeOut(function()
                        self:EnterUserConsole()
                    end, 100)  
                else
                    if PWDInfo and PWDInfo.account then
                        SessionsData:RemoveSession(PWDInfo.account)
                    end
                end
            end
        )        
    end

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


    if PWDInfo then
        MainLoginPage:SetValue('account', PWDInfo.account or '')

        self.loginServer = PWDInfo.loginServer
        self.account = PWDInfo.account
    end

    self:Refresh()    
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
    local verifyCode = MainLoginPage:GetValue("verify_code")  
    local mobileToken = MainLoginPage:GetValue('mobile_token')  

    if not account or account == "" then
        GameLogic.AddBBS(nil, L"账号不能为空", 3000, "255 0 0")
        return false
    end

    if not verifyCode or verifyCode == "" then
        GameLogic.AddBBS(nil, L"验证码不能为空", 3000, "255 0 0")
        return false
    end

    if not mobileToken or mobileToken == "" then
        GameLogic.AddBBS(nil, L"请先获取验证码", 3000, "255 0 0")
        return false
    end

    if not loginServer then
        return false
    end

    Mod.CodePku.MsgBox:Show(L"正在登录，请稍后...", 8000, L"链接超时", 300, 120)

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

        local AfterLogined = Mod.CodePku.Store:Get('user/AfterLogined')

        if type(AfterLogined) == 'function' then
            AfterLogined(true)
            Mod.CodePku.Store:Remove('user/AfterLogined')
        end
    end

    
    CodePkuServiceSession:Login(
        account,
        verifyCode,
        mobileToken,
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
            if err == 200 then  
                Mod.CodePku.MsgBox:Close()       
                GameLogic.AddBBS(nil, L"验证码获取成功", 3000, "255 0 0")         
                LOG.std(nil, "info", "codepku", "get mobile code success")
                local mobileToken = response.data.mobile_token
                MainLoginPage:SetValue('mobile_token', mobileToken)          
                return true
            else 
                local errMsg = response.message or "获取验证码失败"
                Mod.CodePku.MsgBox:Close()   
                GameLogic.AddBBS(nil, errMsg, 3000, "255 0 0")                         
                return false  
            end
        end
    )
end

function MainLogin:ShowLoginBackgroundPage()
    local url = "Mod/CodePku/cellar/MainLogin/LoginBackgroundPage.html"
    System.App.Commands.Call("File.MCMLWindowFrame", {
        url = url, 
        name = "LoginBGPage", 
        isShowTitleBar = false,
        DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        zorder = -2,
        bShow = bShow,
        directPosition = true,
            align = "_fi",
            x = 0,
            y = 0,
            width = 0,
            height = 0,
        cancelShowAnimation = true,
    });	
end

function MainLogin:ShowUserAgreementModal()
    Mod.CodePku.Utils.ShowWindow(472, 307, "Mod/CodePku/cellar/UserAgreement/UserAgreement.html", "UserAgreement")
end