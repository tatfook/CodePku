--[[
Title: LiveLessonSettlement
Author: loujiayu
Date: 2020/11/26

Example:
-----------------------------------------------
local LiveLessonSettlement = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonSettlement.lua");
-----------------------------------------------
]]

local LiveLessonSettlement = NPL.export()
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local liveLessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/liveLessonImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

-- 常量table
LiveLessonSettlement.constant = {
    ExitTime = 300,     -- 老师点击下课后，学生强制退出的时间/秒
}

-- 获取图标
function LiveLessonSettlement:GetIconPath(index)
    return liveLessonImageData:GetIconUrl(index)
end

-- todo 下课计时器
function LiveLessonSettlement:ClassOverTimer()
    GameLogic.AddBBS("CodeGlobals", L"下课了，教室将于5分钟后关闭", 3000, "#FF0000");
    if LiveLessonSettlement.TimerTimes and LiveLessonSettlement.TimerTimes ~= 0 then
        return
    end
    LiveLessonSettlement.TimerTimes = 0
    LiveLessonSettlement.class_over_timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            if LiveLessonSettlement.TimerTimes == LiveLessonSettlement.constant.ExitTime then
                GameLogic.AddBBS("CodeGlobals", L"时间到了，强制退出", 3000, "#FF0000");
                LiveLessonSettlement.TimerTimes = nil
                timer:Change()
            end
            LiveLessonSettlement.TimerTimes = LiveLessonSettlement.TimerTimes + 1
        end
    })
    LiveLessonSettlement.class_over_timer:Change(0, 1000)
end

-- 学生结算弹窗
function LiveLessonSettlement:ShowStudentSettlementPage()
    -- todo 通过GGS执行cmd，需要判断是否是老师，老师不展示下面的弹窗
    if LiveLessonSettlement.student_settlement_page then
        LiveLessonSettlement.student_settlement_page:CloseWindow()
        LiveLessonSettlement.student_settlement_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonStudentSettlement.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 10000
    }
    LiveLessonSettlement.student_settlement_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.student_settlement_page
end

-- 教师结算界面
function LiveLessonSettlement:ShowTeacherSettlementPage()
    if LiveLessonSettlement.teacher_settlement_page then
        LiveLessonSettlement.teacher_settlement_page:CloseWindow()
        LiveLessonSettlement.teacher_settlement_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonTeacherSettlement.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 9999
    }
    LiveLessonSettlement.teacher_settlement_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.teacher_settlement_page
end