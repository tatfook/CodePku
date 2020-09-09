--[[
    author:{zouren}
    time:2020-09-01 09:03:56
    des:用来提示游客升级账号
    use:
        NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/AccountUpTips.lua")
        local AccountUpTips = commonlib.gettable("Mod.CodePku.AccountUpTips")
]]
NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/AccountUp.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local AccountUp = commonlib.gettable("Mod.CodePku.AccountUp")
local AccountUpTips = commonlib.gettable("Mod.CodePku.AccountUpTips")

AccountUpTips.ui = nil

function AccountUpTips.OnSureBtnClicked(  )
    if AccountUpTips.ui then
        AccountUpTips.ui:CloseWindow()
    end
    NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/AccountUp.lua")
    local AccountUp = commonlib.gettable("Mod.CodePku.AccountUp")
    AccountUp.ShowPage()
end

function AccountUpTips.OnCancelBtnClicked(  )
    if AccountUpTips.ui then
        AccountUpTips.ui:CloseWindow()
    end
end

function AccountUpTips.ShowPage(  )
    local params = {
        url = "Mod/CodePku/cellar/GUI/AccountUp/AccountUpTips.html",
        name = "AccountUpTipsPage", 
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
    if AccountUpTips.ui then
        AccountUpTips.ui:CloseWindow()
    end
    AccountUpTips.ui = AdaptWindow:QuickWindow(params)
end