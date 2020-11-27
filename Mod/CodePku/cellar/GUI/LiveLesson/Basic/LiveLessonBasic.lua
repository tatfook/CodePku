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

function LiveLessonBasic:RunGGSCommand(commandName)
    if commandName == "broadcast" then
        GameLogic.RunCommand(string.format("/ggs cmd tip -color #ff0000 -duration 3000 %s", L"快速广播测试"))
    elseif commandName == "call" then
        local EM = GameLogic.EntityManager
        local player = EM.GetPlayer()
        if(player) then
            local x, y, z = player:GetBlockPos()
            GameLogic.RunCommand(string.format("/ggs cmd goto %d %d %d", x, y, z))
        end
    elseif commandName == "changeMode" then
        local ifEditMode = GameLogic.GameMode:IsEditor()
        if ifEditMode then
            GameLogic.RunCommand(string.format("/ggs cmd mode %s", "game"))
        else
            GameLogic.RunCommand(string.format("/ggs cmd mode %s", "edit"))
        end
    end
end

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

function LiveLessonBasic:CloseAllWindows()
    if LiveLessonBasic.windowLeft then
        LiveLessonBasic.windowLeft:CloseWindow()
        LiveLessonBasic.windowLeft = nil
    end
    if LiveLessonBasic.windowRight then
        LiveLessonBasic.windowRight:CloseWindow()
        LiveLessonBasic.windowRight = nil
    end
end