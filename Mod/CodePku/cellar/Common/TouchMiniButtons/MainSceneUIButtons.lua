-- 主界面按钮
--author: Min da
--date: 2020-05-29 10:19:30

MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

function MainSceneUIButtons.show_dialog_ui(bshow)
    if(bshow) then
        System.App.Commands.Call("File.MCMLWindowFrame", {
            url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog.html"), 
            name = "MainUIButtons_dialog", 
            isShowTitleBar = false,
            DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
            style = CommonCtrl.WindowFrame.ContainerStyle,
            zorder = 10,
            allowDrag = false,
            click_through = true,
            directPosition = true,
                align = "_lb",
                x = 0,
                y = -350,
                width = 400,
                height = 350,
        });
    else
        System.App.Commands.Call("File.MCMLWindowFrame", {
            url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_close.html"), 
            name = "MainUIButtons_dialog",
            isShowTitleBar = false,
            DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
            style = CommonCtrl.WindowFrame.ContainerStyle,
            zorder = 10,
            allowDrag = false,
            click_through = true,
            directPosition = true,
                align = "_lb",
                x = 0,
                y = -100,
                width = 100,
                height = 100,
        });
    end
end