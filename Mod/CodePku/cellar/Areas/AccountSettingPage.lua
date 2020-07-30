NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local AccountSettingPage = NPL.export();
local page;

function AccountSettingPage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/Areas/AccountSettingPage.html",
        name = "AccountSettingPage.ShowPage",
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        click_through = false,
        zorder = -1,
        alignment = "_ct",
        x = -856 / 2,
        y = -660 / 2,
        width = 856,
        height = 660
    };
    local window = AdaptWindow:QuickWindow(params);
end

function AccountSettingPage.OnInit()
	page = document:GetPageCtrl();
    AccountSettingPage.userInfo = Mod.CodePku.Store:Get('user/info');
    if (page) then
        page:SetValue('setpassword', if_else(AccountSettingPage.userInfo.password_setted, '已设置', '未设置'));
    end
end