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
    if not TaskSettlement.subjectInfo or not TaskSettlement.subjectInfo.props or next(TaskSettlement.subjectInfo.props) == nil then
        local emptyProps = {  -- todo 测试数据,本为{}
            {prop_id=1,prop_num=100,prop_name='玩学币',prop_icon_url='codepku/image/textures/common_32bits.png#913 41 73 71'},
            {prop_id=2,prop_num=1,prop_name='玩学券',prop_icon_url='codepku/image/textures/common_32bits.png#913 136 77 78'},
            {prop_id=11001,prop_num=1,prop_name='补签卡',prop_icon_url='https://scratch-works-staging-1253386414.file.myqcloud.com/game/admin/propIcons/11001.png'},
            {prop_id=2,prop_num=2,prop_name='玩学券',prop_icon_url='codepku/image/textures/common_32bits.png#913 136 77 78'},
            {prop_id=1,prop_num=200,prop_name='玩学币',prop_icon_url='codepku/image/textures/common_32bits.png#913 41 73 71'},
        }
        table.sort(emptyProps, function (a, b)
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
        return emptyProps
    end

    local newProps = {}
    for _,v in pairs(TaskSettlement.subjectInfo.props) do
        if v.prop_num > 0 then
            if v.prop_id == 1 then
                v.prop_icon_url = 'codepku/image/textures/common_32bits.png#913 41 73 71'
                table.insert(newProps, v)
            elseif v.prop_id == 2 then
                v.prop_icon_url = 'codepku/image/textures/common_32bits.png#913 136 77 78'
                table.insert(newProps, v)
            else
                if not v.prop_icon_url then
                    v.prop_icon_url = ''
                end
                table.insert(newProps, v)
            end
        end
    end
    table.sort(newProps, function (a, b)
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
    return newProps
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