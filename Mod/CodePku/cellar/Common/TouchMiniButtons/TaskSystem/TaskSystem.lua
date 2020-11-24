--[[
Title: Page_ui
Author(s): NieXX
Date: 2020/9/11
Desc:
use the lib:
functions:
    TaskSystem:UpdateTaskDetail(data)-- 更新后台数据
    TaskSystem:handleFinishCountNow(table,index,flag)-- 完成任务后，处理finish_count_now
    TaskSystem:handleReceived(table,index,flag)-- 领取任务奖励后，处理reward_received，0-未领取 1-领取
    TaskSystem:FindTaskByID(ID, flag)-- 根据任务id查找任务
    TaskSystem:GetReward(taskID,reward_json, type)-- 领取奖励
    TaskSystem:GetTask()-- 获取任务列表
    TaskSystem:HandleTaskData(data)-- 处理任务列表，添加status字段
    TaskSystem:ChangeStrToNum(data)
    TaskSystem:TableSort(t)
    TaskSystem:AwardSort(t)
    TaskSystem:ShowPage(index)
    TaskSystem:ShowPopupPage(index, rewardIndex)-- 小目标奖励详情页面
    TaskSystem:HandleClickEvent(data,type)-- 处理任务
    TaskSystem:GetJumpId(redirect)-- 根据redirect字段获取将要跳转的世界id
    TaskSystem:GetTaskDeac(data)
    TaskSystem:RefreshMoney(id, num)-- 领取奖励后更新道具列表
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/TaskSystem.lua")
local TaskSystem = commonlib.gettable("Mod.CodePku.Common.TaskSystem")

TaskSystem = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/TaskSystem.lua")
------------------------------------------------------------
]]


local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local ToWhere = commonlib.gettable("Mod.CodePku.GUI.Popup.ToWhere")
TaskSystem = commonlib.gettable("Mod.CodePku.Common.TaskSystem")
-- local TaskSystem = NPL.export()
TaskSystem.Page_ui = nil
TaskSystem.nowReward = nil
TaskSystem.PageIndex = nil
TaskSystem.acquire_flag = nil --判断奖励是可领取还是其他 1表示可领取

TaskSystem.taskList = {}
TaskSystem.goal = {}
TaskSystem.goalReward = {}
TaskSystem.plan = {}
TaskSystem.worldID = {
    [1] = { title = "玩学大厅-大门(北大入口)", id = 1, name = "gate", jumpTo = 1, },
    [2] = { title = "教学区", id = 15855, name = "teach", jumpTo = 2, },
    [3] = { title = "专题区", id = 15857, name = "topic", jumpTo = 3, },
    [4] = { title = "竞技区", id = 14312, name = "compete", jumpTo = 4, },
    [5] = { title = "家园区", id = 14293, name = "home", jumpTo = 5, },
    [6] = { title = "单词爱跑酷", id = 12896, name = "parkour", jumpTo = 31, },
    [7] = { title = "华夏游学记", id = 13426, name = "tour", jumpTo = 32, },
}

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

TaskSystem.popup = {
    {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/Popup/Reward.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080,zorder =30
    },
}

