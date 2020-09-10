--[[
Title: 任务结算
Author(s):  wanglj
Date: 2020.9.7
Desc: 任务结算界面
    --]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");

local TaskSettlement = NPL.export()

function TaskSettlement:GetUserInfo()
    local userInfo = {}
    local info = System.User.info
    userInfo.nickname = info.nickname or ''
    userInfo.avatar_url = info.avatar_url
    userInfo.avatar_frame_url = info.avatar_frame_url

    if not info.avatar_url or info.avatar_url ==''  then
        userInfo.avatar_url = 'codepku/image/textures/task_settlement/task_settlement.png#97 1246 124 126'
    end
    if not info.avatar_frame_url or info.avatar_frame_url ==''  then
        userInfo.avatar_frame_url = 'codepku/image/textures/task_settlement/task_settlement.png#280 1238 134 134'
    end
    return userInfo
end


function TaskSettlement:GetSubejectInfo()
    local subejectInfo = {}
    if TaskSettlement.data then
        subejectInfo.total_exp = TaskSettlement.data.total_exp or 0
        subejectInfo.subject_exp = TaskSettlement.data.subject_exp or 0
        subejectInfo.subject_name = TaskSettlement.data.subject_name
        subejectInfo.props = TaskSettlement.data.props or {}
        subejectInfo.subject_url = ''
        subejectInfo.total_level_info = TaskSettlement.data.total_level_info or {}
        subejectInfo.subject_level_info = TaskSettlement.data.subject_level_info or {}
    end

    local subjectUrls = {
        {subjectName='语文',subjectUrl='codepku/image/textures/subjects/subjects.png#161 49 69 83'},
        {subjectName='英语',subjectUrl='codepku/image/textures/subjects/subjects.png#256 56 75 68'},
        {subjectName='数学',subjectUrl='codepku/image/textures/subjects/subjects.png#381 49 72 87'},
        {subjectName='物理',subjectUrl='codepku/image/textures/subjects/subjects.png#503 72 75 60'},
        {subjectName='生物',subjectUrl='codepku/image/textures/subjects/subjects.png#618 57 71 75'},
        {subjectName='化学',subjectUrl='codepku/image/textures/subjects/subjects.png#742 57 62 71'},
        {subjectName='科学',subjectUrl='codepku/image/textures/subjects/subjects.png#834 57 86 71'},
        {subjectName='编程',subjectUrl='codepku/image/textures/subjects/subjects.png#36 180 79 76'},
        {subjectName='历史',subjectUrl='codepku/image/textures/subjects/subjects.png#149 185 73 66'},
    }

    for _,v in pairs(subjectUrls) do
        if v.subjectName == subejectInfo.subject_name then
            subejectInfo.subject_url = v.subjectUrl
            return subejectInfo
        end
    end
    return subejectInfo
end


function TaskSettlement.GetProps()
    if  TaskSettlement.subjectInfo == nil or TaskSettlement.subjectInfo.props == nil  or next(TaskSettlement.subjectInfo.props) == nil then
        return {}
    end

    table.sort(TaskSettlement.subjectInfo.props, function (a, b)
        if a.prop_id < b.prop_id then
            return true
        elseif  a.prop_id == b.prop_id then
            if a.prop_num < b.prop_num then
                return true
            else
                return false
            end
        else
            return false
        end
    end)
    return TaskSettlement.subjectInfo.props
end

function TaskSettlement.GetExpinfo()
    local expInfo = {
        totalCur  = TaskSettlement.subjectInfo.total_level_info.current_exp,
        totalNext  = TaskSettlement.subjectInfo.total_level_info.next_exp,
        totalLvUp  = TaskSettlement.subjectInfo.total_level_info.level_up,
        totalPer = TaskSettlement.subjectInfo.total_level_info.current_exp/TaskSettlement.subjectInfo.total_level_info.next_exp,

        subjectCur  = TaskSettlement.subjectInfo.subject_level_info.current_exp,
        subjectNext  = TaskSettlement.subjectInfo.subject_level_info.next_exp,
        subjectLvUp  = TaskSettlement.subjectInfo.subject_level_info.level_up,
        subjectPer = TaskSettlement.subjectInfo.subject_level_info.current_exp/TaskSettlement.subjectInfo.subject_level_info.next_exp,
    }
    return expInfo
end



function TaskSettlement:ShowPage(data)
    TaskSettlement.data = data
    --[[eg:
    {
        "total_exp": 0,
        "subject_exp": 0,
        "total_exp_name": "玩家经验",
        "subject_name": "语文经验",
        "props": [
            {
                "prop_id": 1,
                "prop_num": 0,
                "prop_name": "玩学币"
            },
            {
                "prop_id": 2,
                "prop_num": 0,
                "prop_name": "玩学券"
            }
        ]
    }
    --]]

    local params = {
        url = "Mod/CodePku/cellar/GUI/TaskSettlement/TaskSettlement.html", 
        alignment = "_ct",
        x = -960,
        y = -540,
        width = 1920,
        height = 1080,
        zorder = 30,
        };
    TaskSettlement.window = AdaptWindow:QuickWindow(params)
end