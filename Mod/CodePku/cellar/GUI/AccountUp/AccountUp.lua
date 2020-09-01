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

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local AccountUp = commonlib.gettable("Mod.CodePku.AccountUp")

AccountUp.ui = nil

function AccountUp.OnSureBtnCLicked(  )
    local data = {
        mobile = "",
        verifiy_code = "",
        mobile_token = "",
    }
    request:get('/users/mobile', data):next(function(response)
		if (response.status == 200 and response.data.code == 200) then
            
        elseif response.data and response.data.message then
            GameLogic.AddBBS("CodeGlobals", response.data.message, 3000, "#00FF00");
        end		
    end)
end

-- 获取手机验证码
function AccountUp.GetMobileCode( page )


    if AccountUp.isClickedGetPhoneCaptcha then
        return false 
    end

    AccountUp.isClickedGetPhoneCaptcha = true
    
    -- Mod.CodePku.MsgBox:Show(L"正在获取验证码...", 8000, L"链接超时", 300, 120)

    local times = 60

    local timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            page:SetValue("get_mobile_code_text", format("%s(%ds)", L"重新发送", times))

            if times == 0 then
                AccountUp.isClickedGetPhoneCaptcha = false
                page:SetValue("get_mobile_code_text", L"获取验证码")
                timer:Change(nil, nil)
            end

            times = times - 1
        end
    })

    timer:Change(1000, 1000)


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
    end
    AccountUp.ui = AdaptWindow:QuickWindow(params)
end