function TaskSystem:StaticInit()
    LOG.std("", "info", "TaskSystem", "StaticInit");
    -- GameLogic.GetFilters():apply_filters("TaskSystemList", data);
    GameLogic.GetFilters():remove_filter("TaskSystemList", TaskSystem.OnTaskFinished_Callback);
    GameLogic.GetFilters():add_filter(
        "TaskSystemList",
        function (data)
            -- data["type"] 0-login 1-学习 2-游戏 3-分享 4-小目标奖励  
            NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/TaskSystem.lua")
            local TaskSystem = commonlib.gettable("Mod.CodePku.Common.TaskSystem")
            local id = 0;
            if data then
                -- 处理缓存table
                if data["type"] == "login" then
                    -- 登录：小目标-1 大计划-13
                    -- 登录不更新本地缓存数据，因为是先给后台发送登录信号，然后才拉取的任务列表 --
                    -- TaskSystem.goal = TaskSystem:handleFinishCountNow(TaskSystem.goal, TaskSystem:FindTaskByID(1, 1), 1)
                    -- TaskSystem.plan = TaskSystem:handleFinishCountNow(TaskSystem.plan, TaskSystem:FindTaskByID(13, 3), 3)

                    TaskSystem:UpdateTaskDetail({ids = "1, 13"})
                elseif data["type"] == "share" then
                    -- 分享：小目标-7 大计划-18
                    TaskSystem.goal = TaskSystem:handleFinishCountNow(TaskSystem.goal, TaskSystem:FindTaskByID(7, 1), 1)
                    TaskSystem.plan = TaskSystem:handleFinishCountNow(TaskSystem.plan, TaskSystem:FindTaskByID(18, 3), 3)
                    TaskSystem:UpdateTaskDetail({ids = "7, 18"})
                elseif data["type"] == "home" then
                    -- 前往家园区：小目标-6 
                    TaskSystem.goal = TaskSystem:handleFinishCountNow(TaskSystem.goal,TaskSystem:FindTaskByID(6, 1), 1)
                    TaskSystem:UpdateTaskDetail({ids = "6"})
                elseif data["type"] == "course" then
                    -- 任意课程：小目标-19
                    TaskSystem.goal = TaskSystem:handleFinishCountNow(TaskSystem.goal,TaskSystem:FindTaskByID(19, 1), 1)
                    if data["category"] == 2 then
                        -- 任意课程(专题区)：大计划-15
                        TaskSystem.plan = TaskSystem:handleFinishCountNow(TaskSystem.plan,TaskSystem:FindTaskByID(15, 3), 3)
                        TaskSystem:UpdateTaskDetail({ids = "19, 15"})
                    elseif data["category"] == 1 then
                        -- 任意课程(教学区)： 大计划-14
                        TaskSystem.plan = TaskSystem:handleFinishCountNow(TaskSystem.plan,TaskSystem:FindTaskByID(14, 3), 3)
                        TaskSystem:UpdateTaskDetail({ids = "19, 14"})
                    end
                elseif data["type"] == "game" then
                    -- 任意游戏：小目标-20
                    TaskSystem.goal = TaskSystem:handleFinishCountNow(TaskSystem.goal,TaskSystem:FindTaskByID(20, 1), 1)
                    TaskSystem:UpdateTaskDetail({ids = "20"})
                    -- [TODO 区分release和dev的id]，目前相同
                    if data["courseware_id"] == 9 then
                        -- 跑酷：大计划-16
                        -- 跑酷courseware_id：DEV-9 RELEASE-9
                        TaskSystem.plan = TaskSystem:handleFinishCountNow(TaskSystem.plan,TaskSystem:FindTaskByID(16, 3), 3)
                        TaskSystem:UpdateTaskDetail({ids = "16"})
                    elseif data["courseware_id"] == 10 then
                        -- 华夏：大计划-17
                        -- 跑酷courseware_id：DEV-10 RELEASE-10
                        TaskSystem.plan = TaskSystem:handleFinishCountNow(TaskSystem.plan,TaskSystem:FindTaskByID(17, 3), 3)
                        TaskSystem:UpdateTaskDetail({ids = "17"})
                    end
                elseif data["type"] == "goalReward" then
                    -- 小目标奖励，每次领取小目标奖励时触发
                    -- local ids = {}
                    local ids = ""
                    for k,v in pairs(TaskSystem.goalReward) do
                        v["finish_count_now"] = v["finish_count_now"] + 1
                        -- table.insert (ids, {id = v.id})
                        ids = ids..v["id"]..","
                    end
                    TaskSystem.goalReward = TaskSystem:AwardSort(TaskSystem:HandleTaskData(TaskSystem.goalReward))
                    TaskSystem:UpdateTaskDetail({ids=ids})
                end
            end
        end
    );
end

-- 更新后台数据
-- @param data eg:{ids="1, 20"}
function TaskSystem:UpdateTaskDetail(data)
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:post('/tasks/up-tasks', data, nil);
end

-- 完成任务后，处理finish_count_now
-- @param flag: 1-小目标 2-小目标奖励 3-大计划
function TaskSystem:handleFinishCountNow(table,index,flag)
    -- 先判断table是否为空
    if #table > 0 then
        table[index]["finish_count_now"] = table[index]["finish_count_now"] + 1
    end

    if flag == 2 then
        return self:AwardSort(self:HandleTaskData(table))
    else
        return self:TableSort(self:HandleTaskData(table))
    end
end

-- 领取任务奖励后，处理reward_received，0-未领取 1-领取
function TaskSystem:handleReceived(table,index,flag)
    -- 先判断table是否为空
    if #table > 0 then
        table[index]["reward_received"] = 1
    end

    if flag == 2 then
        return self:AwardSort(self:HandleTaskData(table))
    else
        return self:TableSort(self:HandleTaskData(table))
    end
end

