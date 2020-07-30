NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local CodePkuUsersApi = NPL.load("(gl)Mod/CodePku/api/Codepku/Users.lua");
local CodePkuServiceSession = NPL.load("(gl)Mod/CodePku/service/CodePkuService/Session.lua")
local PasswordSettingPage = NPL.export();
local page;

function PasswordSettingPage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/Areas/PasswordSettingPage.html",
        name = "PasswordSettingPage.ShowPage",
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        click_through = false,
        zorder = -1,
        -- directPosition = true,
        alignment = "_ct",
        x = -856 / 2,
        y = -660 / 2,
        width = 856,
        height = 660
    };
    local window = AdaptWindow:QuickWindow(params);
end

function PasswordSettingPage.OnInit()
    page = document:GetPageCtrl();
    local userInfo = Mod.CodePku.Store:Get('user/info');
    PasswordSettingPage.hasPassword = userInfo.password_setted;
    PasswordSettingPage.mobile = if_else(#(userInfo.mobile) == 11, string.sub(userInfo.mobile, 0, 3)..'****'..(string.sub(userInfo.mobile, 8)), userInfo.mobile);
end

function PasswordSettingPage:UpdatePassword()
    if (page) then
        local password_old = page:GetValue('password_old');
        if (PasswordSettingPage.hasPassword) then
            if (not password_old or password_old == "") then
                GameLogic.AddBBS(nil, L"请输入旧密码", 3000, "255 0 0", 21);
                return false;
            end
        end
        local password = page:GetValue('password'); -- todo: rules
        local password_confirm = page:GetValue('password_confirm');
        if (not password or password == "") then
            GameLogic.AddBBS(nil, L"请输入新密码", 3000, "255 0 0", 21);
            return false;
        elseif (not password_confirm or password_confirm == "") then
            GameLogic.AddBBS(nil, L"请再次输入新密码", 3000, "255 0 0", 21);
            return false;
        elseif (#password < 6 or #password > 20) then
            GameLogic.AddBBS(nil, L"密码必须是6~20位", 3000, "255 0 0", 21);
            return false;
        elseif (password_confirm ~= password) then
            GameLogic.AddBBS(nil, L"两次新密码输入不一致", 3000, "255 0 0", 21);
            return false;
        end

        local usertoken = CodePkuServiceSession:GetCurrentUserToken();

        local params = {
            password = password,
            password_confirm = password_confirm
        };
        if (PasswordSettingPage.hasPassword) then
            params.password_old = password_old;
        end
        CodePkuUsersApi:UpdatePassword(
            usertoken,
            params,
            function(response, err)
                if err ~= 200 then
                    GameLogic.AddBBS(nil, response.message, 3000, "255 0 0", 21);
                    return false
                end
                GameLogic.AddBBS(nil, '设置成功', 3000, "0 255 0", 21);
                local SetUserinfo = Mod.CodePku.Store:Action("user/SetUserinfo");                    
                SetUserinfo(nil, response.data);
                page:CloseWindow();
            end
        )
    end
end