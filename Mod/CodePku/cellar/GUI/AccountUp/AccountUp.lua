--[[
    author:{zouren}
    time:2020-09-01 09:03:56
    des:游客账号升级界面
    use:
        NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/AccountUp.lua")
        local AccountUp = commonlib.gettable("Mod.CodePku.AccountUp")
        AccountUp.ShowPage()
]]
NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/AccountUp.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local CodePkuServiceSession = NPL.load("(gl)Mod/CodePku/service/CodePkuService/Session.lua")
local Config = NPL.load("(gl)Mod/CodePku/config/Config.lua")

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local AccountUp = commonlib.gettable("Mod.CodePku.AccountUp")

AccountUp.ui = nil

function AccountUp.OnSureBtnCLicked(page)
    if not AccountUp.mobileToken then
        GameLogic.AddBBS(nil, L"请先获取验证码", 3000, "255 0 0", 21)
    end
    local account = page:GetValue("account")
    local verifiy_code = page:GetValue("verifiy_code")
    local data = {
        mobile = account,
        verifiy_code = verifiy_code,
        mobile_token = AccountUp.mobileToken,
    }
    request:get('/users/mobile', data):next(function(response)
		if (response.status == 200 and response.data.code == 200) then
            -- 绑定后的数据处理
        elseif response.data and response.data.message then
            GameLogic.AddBBS("CodeGlobals", response.data.message, 3000, "#00FF00");
        end		
    end)
end

-- 获取手机验证码
function AccountUp.GetMobileCode( page )
    if not page then
        return
    end

    local account = page:GetValue("account")
    LOG.std(nil, "AccountUp", "GetMobileCode", "account = %s", tostring(account))

    if account and #account ~= 11 then
        GameLogic.AddBBS(nil, L"手机号码位数不对", 3000, "255 0 0", 21)
        return false
    end

    if (not account) or account == "" then
        GameLogic.AddBBS(nil, L"手机号码不能为空", 3000, "255 0 0", 21)
        return false
    end

    if AccountUp.isClickedGetPhoneCaptcha then
        return 
    end
    AccountUp.isClickedGetPhoneCaptcha = true
    local times = 60
    local timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            page:SetValue("GetMobileCodeBtn", format("%s(%ds)", L"重新发送", times))
            if times == 0 then
                AccountUp.isClickedGetPhoneCaptcha = false
                page:SetValue("GetMobileCodeBtn", L"获取验证码")
                timer:Change(nil, nil)
            end

            times = times - 1
        end
    })
    timer:Change(1000, 1000)

    CodePkuServiceSession:getMobileCode(
        account,
        function ( response, err )
            if err == 200 then
                Mod.CodePku.MsgBox:Close()
                if Config.defaultEnv == Config.env.RELEASE then
                    GameLogic.AddBBS(nil, L"验证码获取成功", 3000, "255 0 0", 21)
                else
                    GameLogic.AddBBS(nil, L("验证码是："..response.data.code), 7000, "255 0 0", 21)
                end
                LOG.std(nil, "AccountUp", "GetMobileCode", "get mobile code success")
                local mobileToken = response.data.mobile_token
                AccountUp.mobileToken = mobileToken
                -- MainLoginPage:SetValue('mobile_token', mobileToken)
                return true
            else 
                local errMsg = response.message or "获取验证码失败"
                -- Mod.CodePku.MsgBox:Close()
                GameLogic.AddBBS(nil, errMsg, 3000, "255 0 0", 21)
                return false  
            end
        end
    )
end

function AccountUp.OnCancelBtnClicked()
    if AccountUp.ui then
        AccountUp.ui:CloseWindow()
    end
end

function AccountUp.ShowPage()
    local params = {
        url = "Mod/CodePku/cellar/GUI/AccountUp/AccountUp.html",
        name = "AccountUpPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        alignment="_ct",
        left = -960,
        top = -540,
        width = 1920,
        height = 1080,
        zorder = 30,
    }
    if AccountUp.ui then
        AccountUp.ui:CloseWindow()
        AccountUp.mobileToken = nil
    end
    AccountUp.ui = AdaptWindow:QuickWindow(params)
end