--[[
Title: Page
Author(s): NieXX
Date: 2020/9/11
Desc:
use the lib:
functions:
    Notice:ShowPage()
    Notice:IsNew(NoticeTime)
    Notice:GetStatus(flag,time)
    Notice:GetNoticeList()
    Notice:HandleNotice(content)
    Notice:GetArticleByID(id)
    Notice:HandleTitle(title)
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

TaskSystem.Page = nil
TaskSystem.nowReward = nil
TaskSystem.PageIndex = nil
TaskSystem.acquire_flag = nil --判断奖励是可领取还是其他 1表示可领取

TaskSystem.task_table = {}
TaskSystem.goal = {}
TaskSystem.goalReward = {}
TaskSystem.plan = {}
TaskSystem.worldID = {
    [1] = { title = "玩学大厅-大门(北大入口)", id = 1, name = "gate", jumpTo = 1, },
    [2] = { title = "教学区", id = 15855, name = "teach", jumpTo = 2, },
    [3] = { title = "专题区", id = 15877, name = "topic", jumpTo = 3, },
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

function TaskSystem:GetReward(taskID)
    echo("--------领取奖励-------")
    echo(taskID)
    echo(type(taskID))
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:post('/tasks-reward-receive/store',{task_id=taskID},{sync = true})
	if response.status == 200 then
        -- return true
        -- TaskSystem.Page:Refresh(0)
        GameLogic.AddBBS(nil, L"领取成功", 3000, "255 0 0", 21);
        if TaskSystem.popupui then
            TaskSystem.popupui:CloseWindow()
        end
        TaskSystem:ShowPage(TaskSystem.PageIndex)
    else
        GameLogic.AddBBS(nil, L"领取失败", 3000, "255 0 0", 21);
    end
    echo(response)
end

-- Get task list
-- @param flag: 0-day 1-week
function TaskSystem:GetTask(flag)
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:post('/tasks/user-tasks',{type=flag},{sync = true})
    if response.status == 200 then
        echo("----------user-tasks------------")
        echo(response.data.data)
        self.task_table = response.data.data or {};
        self.goal = response.data.data.user_tasks_daily_status or {};
        self.goalReward = response.data.data.user_tasks_daily_finished_status or {};
        self.plan = response.data.data.user_tasks_week_status or {};
	end

    -- 任务奖励表，详细奖励需根据字段来，需改变total_money, type_id
    -- reward_received = 表示奖励是否领取
    -- mock数据
    -- self.goal = {
    --     ["1"]={ tag_types= 0, intro="分享", reward_received=0, finish_count_now=0, finish_count=1, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="https://scratch-works-staging-1253386414.file.myqcloud.com/game/admin/propIcons/2.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, },  redirect=0, finish_type=3, course_id_type=3,},
    --     ["2"]={ tag_types= 1, intro="完成任意教学课程", reward_received=0, finish_count_now=5, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, } , redirect=1, finish_type=1,},
    --     { tag_types= 1, intro="每日登陆玩学世界", reward_received=1, finish_count_now=5, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}} } , redirect=2, finish_type=3, course_id_type=0,},
    --     { tag_types= 1, intro="3", reward_received=0, finish_count_now=0, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}} } , redirect=3, finish_type=1,},
    --     { tag_types= 1, intro="4", reward_received=0, finish_count_now=0, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}} } , redirect=4, },
    --     { tag_types= 1, intro="家园区", reward_received=0, finish_count_now=0, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}} } , redirect=5, },
    --     { tag_types= 1, intro="参与单词爱跑酷", reward_received=0, finish_count_now=0, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}} } , finish_type=1, redirect=31, },
    --     { tag_types= 1, intro="32", reward_received=0, finish_count_now=0, finish_count=5, reward_json = { {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=1, reward_num=1024,props_detail={prop_icon="game/admin/propIcons/11001.png"}}, {reward_type=0, reward_num=888,props_detail={prop_icon="game/admin/propIcons/11001.png"}} } , redirect=32, },
    -- }

    -- mock结束
    self.goal = self:TableSort(self:HandleTaskData(self.goal))
    self.goalReward = TaskSystem:AwardSort(self:HandleTaskData(self.goalReward))
    self.plan = self:TableSort(self:HandleTaskData(self.plan))
    echo(self.goalReward)
    echo(self.plan)
end

-- status:  1-任务完成但是未领取 2-任务未完成-前往 3-任务未完成-未完成 4-已领取
-- course_id_type:  0-登录 1-分类 2-课程id  3-分享  4-每日完成次数
-- reward_received: 表示奖励是否领取  0-未领取 1-领取
function TaskSystem:HandleTaskData(data)
    local newData = {}
    local index = 1;
    for k, v in pairs(data) do
        if v.finish_count_now < v.finish_count then
            if v.course_id_type == 3 then
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
    echo("--------更新之后调用-------")
    echo(taskID)
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

function TaskSystem:ShowPage(index)
    if TaskSystem.Page ~= nil then
        TaskSystem.Page:CloseWindow()
        TaskSystem.Page = nil
    end

    Index = tonumber(index)
    TaskSystem.PageIndex = Index
    TaskSystem:GetTask(index)
    TaskSystem.Page = AdaptWindow:QuickWindow(TaskSystem.params[Index])
    
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
        echo("--------------------nowReward")
        echo(TaskSystem.nowReward)
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
        TaskSystem:GetReward(data["id"])
        TaskSystem:GetTask("1")
    elseif(data["status"] == 2) then  --前往
        -- 跳转页面，教学课，专题课
        local info = TaskSystem:GetJumpId(data["redirect"])
        ToWhere:ShowPage(info.title, info.id)
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