-- 根据任务id查找任务
-- @param flag: 1-小目标 2-小目标奖励 3-大计划
-- @return index
function TaskSystem:FindTaskByID(ID, flag)
    local temp = {}
    local index = 0
    if flag == 1 then
        temp = self.goal
    elseif flag == 2 then
        temp = self.goalReward
    elseif flag == 3 then
        temp = self.plan
    end
    if #temp > 0 then
        for k, v in pairs(temp) do
            if v.id == ID then
                index = k
            end
        end
    end
    return index
end

-- 领取奖励
-- @param "goal" | "goalReward" | "plan"
function TaskSystem:GetReward(taskID,reward_json, type)
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:post('/tasks-reward-receive/store',{task_id=taskID},nil):next(function(response)
        if response.status == 200 then
            GameLogic.AddBBS(nil, L"领取成功", 3000, "255 0 0", 21);
            if TaskSystem.popupui then
                TaskSystem.popupui:CloseWindow()
            end

            --领取奖励后刷新table，显示已领取，将reward_received设置成1
            if type == "goal" then
                TaskSystem.goal = TaskSystem:handleReceived(TaskSystem.goal,TaskSystem:FindTaskByID(taskID, 1), 1)
                GameLogic.GetFilters():apply_filters("TaskSystemList", {type = "goalReward"}); -- 领取奖励后，触发任务系统计数
                GameLogic.GetFilters():apply_filters("Schoolyard.IncreaseVitality", {type = "smalltarget"}); -- 领取奖励后，触发活跃度系统，小目标
            elseif type == "goalReward" then
                TaskSystem.goalReward = TaskSystem:handleReceived(TaskSystem.goalReward,TaskSystem:FindTaskByID(taskID, 2), 2)
            elseif type == "plan" then
                TaskSystem.plan = TaskSystem:handleReceived(TaskSystem.plan,TaskSystem:FindTaskByID(taskID, 3), 3)
                GameLogic.GetFilters():apply_filters("Schoolyard.IncreaseVitality", {type = "bigplan"}); -- 领取奖励后，触发活跃度系统，大计划
            end
            if TaskSystem.Page_ui then
                TaskSystem.Page_ui:Refresh(0)
            end

            -- 刷新右上角金币界面
            for k,v in pairs(reward_json) do
                TaskSystem:RefreshMoney(v.props_id,v.reward_num)
                local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
                if MainUIButtons.money_window ~= nil then
                    MainUIButtons.money_window:CloseWindow()
                    MainUIButtons.money_window = nil
                    MainUIButtons.show_money_ui()
                end
            end
        else
            GameLogic.AddBBS(nil, L"领取失败", 3000, "255 0 0", 21);
        end
    end):catch(function(e)
       GameLogic.AddBBS(nil, L"领取失败", 3000, "255 0 0", 21);
    end);
end

-- 获取任务列表
function TaskSystem:GetTask()
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    request:post('/tasks/user-tasks',{},nil):next(function(response)
        self.goal = (response and response.data and response.data.data and response.data.data.user_tasks_daily_status) or {}
        self.goalReward = response and response.data and response.data.data and response.data.data.user_tasks_daily_finished_status or {}
        self.goal = self:TableSort(self:HandleTaskData(self.goal))
        self.goalReward = TaskSystem:AwardSort(self:HandleTaskData(self.goalReward))
        self.plan = response and response.data and response.data.data and response.data.data.user_tasks_week_status or {}
        self.plan = self:TableSort(self:HandleTaskData(self.plan))
    end):catch(function(e)
        GameLogic.AddBBS(nil, L"任务获取失败，请重试", 3000, "255 0 0", 21);
    end);
end

-- 处理任务列表，添加status字段
-- status:  1-任务完成但是未领取 2-任务未完成-前往 3-任务未完成-未完成 4-已领取
-- course_id_type:  0-登录 1-分类 2-课程id  3-分享  4-每日完成次数 5-浏览家园区 6-  7-全部学习  8-全部游戏
-- reward_received: 表示奖励是否领取  0-未领取 1-领取
function TaskSystem:HandleTaskData(data)
    local newData = {}
    local index = 1;
    for k, v in pairs(data) do
        if v.finish_count_now < v.finish_count then
            if v.course_id_type == 0 or v.course_id_type == 3 or v.course_id_type == 7 or v.course_id_type == 8 then
                v.status = 3
            else
                v.status = 2
            end
        else
            if v.reward_received == 0 then
                v.status = 1
            else
                v.status = 4
            end
        end
        newData[index] = v
        newData[index]["reward_json"] = self:ChangeStrToNum(v["reward_json"]);
        index = index + 1
    end
    return newData
