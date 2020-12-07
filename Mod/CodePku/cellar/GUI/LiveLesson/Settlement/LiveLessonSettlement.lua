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

-- CMD下课退出，所有人都会执行
function LiveLessonSettlement:ClassOverTimer()
    if LiveLessonSettlement.TimerTimes and LiveLessonSettlement.TimerTimes ~= 0 then
        return
    end
    LiveLessonSettlement.TimerTimes = LiveLessonSettlement.constant.ExitTime
    local content = string.format("下课了，教室将于%.0f分钟后关闭", LiveLessonSettlement.TimerTimes/60)
    GameLogic.AddBBS("CodeGlobals", content, 5000, "#FF0000");
    LiveLessonSettlement.class_over_timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            if LiveLessonSettlement.TimerTimes == 0 then
                -- 强制退出
                -- GameLogic.AddBBS("CodeGlobals", L"时间到了，强制退出", 3000, "#FF0000");
                GameLogic.RunCommand(string.format('/connectCodePku %d', 1));
                LiveLessonSettlement.TimerTimes = nil
                timer:Change()
            else
                LiveLessonSettlement.TimerTimes = LiveLessonSettlement.TimerTimes - 1
            end
        end
    })
    LiveLessonSettlement.class_over_timer:Change(0, 1000)
end

-- 离开直播课，清除定时器
function LiveLessonSettlement:LeaveLiveLesson()
    LiveLessonSettlement.TimerTimes = nil
    LiveLessonSettlement.class_over_timer:Change()
    -- 老师退出房间要给接口发送请求
    if System.User.info.is_employee == 1 and System.User.LiveLessonData.open_user_id == System.User.info.id then
        local path = "/class-room/logout"
        local params = {
            room_id = System.User.LiveLessonData.id
        }
        request:post(path,params):next(function(response)

        end):catch(function(e)
    
        end);
    end
end

-- 老师点击下课
function LiveLessonSettlement:ClassDismissed()
    if System.User.LiveLessonData and System.User.LiveLessonData.class_finished == true then
        return
    end
    local path = "/class-room/click-over"
    local params = {
        room_id = System.User.LiveLessonData.id
    }
    request:post(path,params):next(function(response)
        System.User.LiveLessonData.class_finished = true
    end):catch(function(e)

    end);
end

-- 节点转百分比
local function ToPercentage(str)
    local result = commonlib.split(str,"/")
    local per = tonumber(result[1])/tonumber(result[2])
    return per
end

-- 综合评分计算
local function CalculateGrade(data)
    local node = data.current_node == 0 and 0 or data.current_node/data.total_node        -- 课程节点百分比
    local count = 0
    local temp_count = {}
    if data.answer_count == 0 then
        temp_count.accuracy = false
    else
        temp_count.accuracy = (data.right_count/data.answer_count) > 0.6     -- 答题正确率
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
            temp_table.user_id = v.user_id
            temp_table.nickname = v.nickname or "未知"      -- 用户昵称

            temp_table.rate_of_learn = v.current_node == 0 and "0%" or (tostring(string.format("%02d", (v.current_node/v.total_node)*100)) .. "%")      -- 学习节点

            temp_table.accuracy = v.answer_count == 0 and "0%" or (tostring(string.format("%02d", (v.right_count/v.answer_count)*100)) .. "%")       -- 首次答题正确率

            if v.right_count == 0 or v.rank_total == 0 then
                temp_table.rank = "——"
            else
                temp_table.rank = v.rank_total/v.right_count         -- 综合答题排名
            end
            temp_table.group_rank = v.group_rank or "——"        -- 小组排名
            temp_table.reward_num = v.reward_num        -- 奖励次数
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

-- 老师保存结算信息
function LiveLessonSettlement:CommitSettlementResult()
    if LiveLessonSettlement.had_commit then
        return
    end
    local params = {}
    -- 拼接数据
    params.room_id = (System.User.LiveLessonData or {}).id or "7"        -- todo 测试服目前只有7号有数据，最后记得去掉这个
    params.data = {}
    for k, v in pairs(LiveLessonSettlement.settlement_result_table) do
        params.data[tostring(v.user_id)] = {
            user_id = v.user_id,
            reward_count = v.reward_num,
            comment_score_final = v.rate,
            person_average = if_else(v.rank == "——", false, v.rank)
        }
    end
    LiveLessonSettlement.had_commit = true
    -- 发送数据
    request:post('/class-room/save-class',params):next(function(response)
        GameLogic.AddBBS("CodeGlobals", L"课程结算成功", 3000, "#00FF00")
        -- LiveLessonSettlement.had_settlement = true      -- 正常结算的标记，根据该字段判断是否能点击下课/20201207转移到H5页面中了
        -- LiveLessonSettlement.teacher_settlement_page:Refresh(0)
        LiveLessonSettlement.had_commit = false
        GameLogic.RunCommand("/ggs cmd liveLesson settlement")      -- 成功保存信息，发送ggs命令弹出学生结算弹窗
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        LiveLessonSettlement.had_commit = false
    end);
