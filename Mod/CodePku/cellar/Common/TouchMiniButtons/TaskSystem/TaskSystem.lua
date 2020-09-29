--[[
Title: Page_ui
Author(s): NieXX
Date: 2020/9/11
Desc:
use the lib:
functions:
    TaskSystem:ShowPage()
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/TaskSystem.lua")
local TaskSystem = commonlib.gettable("Mod.CodePku.celler.TaskSystem")

TaskSystem = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/TaskSystem/TaskSystem.lua")
------------------------------------------------------------
]]


local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local ToWhere = commonlib.gettable("Mod.CodePku.GUI.Popup.ToWhere")
TaskSystem = commonlib.gettable("Mod.CodePku.celler.TaskSystem")
-- local TaskSystem = NPL.export()

TaskSystem.Page_ui = nil
TaskSystem.nowReward = nil
TaskSystem.PageIndex = nil
TaskSystem.acquire_flag = nil --判断奖励是可领取还是其他 1表示可领取

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
    self:GetTask(1)
    self:GetTask(2)

    GameLogic.GetFilters():remove_filter("TaskSystemList", TaskSystem.OnTaskFinished_Callback);
    GameLogic.GetFilters():add_filter("TaskSystemList", TaskSystem.OnTaskFinished_Callback);
end

function TaskSystem:OnTaskFinished_Callback(data)
    -- TODO 处理缓存table,先判断table是否为空
    -- 小目标 
    -- TODO 调接口更新后台数据
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:get('/tasks/share-tasks',{},)
end

function TaskSystem:GetReward(taskID,reward_json)
    echo("-------GetReward------")
    echo(taskID)
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:post('/tasks-reward-receive/store',{task_id=taskID},nil):next(function(response)
        if response.status == 200 then
            GameLogic.AddBBS(nil, L"领取成功", 3000, "255 0 0", 21);
            if TaskSystem.popupui then
                TaskSystem.popupui:CloseWindow()
            end
            echo("------------PageIndex----------")
            echo(TaskSystem.PageIndex)
            TaskSystem:GetTask(TaskSystem.PageIndex)
            TaskSystem.Page_ui:Refresh()

            for k,v in pairs(reward_json) do
                echo("---------RefreshMoney----------")
                echo(TaskSystem.nowReward);
                echo(v)
                TaskSystem:RefreshMoney(v.props_id,v.reward_num)
                local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
                if MainUIButtons.money_window ~= nil then
                    MainUIButtons.money_window:CloseWindow()
                    MainUIButtons.money_window = nil
                    MainUIButtons.show_money_ui()
                end
            end
            -- TaskSystem:RefreshMoney()
            local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
            if MainUIButtons.money_window ~= nil then
                MainUIButtons.money_window:CloseWindow()
                MainUIButtons.money_window = nil
                MainUIButtons.show_money_ui()
            end
        else
            GameLogic.AddBBS(nil, L"领取失败", 3000, "255 0 0", 21);
        end
    end):catch(function(e)
        GameLogic.AddBBS(nil, L"领取失败", 3000, "255 0 0", 21);
    end);
end

-- Get task list
-- @param flag: 1-day 2-week
function TaskSystem:GetTask(flag)
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    request:post('/tasks/user-tasks',{type=flag},nil):next(function(response)
        echo("----------user-tasks------------")
        echo(response.data.data)
        if flag == 1 then
            self.goal = response.data.data.user_tasks_daily_status or {}
            self.goalReward = response.data.data.user_tasks_daily_finished_status or {}
            self.goal = self:TableSort(self:HandleTaskData(self.goal))
            self.goalReward = TaskSystem:AwardSort(self:HandleTaskData(self.goalReward))
        elseif flag == 2 then
            self.plan = response.data.data.user_tasks_week_status or {}
            self.plan = self:TableSort(self:HandleTaskData(self.plan))
        end
        Mod.CodePku.Store:Set('taskSystem/goal', self.goal)
        Mod.CodePku.Store:Set('taskSystem/goalReward', self.goalReward)
        Mod.CodePku.Store:Set('taskSystem/plan', self.plan)

        if TaskSystem.Page_ui then
            TaskSystem.Page_ui:Refresh()
        end
    end):catch(function(e)
        GameLogic.AddBBS(nil, L"任务获取失败，请重试", 3000, "255 0 0", 21);
    end);
end

-- status:  1-任务完成但是未领取 2-任务未完成-前往 3-任务未完成-未完成 4-已领取
-- course_id_type:  0-登录 1-分类 2-课程id  3-分享  4-每日完成次数
-- reward_received: 表示奖励是否领取  0-未领取 1-领取
function TaskSystem:HandleTaskData(data)
    local newData = {}
    local index = 1;
    for k, v in pairs(data) do
        if v.finish_count_now < v.finish_count then
            if v.course_id_type == 3 or v.course_id_type == 0 then
            -- if v.course_id_type == 3 then
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

function TaskSystem:updateShareStatus()
    -- 分享之后调用
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:get('/tasks/share-tasks',{},{sync = true})
	if response.status == 200 then
        return true
	end
end

function TaskSystem:TableSort(t)
    table.sort(t, function(a, b)
        return a.status < b.status
    end)
    return t
end

function TaskSystem:AwardSort(t)
    table.sort(t, function(a, b)
        return a.finish_count < b.finish_count
    end)
    return t
end

function TaskSystem:ShowPage(index,flag)
    if TaskSystem.Page_ui ~= nil then
        TaskSystem.Page_ui:CloseWindow()
        TaskSystem.Page_ui = nil
    end

    Index = tonumber(index)
    TaskSystem.PageIndex = Index
    if flag then
        TaskSystem:GetTask(index)
    end
    TaskSystem.Page_ui = AdaptWindow:QuickWindow(TaskSystem.params[Index])
    
end

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

function TaskSystem:HandleClickEvent(data)
    echo("-------HandleClickEvent--------")
    echo(data)
    if(data["status"] == 4)then   --奖励已领取
        return 
    elseif(data["status"] == 1)then   --奖励可领取
        data["reward_received"] = 1
        TaskSystem:GetReward(data["id"],data["reward_json"])
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

function TaskSystem:RefreshMoney(id, num)
    echo("-------TaskSystem id num-------")
    echo(id)
    echo(num)
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