end

function TaskSystem:ChangeStrToNum(data)
    local newData = {}
    local index = 1;
    for k, v in pairs(data) do
        newData[index] = v
        index = index + 1
    end
    return newData
end

-- function TaskSystem:updateShareStatus()
--     -- 分享之后调用
--     local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
--     local response = request:get('/tasks/share-tasks',{},{sync = true})
-- end

-- 给任务列表排序 领取-前往-未完成-已领取
function TaskSystem:TableSort(t)
    table.sort(t, function(a, b)
        return a.status < b.status
    end)
    return t
end

-- 给小目标奖励排序
function TaskSystem:AwardSort(t)
    table.sort(t, function(a, b)
        return a.finish_count < b.finish_count
    end)
    return t
end

-- @param index 1-小目标 2-大计划
function TaskSystem:ShowPage(index)
    if TaskSystem.Page_ui ~= nil then
        TaskSystem.Page_ui:CloseWindow()
        TaskSystem.Page_ui = nil
    end

    Index = tonumber(index)
    TaskSystem.PageIndex = Index
    TaskSystem.Page_ui = AdaptWindow:QuickWindow(TaskSystem.params[Index])
end

-- 小目标奖励详情页面
function TaskSystem:ShowPopupPage(index, rewardIndex)
    if TaskSystem.popupui ~= nil then
        TaskSystem.popupui:CloseWindow()
    end

    Index = tonumber(index)

    if rewardIndex ~= nil then
        RewardIndex = tonumber(rewardIndex)
        TaskSystem.nowReward = TaskSystem.goalReward[RewardIndex]
        TaskSystem.nowReward["reward_json"] = TaskSystem:ChangeStrToNum(TaskSystem.goalReward[RewardIndex]["reward_json"])

        if(TaskSystem.nowReward["acquired"] == 0 and TaskSystem.goalReward["finished_task"] >= TaskSystem.reward_stage[RewardIndex])then --如果奖励未领取且达到领取资格
            TaskSystem.acquire_flag = 1
        else
            TaskSystem.acquire_flag = 0
        end
    end

    TaskSystem.popupui = AdaptWindow:QuickWindow(TaskSystem.popup[Index])
end

-- 处理任务
function TaskSystem:HandleClickEvent(data,type)
    if(data["status"] == 4)then   --奖励已领取
        return 
    elseif(data["status"] == 1)then   --奖励可领取
        data["reward_received"] = 1
        TaskSystem:GetReward(data["id"],data["reward_json"], type)
    elseif(data["status"] == 2) then  --前往
        if(data["course_id_type"] == 0 ) then
            --登录
            return
        else
            -- 跳转页面，教学课，专题课
            local info = TaskSystem:GetJumpId(data["redirect"])
            ToWhere:ShowPage(info.title, info.id)
        end
    else
        return
    end
end

-- 根据redirect字段获取将要跳转的世界id
-- @return worldInfo [json]
function TaskSystem:GetJumpId(redirect)
    local value = {}
    for k, v in ipairs(self.worldID) do
        if v.jumpTo == redirect then
            value = v
        end
    end
    return value
end

function TaskSystem:GetTaskDeac(data)
    local finish_type = {"", "次", "分钟"}
    local cur = data["finish_count_now"] > data["finish_count"] and data["finish_count"] or data["finish_count_now"]
    local total = data["finish_count"]
    local info = "("..cur.."/"..total..")"
    if(data["finish_type"] == 2) then 
        return info..finish_type[3]
    else 
        return info..finish_type[2]
    end
end

-- 领取奖励后更新道具列表
function TaskSystem:RefreshMoney(id, num)
    local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
    local id = tonumber(id)
    local num = tonumber(num)
    local info = Mod.CodePku.Store:Get('user/info')
    local wallets = info.user_wallets or {}
    local flag = false
    if #wallets == 0 then
        table.insert(wallets,{currency_id = id, amount = num})
    else
        for _, v in ipairs(wallets) do
            if v.currency_id == 1 and id == 1 then
                v.amount = v.amount + num
            elseif v.currency_id == 2 and id == 2 then
                v.amount = v.amount + num
            end
            if v.currency_id == id then -- 解决钱包中道具为0时未自增的问题
                flag = true
            end
        end
    end
    if not flag then
        table.insert(wallets,{currency_id = id, amount = num})
    end
    info.user_wallets = wallets --防止初始化钱包为nil的时候客户端不同步的bug
    Mod.CodePku.Store:Set('user/info', info)
end