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
local CodePkuService = NPL.load("(gl)Mod/CodePku/service/CodePkuService.lua")
local Config = NPL.load("(gl)Mod/CodePku/config/Config.lua")
local Feedback = NPL.load("(gl)Mod/CodePku/cellar/GUI/Feedback/Feedback.lua");
local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")

-- 导Editbox是为了改EmptyText的文本颜色，后面帕拉卡如果添加了对应的属性可以改掉这里的代码
NPL.load("(gl)script/ide/System/Windows/Controls/EditBox.lua");
local EditBox = commonlib.gettable("System.Windows.Controls.EditBox");

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local AccountUp = commonlib.gettable("Mod.CodePku.AccountUp")

AccountUp.ui = nil

-- 获取图片 tpye  1 通用；2 游客升级
function AccountUp:GetIconPath(type, index)
    if type == 1 then
        return common1ImageData:GetIconUrl(index)
    elseif type == 2 then
        return escFrameImageData:GetIconUrl(index)
    end
end

function AccountUp.OnSureBtnCLicked(page)
    LOG.std(nil, "AccountUp", "OnSureBtnCLicked", "Enter")
    if not AccountUp.mobileToken then
        GameLogic.AddBBS(nil, L"请先获取验证码", 3000, "255 0 0", 21)
    end
    local account = page:GetValue("account")
    -- local loginServer = CodePkuService:GetEnv()
    -- if not loginServer then
    --     return false
    -- end
    local verify_code = page:GetValue("verify_code")
    local data = {
        mobile = account,
        verify_code = verify_code,
        mobile_token = AccountUp.mobileToken,
    }
    LOG.std(nil, "AccountUp", "OnSureBtnCLicked", "account = %s， verify_code = %s mobile_token = %s", tostring(account), tostring(verify_code), tostring(AccountUp.mobileToken))
    request:patch('/users/mobile', data):next(function(response)
		if (response.status == 200 and response.data.code == 200) then
            -- 将本地游客信息设置为空
            local UUIDData = GameLogic.GetPlayerController():LoadLocalData("UUIDData", {}, true)
            UUIDData.paracraftDir = nil
            UUIDData.softwareUUID = nil
            UUIDData.machineID = nil
            GameLogic.GetPlayerController():SaveLocalData("UUIDData", UUIDData, true)

            -- 将本地的用户信息缓存的游客账号转换成一个正式账号
            local SessionsData = NPL.load("(gl)Mod/CodePku/database/SessionsData.lua")
            SessionsData:ChangeVisitorToUser(account)

            -- 绑定后的数据处理
            LOG.std(nil, "AccountUp", "OnSureBtnCLicked", "succeed account = %s", tostring(account))
            commonlib.setfield("System.User.isVisitor", nil)
            commonlib.setfield("System.User.randomName", nil)
            commonlib.setfield("System.User.mobile", account)
            commonlib.setfield("System.User.info.mobile", account) 

            -- 绑定成功后刷新界面
            page:CloseWindow()
            local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
            MainUIButtons:ShowPage()

            -- 关闭遮罩window
            if Feedback.BG then
                Feedback.BG:CloseWindow()
                Feedback.BG = nil
            end

            GameLogic.AddBBS(nil, L"账号升级成功", 3000, "255 0 0", 21);
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
    -- 关闭遮罩window
    if Feedback.BG then
        Feedback.BG:CloseWindow()
        Feedback.BG = nil
    end
    if AccountUp.ui then
        AccountUp.ui:CloseWindow()
    end
    -- 关闭页面之后要还原为默认的，避免影响其它页面
    EditBox:Property({"EmptyTextColor", "#888888", auto=true})
end

function AccountUp.ShowPage()
    -- 打开之前先设置input标签的EmptyText文本颜色
    EditBox:Property({"EmptyTextColor", "#a35229", auto=true})
    if not Feedback.BG then
        BGparams = {
          url="Mod/CodePku/cellar/GUI/Feedback/EmptyPage.html",
          alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
        }
        Feedback.BG = AdaptWindow:QuickWindow(BGparams)
    end
    local params = {
        url = "Mod/CodePku/cellar/GUI/AccountUp/AccountUp.html",
        name = "AccountUpPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        alignment="_ct",
        left = -483,
        top = -285,
        width = 936,
        height = 721,
        zorder = 32,
    }
    if AccountUp.ui then
        AccountUp.ui:CloseWindow()
        AccountUp.mobileToken = nil
    end
    AccountUp.ui = AdaptWindow:QuickWindow(params)
end