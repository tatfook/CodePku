-- 主界面按钮
--author: Min da
--date: 2020-05-29 10:19:30
NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

function MainSceneUIButtons.show_dialog_ui(bshow)
    if(bshow) then
        params = {
            url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog.html", 
            alignment="lt", left = 0, top = 0, width = 1000, height = 1080, zorder=30,
        }
        local window = AdaptWindow:QuickWindow(params)
    else
        params = {
            url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_close.html", 
            alignment="_lb", left = 0, top = -100, width = 100, height = 100,
        }
        local window = AdaptWindow:QuickWindow(params)
    end
end