--[[usage:
local LiveLessonBasic = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasic.lua")
LiveLessonBasic:ShowPage()
--]]
local LiveLessonBasic = NPL.export();
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

LiveLessonBasic.is_employee = System.User.info.is_employee == 1

LiveLessonBasic.params = {
    left = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicLeft.html",
		alignment="_lt", left = 20, top = 20, width = 200, height = 800, zorder=100, parent = ParaUI.GetUIObject("root")
    },
    right = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicRight.html",
		alignment="_lt", left = 1500, top = 20, width = 400, height = 800, zorder=100, parent = ParaUI.GetUIObject("root")
    },
    right_closed = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicRight.html",
		alignment="_lt", left = 1850, top = 20, width = 50, height = 800, zorder=100, parent = ParaUI.GetUIObject("root")
    },
}

function LiveLessonBasic:Switch()
    if LiveLessonBasic.windowRight then
        LiveLessonBasic.windowRight:CloseWindow()
        LiveLessonBasic.windowRight = nil
    end
    if not LiveLessonBasic.windowRight then
        if LiveLessonBasic.windowOpenFlag then
            LiveLessonBasic.windowOpenFlag = nil
            LiveLessonBasic.windowRightWidth = LiveLessonBasic.params.right_closed.width
            LiveLessonBasic.windowRight = AdaptWindow:QuickWindow(LiveLessonBasic.params.right_closed)
        else
            LiveLessonBasic.windowOpenFlag = true
            LiveLessonBasic.windowRightWidth = LiveLessonBasic.params.right.width
            LiveLessonBasic.windowRight = AdaptWindow:QuickWindow(LiveLessonBasic.params.right)
        end
    end
end

function LiveLessonBasic:ShowPage()
    LiveLessonBasic.windowOpenFlag = true
    LiveLessonBasic.windowRightWidth = LiveLessonBasic.params.right.width
    if not LiveLessonBasic.windowLeft then
        LiveLessonBasic.windowLeft = AdaptWindow:QuickWindow(LiveLessonBasic.params.left)
    end
    if not LiveLessonBasic.windowRight then
        LiveLessonBasic.windowRight = AdaptWindow:QuickWindow(LiveLessonBasic.params.right)
    end
end
