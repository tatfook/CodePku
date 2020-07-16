-- 主界面按钮
--author: Min da
--date: 2020-05-29 10:19:30
NPL.load("(gl)script/apps/Aries/Creator/Game/Code/CodeWindow.lua");
local Window = commonlib.gettable("MyCompany.Aries.Game.Code.CodeWindow")
MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

function MainSceneUIButtons.show_dialog_ui(bshow)
    if(bshow) then

        local window = Window:new();
        window:Show({
            url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog.html", 
            alignment="_lb", left = 0, top = -350, width = 400, height = 350,
        });
        window:SetMinimumScreenSize(1920,1080);
        -- System.App.Commands.Call("File.MCMLWindowFrame", {
        --     url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog.html"), 
        --     name = "MainUIButtons_dialog", 
        --     isShowTitleBar = false,
        --     DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
        --     style = CommonCtrl.WindowFrame.ContainerStyle,
        --     zorder = 10,
        --     allowDrag = false,
        --     click_through = true,
        --     directPosition = true,
        --         align = "_lb",
        --         x = 0,
        --         y = -350,
        --         width = 400,
        --         height = 350,
        -- });
    else

        local window = Window:new();
        window:Show({
            url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_close.html", 
            alignment="_lb", left = 0, top = -100, width = 100, height = 100,
        });
        window:SetMinimumScreenSize(1920,1080);
        -- System.App.Commands.Call("File.MCMLWindowFrame", {
        --     url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_close.html"), 
        --     name = "MainUIButtons_dialog",
        --     isShowTitleBar = false,
        --     DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
        --     style = CommonCtrl.WindowFrame.ContainerStyle,
        --     zorder = 10,
        --     allowDrag = false,
        --     click_through = true,
        --     directPosition = true,
        --         align = "_lb",
        --         x = 0,
        --         y = -100,
        --         width = 100,
        --         height = 100,
        -- });
    end
end