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

-- todo CMD下课退出，所有人都会执行
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

-- 节点转百分比
local function ToPercentage(str)
    local result = commonlib.split(str,"/")
    local per = tonumber(result[1])/tonumber(result[2])
    return per
end

-- 综合评分计算
local function CalculateGrade(data)
    local node = ToPercentage(data.rate_of_learn)       -- 课程节点百分比
    local count = 0
    local temp_count = {}
    if data.answer_count == 0 then
        temp_count.accuracy = false
    else
        temp_count.accuracy = data.right_count/data.answer_count > 0.6     -- 答题正确率
    end
    temp_count.team_rank = (data.group_rank or 0)/5 >= 0.5         -- todo 5要换成小组数，暂时没有
    temp_count.reward_num = data.reward_num >= 2      -- 奖励次数
    for k, v in pairs(temp_count) do
        if v then
            count = count + 1
        end
    end
    if node >= 0.8 then
        if count == 3 then
            return "SSS"
        elseif count == 2 then
            return "SS"
        elseif count == 1 then
            return "S"
        else
            return "A"
        end
    else
        return "B"
    end
end

-- 老师获取结算信息
function LiveLessonSettlement:TeacherSettlement()
    if LiveLessonSettlement.TeacherHadSettlement then
        return
    end
    local room_id = (System.User.LiveLessonData or {}).id or "7"        -- todo 测试服目前只有7号有数据，最后记得去掉这个
    local path = "/class-room/class-over?room_id=" .. tostring(room_id)
    LiveLessonSettlement.settlement_result_table = {}
    LiveLessonSettlement.TeacherHadSettlement = true
    request:get(path):next(function(response)
        local data = response.data.data
        -- 拼接界面数据
        for k, v in pairs(data) do
            local temp_table = {}
            temp_table.nickname = v.nickname or "未知"      -- 用户昵称
            temp_table.rate_of_learn = v.rate_of_learn or "0/0"     -- 学习节点
            if v.answer_count == 0 then
                temp_table.accuracy = "0%"
            else
                temp_table.accuracy = tostring(string.format("%02d", (v.right_count/v.answer_count)*100)) .. "%"       -- 首次答题正确率
            end
            if v.right_count == 0 or v.rank_total == 0 then
                temp_table.rank = "--"
            else
                temp_table.rank = v.rank_total/v.right_count         -- 综合答题排名
            end
            temp_table.group_rank = v.group_rank or "--"        -- 小组排名
            temp_table.reward_num = v.reward_num or "--"        -- 奖励次数
            temp_table.rate = CalculateGrade(v)       -- 综合评分
            table.insert(LiveLessonSettlement.settlement_result_table, temp_table)
        end

        -- 数据处理完毕，展示页面
        LiveLessonSettlement:ShowTeacherSettlementPage()
        LiveLessonSettlement.TeacherHadSettlement = false
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        LiveLessonSettlement.TeacherHadSettlement = false
    end);
end

-- todo CMD学生获取结算信息，所有人都会执行，需要判断身份，老师不执行
function LiveLessonSettlement:StudentSettlement()
    if LiveLessonSettlement.StudentHadSettlement then
        return
    end
    local room_id = (System.User.LiveLessonData or {}).id or "7"        -- todo 测试服目前只有7号有数据，最后记得去掉这个
    LiveLessonSettlement.StudentHadSettlement = true
    local path = "/class-room/student-settlement?room_id=" .. tostring(room_id)
    request:get(path):next(function(response)
        local data = response.data.data
        -- 处理数据
        local accuracy
        if data.answer_count == 0 then
            accuracy = "0%"
        else
            accuracy = tostring(string.format("%02d", (v.right_count/v.answer_count)*100)) .. "%"       -- 首次答题正确率
        end
        -- 学习进度转百分比
        local node = tostring(string.format("%02d", ToPercentage(data.rate_of_learn)*100)) .. "%"
        
        LiveLessonSettlement.StudentSettlementResult = {}
        LiveLessonSettlement.StudentSettlementResult.course_name = data.course_name or "未知"     -- 课件名称
        LiveLessonSettlement.StudentSettlementResult.description = data.description or "未知"     -- 知识点描述
        LiveLessonSettlement.StudentSettlementResult.grade = {
            {content = node, color = "#2766cf", title = "学习进度", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_01.png')},
            {content = accuracy, color = "#6167e9", title = "首次正确率", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_02.png')},
            {content = data.group_rank, color = "#9766e0", title = "小组排名", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_03.png')},
            {content = data.reward_num, color = "#d568f9", title = "奖励次数", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_04.png')},
            {content = data.comment_score_final, color = "#f178e7", title = "综合评级", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_05.png')}}

        -- 处理完数据展示学生结算界面
        LiveLessonSettlement:ShowStudentSettlementPage()
        LiveLessonSettlement.StudentHadSettlement = false
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        LiveLessonSettlement.StudentHadSettlement = false
    end);
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

-- 有输入框，需要把两个窗口都关掉
function LiveLessonSettlement:EntrancePageSpecialClose()
    if LiveLessonSettlement.EmptyBG then
        LiveLessonSettlement.EmptyBG:CloseWindow()
        LiveLessonSettlement.EmptyBG = nil
    end
    if LiveLessonSettlement.teacher_settlement_page then
        LiveLessonSettlement.teacher_settlement_page:CloseWindow()
        LiveLessonSettlement.teacher_settlement_page = nil
    end
end

-- 教师结算界面
function LiveLessonSettlement:ShowTeacherSettlementPage()
    -- 这里有输入框，为了IOS适配，需要特殊处理下，再开一个空页面放下面
    if LiveLessonSettlement.EmptyBG then
        LiveLessonSettlement.EmptyBG:CloseWindow()
        LiveLessonSettlement.EmptyBG = nil
    end
    local BGparams = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/LiveLessonEmptyPage.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 21,
    }
    LiveLessonSettlement.EmptyBG = AdaptWindow:QuickWindow(BGparams)
    -- 教师主动触发结算页面
    if LiveLessonSettlement.teacher_settlement_page then
        LiveLessonSettlement.teacher_settlement_page:CloseWindow()
        LiveLessonSettlement.teacher_settlement_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonTeacherSettlement.html",
        alignment="_lt", left = 207, top = 69, width = 1485 , height = 1000, zorder = 9999
    }
    LiveLessonSettlement.teacher_settlement_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.teacher_settlement_page
end