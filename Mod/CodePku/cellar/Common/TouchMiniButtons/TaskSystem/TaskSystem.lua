local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local TaskSystem = NPL.export()

TaskSystem.Page = nil

TaskSystem.params = {
    {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/SmallGoal.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080,zorder =20
    },
    {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/BigPlan.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080,zorder =20
    }
}

function TaskSystem:ShowPage(index)
    
    if TaskSystem.Page ~= nil then
        TaskSystem.Page:CloseWindow()
    end

    Index = tonumber(index)

    TaskSystem.Page = AdaptWindow:QuickWindow(TaskSystem.params[Index])

end