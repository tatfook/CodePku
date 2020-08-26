local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local TaskSystem = NPL.export()

TaskSystem.Page = nil
TaskSystem.nowReward = nil
TaskSystem.acquire_flag = nil --判断奖励是可领取还是其他 1表示可领取

-- 任务奖励表，详细奖励需根据字段来，需改变total_money, type_id
-- state = 表示奖励是否领取
TaskSystem.task_table = {
        { type="游览", title="每日登陆玩学世界", state=1, finished_times=1, total_times=1, type_id=0, total_money=8888, tp_title="大门", world_id=1 },
        { type="学习", title="完成任意教学课程", state=0, finished_times=0, total_times=5, type_id=1,total_money=33, tp_title="教学区", world_id = 15855 },
        { type="游戏", title="完成华夏游学记", state=0, finished_times=2, total_times=2, type_id=2, total_money=2, tp_title="华夏游学记", world_id = 13426},
        { type="游戏", title="完成单词爱跑酷", state=0, finished_times=1, total_times=3, type_id=3, total_money=898, tp_title="单词爱跑酷", world_id = 12896}
}

-- 累计奖励表，详细奖励需根据字段来，需改变info
--acquired表示奖励是否领取 1表示已领取
TaskSystem.reward_table = {finished_task = 10, total_task= 12, 
                                reward_detail = { 
                                    {acquired = 1, info = { {1} } },
                                    {acquired = 0, info = { {1}, {2} } },
                                    {acquired = 0, info = { {1}, {2}, {3} } },
                                    {acquired = 0, info = { {1}, {2}, {3}, {4} } },
                                    {acquired = 0, info = { {1}, {2}, {3}, {4}, {5} } }
                                } 
                            }

TaskSystem.reward_stage = {2, 4, 6, 8, 12}  -- 每阶段奖励需要完成的任务数

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

function TaskSystem:GetTask()

    TaskSystem.task_table = TaskSystem.task_table or {}

    table.sort(TaskSystem.task_table, function(a, b)
        if a.state == b.state then
            return a.title < b.title
        else
            return a.state < b.state
        end
    end)
end



function TaskSystem:ShowPage(index)
    
    if TaskSystem.Page ~= nil then
        TaskSystem.Page:CloseWindow()
    end

    Index = tonumber(index)

    TaskSystem.Page = AdaptWindow:QuickWindow(TaskSystem.params[Index])
end



function TaskSystem:ShowPopupPage(index, rewardIndex)
    
    if TaskSystem.popupui ~= nil then
        TaskSystem.popupui:CloseWindow()
    end

    Index = tonumber(index)

    if rewardIndex ~= nil then
        RewardIndex = tonumber(rewardIndex)
        TaskSystem.nowReward = TaskSystem.reward_table["reward_detail"][RewardIndex]
        if(TaskSystem.nowReward["acquired"] == 0 and TaskSystem.reward_table["finished_task"] >= TaskSystem.reward_stage[RewardIndex])then --如果奖励未领取且达到领取资格
            TaskSystem.acquire_flag = 1
        else
            TaskSystem.acquire_flag = 0
        end
    end

    TaskSystem.popupui = AdaptWindow:QuickWindow(TaskSystem.popup[Index])

end