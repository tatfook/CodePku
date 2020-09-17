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


function TaskSettlement:GetSubjectInfo()
    local subjectInfo = {}
    if self.data then
        subjectInfo.total_exp = self.data.total_exp or 0
        subjectInfo.subject_exp = self.data.subject_exp or 0
        subjectInfo.subject_name = self.data.subject_name
        subjectInfo.props = self.data.props or {}
        subjectInfo.subject_url = ''
        subjectInfo.total_level_info = self.data.total_level_info or {}
        subjectInfo.subject_level_info = self.data.subject_level_info or {}
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
        if v.subjectName == subjectInfo.subject_name then
            subjectInfo.subject_url = v.subjectUrl
            return subjectInfo
        end
    end
    return subjectInfo
end


function TaskSettlement:GetProps()
    if  self.subjectInfo == nil or self.subjectInfo.props == nil  or next(self.subjectInfo.props) == nil then
        return {}
    end

    table.sort(self.subjectInfo.props, function (a, b)
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
    return self.subjectInfo.props
end

function TaskSettlement:GetExpinfo()
    local expInfo = {
        totalCur  = self.subjectInfo.total_level_info.current_exp,
        totalNext  = self.subjectInfo.total_level_info.next_exp,
        totalLvUp  = self.subjectInfo.total_level_info.level_up,
        totalPer = self.subjectInfo.total_level_info.current_exp/self.subjectInfo.total_level_info.next_exp,

        subjectCur  = self.subjectInfo.subject_level_info.current_exp,
        subjectNext  = self.subjectInfo.subject_level_info.next_exp,
        subjectLvUp  = self.subjectInfo.subject_level_info.level_up,
        subjectPer = self.subjectInfo.subject_level_info.current_exp/self.subjectInfo.subject_level_info.next_exp,
    }
    return expInfo
end

function TaskSettlement:AddUpAaward()
    -- 统计所有获得的奖励
    if not self.ifEnd then
        if not self.allAward then
            self.allAward = {}
            self.allAward.totalExp = self.subjectInfo.total_exp
            self.allAward.subjectExp = self.subjectInfo.subject_exp
            self.allAward.subjectName = self.subjectInfo.subject_name
            self.allAward.subjectUrl  = self.subjectInfo.subject_url

            self.allAward.totalCur = self.expInfo.totalCur
            self.allAward.totalNext = self.expInfo.totalNext
            self.allAward.totalLvUp = self.expInfo.totalLvUp
            self.allAward.totalPer = self.expInfo.totalPer

            self.allAward.subjectCur = self.expInfo.subjectCur
            self.allAward.subjectNext = self.expInfo.subjectNext
            self.allAward.subjectLvUp = self.expInfo.subjectLvUp
            self.allAward.subjectPer = self.expInfo.subjectPer

            self.allProps = {}
            for _,v in pairs(self.props) do
                self.allProps[v.prop_id] = {prop_num = v.prop_num, prop_name = v.prop_name, prop_icon_url= v.prop_icon_url}
            end
        else
            self.allAward.totalExp = self.allAward.totalExp + self.subjectInfo.total_exp
            self.allAward.subjectExp = self.allAward.subjectExp + self.subjectInfo.subject_exp
            self.allAward.totalLvUp = self.allAward.totalLvUp + self.expInfo.totalLvUp
            self.allAward.subjectLvUp = self.allAward.subjectLvUp +  self.expInfo.subjectLvUp
            for _,v in pairs(self.props) do
                if self.allProps[v.prop_id] then
                    self.allProps[v.prop_id].prop_num = self.allProps[v.prop_id].prop_num + v.prop_num
                else
                    self.allProps[v.prop_id] = {prop_num = v.prop_num, prop_name = v.prop_name, prop_icon_url= v.prop_icon_url}
                end
            end
        end
    else
        if not self.allAward then self.allAward = {} end
        if not self.allProps then self.allProps = {} end

        self.allAward.totalExp = (self.allAward.totalExp or 0) + self.subjectInfo.total_exp
        self.allAward.subjectExp = (self.allAward.subjectExp or 0) + self.subjectInfo.subject_exp
        self.allAward.subjectName = self.subjectInfo.subject_name
        self.allAward.subjectUrl  = self.subjectInfo.subject_url

        self.allAward.totalCur = self.expInfo.totalCur
        self.allAward.totalNext = self.expInfo.totalNext
        self.allAward.totalLvUp = (self.allAward.totalLvUp or 0) + self.expInfo.totalLvUp
        self.allAward.totalPer = self.expInfo.totalPer

        self.allAward.subjectCur = self.expInfo.subjectCur
        self.allAward.subjectNext = self.expInfo.subjectNext
        self.allAward.subjectLvUp = (self.allAward.subjectLvUp or 0) +  self.expInfo.subjectLvUp
        self.allAward.subjectPer = self.expInfo.subjectPer
        for _,v in pairs(self.props) do
            if self.allProps[v.prop_id] then
                self.allProps[v.prop_id].prop_num = self.allProps[v.prop_id].prop_num + v.prop_num
            else
                self.allProps[v.prop_id] = {prop_num = v.prop_num, prop_name = v.prop_name, prop_icon_url= v.prop_icon_url}
            end
        end
    end

end

function TaskSettlement:GetOnceAward()
    local onceAward = {}
    local index = 1
    onceAward[index] = {name= L'玩学经验', num = self.subjectInfo.total_exp, type='totalExp'}
    index = index + 1
    if self.expInfo.totalLvUp > 0 then
        onceAward[index] = {name= L'玩学经验', up = self.expInfo.totalLvUp, type='totalLvUp'}
        index = index + 1
    end
    onceAward[index] = {name= self.subjectInfo.subject_name, num = self.subjectInfo.subject_exp, type='subjectExp'}
    index = index + 1
    if self.expInfo.subjectLvUp > 0 then
        onceAward[index] = {name= self.subjectInfo.subject_name, up = self.expInfo.subjectLvUp, type='subjectLvUp'}
        index = index +1
    end
    for _,v in pairs(self.props) do
        if v.prop_num > 0 then
            onceAward[index] = {name= v.prop_name, num = v.prop_num, type='prop'}
            index = index+1
        end
    end
    return onceAward
end


TaskSettlement.infoFormat = {
    totalExp = '您获得了%d%s',
    totalLvUp = "恭喜您升级啦！",
    subjectExp = '您获得了%d%s积分',
    subjectLvUp = '恭喜您%s升级啦！',
    prop = '您获得了%d%s',
}

function TaskSettlement:ShowInfo()
    local conmmandStr = ''
    TaskSettlement.curInfo = TaskSettlement.onceAward[TaskSettlement.infoIndex]
    if TaskSettlement.curInfo.type == 'totalExp' or TaskSettlement.curInfo.type == 'subjectExp' or TaskSettlement.curInfo.type == 'prop' then
        conmmandStr = string.format(TaskSettlement.infoFormat[TaskSettlement.curInfo.type], TaskSettlement.curInfo.num, TaskSettlement.curInfo.name)
    elseif TaskSettlement.curInfo.type == 'totalLvUp'  then
        conmmandStr = TaskSettlement.infoFormat[TaskSettlement.curInfo.type]
    elseif TaskSettlement.curInfo.type == 'subjectLvUp' then
        conmmandStr = string.format(TaskSettlement.infoFormat[TaskSettlement.curInfo.type], TaskSettlement.curInfo.name)
    end

    -- GameLogic.RunCommand("/tip -duration 1000 -color #FFD700 "..conmmandStr)
    GameLogic.AddBBS(TaskSettlement.timer, conmmandStr, 1000, "#FFD700");

    TaskSettlement.infoIndex = TaskSettlement.infoIndex + 1
    if TaskSettlement.infoIndex > # TaskSettlement.onceAward then
        TaskSettlement.timer:Change()
    end
end

function TaskSettlement:ShowPage(data, ifEnd)
    self.ifEnd = ifEnd
    self.data = data
    --[[data eg:
    {
        "total_exp": 333,
        "subject_exp": 166,
        "total_exp_name": "玩家经验",
        "subject_exp_name": "语文经验",
        "subject_name": "语文",
        "props": [
            {
                "prop_id": 1,
                "prop_num": 166,
                "prop_name": "玩学币",
                "prop_icon_url": "https://scratch-works-staging-1253386414.file.myqcloud.com/game/admin/propIcons/1.png"
            }
        ],
        "total_level_info": {
            "user_id": 185,
            "total_exp": 130908,
            "current_exp": 10163,
            "current_level": 25,
            "next_exp": 21610,
            "level_type": 11,
            "level_up": 0,
            "level_type_name": "总经验"
        },
        "subject_level_info": {
            "user_id": 185,
            "total_exp": 64740,
            "current_exp": 5945,
            "current_level": 21,
            "next_exp": 12300,
            "level_type": 1,
            "level_up": 0,
            "level_type_name": "语文"
        }

    }
    --]]

    self.subjectInfo = self:GetSubjectInfo()
    self.userInfo = self:GetUserInfo()
    self.props = self:GetProps()
    self.expInfo = self:GetExpinfo()

    self.onceAward = self:GetOnceAward()
    self.infoIndex = 1
    self.curInfo = self.onceAward[1]

    if self.ifEnd and self.allAward then
        local params = {
            url = "Mod/CodePku/cellar/GUI/TaskSettlement/TaskSettlement.html",
            alignment = "_ct",
            x = -960,
            y = -540,
            width = 1920,
            height = 1080,
            zorder = 31,
            }
        self.window = AdaptWindow:QuickWindow(params)
        self.allAward = nil --初始化统计的奖励
    else
        self:AddUpAaward() --累加奖励
        -- local params = {
        --     url = "Mod/CodePku/cellar/GUI/TaskSettlement/GeneralSettlement.html", 
        --     alignment = "_ct",
        --     x = -500,
        --     y = -350,
        --     width = 1000,
        --     height = 50,
        --     zorder = 30,
        --     };
        -- self.window = AdaptWindow:QuickWindow(params)

        if self.onceAward[1] then
            self.ShowInfo()
        end

        if #self.onceAward >=2 then
            self.timer = commonlib.TimerManager.SetInterval(self.ShowInfo, 1200)
        end
    end
end