end

-- 学生分享好友
function LiveLessonSettlement:ShareLogic(url)
    if LiveLessonSettlement.bShare then
        return
    end
    if System.os.IsMobilePlatform() then
        LiveLessonSettlement.bShare = true
        LiveLessonSettlement:fire("image", {
            image = url,
            title = "课程结算"
        }, {
            onStart = function(e)
                -- 开始分享
                LiveLessonSettlement.bShare = false
            end,
            onResult = function(e)
                -- 分享结果
                LiveLessonSettlement.bShare = false
            end,
            onError = function(e)
                -- 分享失败
                LiveLessonSettlement.bShare = false
            end,
            onCancel = function(e)
                -- 取消分享
                LiveLessonSettlement.bShare = false
            end
        })
    else
        GameLogic.AddBBS("CodeGlobals", L"使用手机app才能分享", 3000, "#FF0000");
    end
end

-- CMD学生获取结算信息，所有人都会执行，需要判断身份，老师不执行
function LiveLessonSettlement:StudentSettlement()
    if System.User.info.is_employee == 1 then
        --  员工默认为老师，拦截弹窗
        return
    end
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
            accuracy = tostring(string.format("%02d", (data.right_count/data.answer_count)*100)) .. "%"       -- 首次答题正确率
        end
        
        local current_node, total_node = data.current_node, data.total_node
        local node
        if current_node == 0 then
            node = "0%"
        else
            node = tostring(string.format("%02d", (current_node/total_node)*100)) .. "%"       -- 学习进度转百分比
        end
        
        LiveLessonSettlement.share_url = data.poster_url        -- 分享的图片

        LiveLessonSettlement.StudentSettlementResult = {}
        LiveLessonSettlement.StudentSettlementResult.course_name = ((data.class_room or {}).courseware or {}).name or "未知"     -- 课件名称
        LiveLessonSettlement.StudentSettlementResult.description = ((data.class_room or {}).courseware or {}).description or "未知"     -- 知识点描述
        LiveLessonSettlement.StudentSettlementResult.grade = {
            {content = node, color = "#2766cf", title = "学习进度", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_01.png')},
            {content = accuracy, color = "#6167e9", title = "首次正确率", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_02.png')},
            {content = data.group_rank, color = "#9766e0", title = "小组排名", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_03.png')},
            {content = data.reward_num, color = "#d568f9", title = "奖励次数", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_04.png')},
            {content = data.comment_score_final, color = "#f178e7", title = "综合评级", pic = LiveLessonSettlement:GetIconPath('live_lesson_mygrade_05.png')},
        }

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
    if LiveLessonSettlement.student_settlement_page then
        LiveLessonSettlement.student_settlement_page:CloseWindow()
        LiveLessonSettlement.student_settlement_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonStudentSettlement.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    }
    LiveLessonSettlement.student_settlement_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.student_settlement_page
end

-- 修改评分弹窗有输入框，需要把两个窗口都关掉
function LiveLessonSettlement:ChangeGradePageSpecialClose()
    if LiveLessonSettlement.EmptyBG then
        LiveLessonSettlement.EmptyBG:CloseWindow()
        LiveLessonSettlement.EmptyBG = nil
    end
    if LiveLessonSettlement.change_rate_page then
        LiveLessonSettlement.change_rate_page:CloseWindow()
        LiveLessonSettlement.change_rate_page = nil
    end
end

-- 修改评分弹窗
function LiveLessonSettlement:ShowChangeRate()
    -- 这里有输入框，为了IOS适配，需要特殊处理下，再开一个空页面放下面
    if LiveLessonSettlement.EmptyBG then
        LiveLessonSettlement.EmptyBG:CloseWindow()
        LiveLessonSettlement.EmptyBG = nil
    end
    local BGparams = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/LiveLessonEmptyPage.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31,
    }
    LiveLessonSettlement.EmptyBG = AdaptWindow:QuickWindow(BGparams)
    -- 修改弹窗
    if LiveLessonSettlement.change_rate_page then
        LiveLessonSettlement.change_rate_page:CloseWindow()
        LiveLessonSettlement.change_rate_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonChangeRate.html",
        alignment="_lt", left = 600, top = 334, width = 723 , height = 412, zorder = 32,
    }
    LiveLessonSettlement.change_rate_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.change_rate_page
end

-- 教师结算界面
function LiveLessonSettlement:ShowTeacherSettlementPage()
    -- 教师主动触发结算页面
    if LiveLessonSettlement.teacher_settlement_page then
        LiveLessonSettlement.teacher_settlement_page:CloseWindow()
        LiveLessonSettlement.teacher_settlement_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonTeacherSettlement.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    }
    LiveLessonSettlement.teacher_settlement_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.teacher_settlement_page
end