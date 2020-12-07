--[[usage:
NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasic.lua")
local LiveLessonBasic = commonlib.gettable("Mod.CodePku.Common.LiveLessonBasic")
LiveLessonBasic:ShowPage()
--]]
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local GeneralGameServerMod = commonlib.gettable("Mod.GeneralGameServerMod")
local UniString = commonlib.gettable("System.Core.UniString")
-- 导Editbox是为了改EmptyText的文本颜色，后面帕拉卡如果添加了对应的属性可以改掉这里的代码
NPL.load("(gl)script/ide/System/Windows/Controls/EditBox.lua")
local EditBox = commonlib.gettable("System.Windows.Controls.EditBox")

local liveLessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/liveLessonImageData.lua")
local LiveLessonBasic = commonlib.gettable("Mod.CodePku.Common.LiveLessonBasic")

LiveLessonBasic.userSize = 1
LiveLessonBasic.behaviorDelay = 3000 -- 举手等行为持续时间 毫秒
LiveLessonBasic.studentBtnDelay = 5 -- 学生快捷操作CD时间d 秒

-- 获取图标
function LiveLessonBasic:GetIconPath(index)
    return liveLessonImageData:GetIconUrl(index)
end

LiveLessonBasic.teachTools = {
    [1] = {name = L"快速广播", bShow=true},
    [2] = {name = L"集合学生", bShow=true},
    [3] = {name = L"变大", bShow=true},
    [4] = {name = L"奖励", bShow=true},
    [5] = {name = L"房间信息", bShow=true},
}
LiveLessonBasic.studentTools = {
    [1] = {name = L"举手", bShow=true},
    [2] = {name = L"瞬移到老师身边", bShow=true},
    [3] = {name = L"举牌√", bShow=true},
    [4] = {name = L"举牌×", bShow=true},
}

LiveLessonBasic.broadcastTips = {
    [1] = {text = L"大家请安静", path = LiveLessonBasic:GetIconPath("live_lesson_quietness.png"), bShow=true},
    [2] = {text = L"大家现在自由练习3分钟", path = LiveLessonBasic:GetIconPath("live_lesson_exercise.png"), bShow=true},
    [3] = {text = L"还有1分钟, 大家抓紧时间", path = LiveLessonBasic:GetIconPath("live_lesson_time.png"), bShow=true},
    [4] = {text = L"我们继续上课", path = LiveLessonBasic:GetIconPath("live_lesson_continue.png"), bShow=true},
    [5] = {text = L"有问题, 请举手", path = LiveLessonBasic:GetIconPath("live_lesson_hands.png"), bShow=true},
    [6] = {text = L"上课了", path = LiveLessonBasic:GetIconPath("live_lesson_classbegins.png"), bShow=true},
    [7] = {text = L"下课了", path = LiveLessonBasic:GetIconPath("live_lesson_classdismissed.png"), bShow=true},
}
LiveLessonBasic.students = {
    [1] = {name="名字最多七个一", userid=1, group=1, redflower=1, bShow=true},
    [2] = {name="名字最多七个二", userid=2, group=1, redflower=2, bShow=true},
    [3] = {name="名字最多七个三", userid=3, group=1, redflower=3, bShow=true},
    [4] = {name="名字最多七个四", userid=4, group=2, redflower=4, bShow=true},
    [5] = {name="名字最多七个五", userid=5, group=2, redflower=5, bShow=true},
    [6] = {name="名字最多七个六", userid=6, group=2, redflower=6, bShow=true},
    [7] = {name="名字最多七个七", userid=7, group=3, redflower=7, bShow=true},
    [8] = {name="名字最多七个八", userid=8, group=3, redflower=8, bShow=true},
    [9] = {name="名字最多七个九", userid=9, group=3, redflower=9, bShow=true},
    [10] = {name="名字最多七个十", userid=10, group=4, redflower=10, bShow=true},
    [11] = {name="名字最多七十一", userid=11, group=4, redflower=11, bShow=true},
    [12] = {name="名字最多七十二", userid=12, group=4, redflower=12, bShow=true},
    [13] = {name="名字最多七十三", userid=13, bShow=true},
    [14] = {name="名字最多七十四", userid=14, bShow=true},
}

LiveLessonBasic.params = {
    left = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicLeft.html",
		alignment="_lt", left = 0, top = 40, width = 210, height = 563, zorder=5,
    },
    right = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicRight.html",
		alignment="_lt", left = 1580, top = 20, width = 339, height = 1034, zorder=5,
    },
    right_closed = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicRight.html",
		alignment="_lt", left = 1886, top = 20, width = 34, height = 1034, zorder=5,
    },
    bottom = {
        --todo 2个底部按钮
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicBottom.html",
		alignment="_lt", left = 182, top = 977, width = 416, height = 81, zorder=5,
    },
    broadcast = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicBroadCast.html",
		alignment="_lt", left = 210, top = 110, width = 340, height = 468, zorder=6,
    },
    award = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicAward.html",
		alignment="_lt", left = 214, top = 126, width = 645, height = 538, zorder=6,
    },
    group = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicGroup.html",
		alignment="_ct", left = -1100/2, top = -850/2, width = 1100, height = 850, zorder=7,
    },
    tipboard = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicTipBoard.html",
		alignment="_lt", left = 510, top = 248, width = 895, height = 389, zorder=9,
    },
    groupwindow = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicGroupWindow.html",
		alignment="_ct", left = -1920/2, top = -1080/2, width = 1920, height = 1080, zorder=8,
    },
}

LiveLessonBasic.behaviorTable = {
    [1] = {name=L"举手", path=LiveLessonBasic:GetIconPath("live_lesson_studentsection_handsup.png")},
    [2] = {name=L"举牌√", path=LiveLessonBasic:GetIconPath("live_lesson_studentsection_r.png")},
    [3] = {name=L"举牌X", path=LiveLessonBasic:GetIconPath("live_lesson_studentsection_x.png")},
}

-- 返回学员table
function LiveLessonBasic:GetStudents()
    return LiveLessonBasic.students
end

-- 返回按组分的学员table
function LiveLessonBasic:GetGroups()
    local students = self.GetStudents()
    local groups = {}
    for k,v in ipairs(students) do
        if v.group then 
            if groups[v.group] then
                --groups[v.group][#groups[v.group]+1]["students"] = v
                groups[v.group]["students"][#groups[v.group]["students"]+1] = v
            else
                groups[v.group] = {students={[1] = v}}
            end
        end
    end
    return groups
end

-- 返回未分组学员table
function LiveLessonBasic:GetOtherStudents()
    local students = self.GetStudents()
    local others = {}
    local index = 1
    for k,v in ipairs(students) do
        if not v.group then
            others[index] = v
            index = index + 1
        end
    end
    return others
end

-- 身份判定
function LiveLessonBasic:GetIentity()
    if System.User.LiveLessonData and System.User.LiveLessonData.open_user_id then
        -- 创建人
        return System.User.LiveLessonData.open_user_id == System.User.info.id
    else
        -- is_employee
        return System.User.info.is_employee == 1
    end
end

-- userid获取学生在学员列表里的index
function LiveLessonBasic:GetStudentIndexByUserId(userid)
    local students = self:GetStudents()
    for index,student in ipairs(students) do
        if student.userid == userid then
            return index
        end
    end
end

function LiveLessonBasic:AddStudentToGroup()
    -- todo api
    local group = self.AddStudentToGroup_group
    local userid = self.AddStudentToGroup_userid
    local students = self:GetStudents()

    for index,student in ipairs(students) do
        if student.userid == userid then
            self.students[index]["group"] = group
            if self.windowGroupWindow then
                self.windowGroupWindow:CloseWindow()
                self.windowGroupWindow = nil
            end
            self.windowGroup:Refresh(0)
            return
        end
    end
end

function LiveLessonBasic:GetWorldInfo()
    local liveLessonData = System.User.LiveLessonData or {}
    return {
        roomName = liveLessonData.room_name or "",
        worldId = liveLessonData.keep_work_id or "",
        curBranch = liveLessonData.match_code or "",
        matchCode = liveLessonData.match_code or "",
    }
end

function LiveLessonBasic:CopyMatchCode()
    GameLogic.AddBBS("CodeGlobals", L"匹配码复制成功", 3000, "#00FF00")
    ParaMisc.CopyTextToClipboard(tostring(self:GetWorldInfo().matchCode))
end

function LiveLessonBasic:Grouping()
    self.ifGroupedFlag = true
    -- todo 分组 System.Codepku.liveLessonGroup
    self:ShowSubPage("group")
end

-- GGS CMD 需要ggs同步执行命令的功能在此实现, 大部分的老师教学工具
function LiveLessonBasic:RunGGSCommand(commandName, params)
    if commandName == "broadcast" then
        if params and params.text then
            GameLogic.RunCommand(string.format("/ggs cmd tip -color %s -duration %s %s", params.color or "#ff0000", params.duration or 3000, params.text))
        end
    elseif commandName == "call" then
        local EM = GameLogic.EntityManager
        local player = EM.GetPlayer()
        local r = 5 -- 学生围老师的圆形的半径
        if(player) then
            local x, y, z = player:GetBlockPos()
            local position = string.format("%s,%s,%s",x,y,z)
            GameLogic.RunCommand(string.format("/ggs cmd liveLesson call -position=%s -r=%s", position, r))
        end
    elseif commandName == "changesize" then
        self.userSize = if_else(self.userSize == 1, 2, 1)
        GameLogic.RunCommand(string.format("/scaling %d", self.userSize))
    elseif commandName == "changeMode" then
        local ifEditMode = GameLogic.GameMode:IsEditor()
        if ifEditMode then
            GameLogic.RunCommand(string.format("/ggs cmd mode %s", "game"))
        else
            GameLogic.RunCommand(string.format("/ggs cmd mode %s", "edit"))
        end
    elseif commandName == "entrance" then
        local username = System.User.info.nickname
        local isteacher = self:GetIentity()
        local userid = System.User.info.id
        GameLogic.RunCommand(string.format("/ggs cmd liveLesson entrance -username=%s -isteacher=%s -userid=%s", username, isteacher, userid))
    elseif commandName == "toteacher" then
        local userid = System.User.info.id
        GameLogic.RunCommand(string.format("/ggs cmd liveLesson toteacher -userid=%s", userid))
    elseif commandName == "kickout" then
        local userid = params.userid
        GameLogic.RunCommand(string.format("/ggs cmd liveLesson kickout -userid=%s", userid))
    elseif commandName == "forceplaymode" then
        local userid = params.userid
        GameLogic.RunCommand(string.format("/ggs cmd liveLesson forceplaymode -userid=%s", userid))
    elseif commandName == "redflower" then
        local _type = params.type
        local num = params.num
        local index = params.index
        local students = self:GetStudents()
        local username = students[index]["name"]
        local userid = students[index]["userid"]
        GameLogic.RunCommand(string.format("/ggs cmd liveLesson redflower -type=%s -num=%s -username=%s -userid=%s", _type, num, username, userid))

        -- 刷新奖励页面
        local num_change = _type == 1 and num or -num
        self.students[index]["redflower"] = (self.students[index]["redflower"] or 0) + num_change

        if self.windowAward then
            self.windowAward:Refresh(0)
        end
    else
        GameLogic.RunCommand(string.format("/ggs cmd tip -color #00ff00 -duration 3000 %s", commandName))
    end
end

-- 学生快捷操作功能
function LiveLessonBasic:QuickOperation(index)
    local curTime = os.time()

    if self.recordTime and curTime - self.recordTime < self.studentBtnDelay then
        -- 学生快捷操作CD
        return
    end

    local _type = nil
    local username = System.User.info.nickname
    local userid = System.User.info.id
    local EM = GameLogic.EntityManager
    local player = EM.GetPlayer()
    local entityid = player.entityId
    if index == 1 then
        _type = 1
    elseif index == 3 then
        _type = 2
    elseif index == 4 then
        _type = 3
    else
        return
    end
    local text = string.format("%s %s", username, LiveLessonBasic.behaviorTable[_type]["name"])
    self:RunGGSCommand("broadcast", {text=text, duration=self.behaviorDelay})
    GameLogic.RunCommand(string.format("/ggs cmd liveLesson behavior -type=%s -username=%s -userid=%s -entityid=%s", _type, username, userid, entityid))

    self.recordTime = curTime
end

-- 打开/收起右侧界面
function LiveLessonBasic:Switch()
    if self.windowRight then
        self.windowRight:CloseWindow()
        self.windowRight = nil
    end
    if not self.windowRight then
        if self.windowOpenFlag then
            self.windowOpenFlag = nil
            self.windowRightWidth = self.params.right_closed.width
            self.windowRight = AdaptWindow:QuickWindow(self.params.right_closed)
        else
            self.windowOpenFlag = true
            self.windowRightWidth = self.params.right.width
            self.windowRight = AdaptWindow:QuickWindow(self.params.right)
        end
    end
end

function LiveLessonBasic:ShowPage()
    self.windowOpenFlag = true
    self.windowRightWidth = self.params.right.width
    if not self.windowLeft then
        self.windowLeft = AdaptWindow:QuickWindow(self.params.left)
    end
    if not self.windowRight then
        self.windowRight = AdaptWindow:QuickWindow(self.params.right)
    end
    if not self.windowBottom and self.GetIentity() then
        self.windowBottom = AdaptWindow:QuickWindow(self.params.bottom)
    end
end

function LiveLessonBasic:CloseAllWindows()
    if self.windowLeft then
        self.windowLeft:CloseWindow()
        self.windowLeft = nil
    end
    if self.windowRight then
        self.windowRight:CloseWindow()
        self.windowRight = nil
    end
    if self.windowBottom then
        self.windowBottom:CloseWindow()
        self.windowBottom = nil
    end
    if self.windowBroadCast then
        self.windowBroadCast:CloseWindow()
        self.windowBroadCast = nil
    end
    if self.windowAward then
        self.windowAward:CloseWindow()
        self.windowAward = nil
    end
    if self.windowGroup then
        self.windowGroup:CloseWindow()
        self.windowGroup = nil
    end
    if self.windowWorldInfo then
        self.windowWorldInfo:CloseWindow()
        self.windowWorldInfo = nil
    end
    if self.windowConfirm then
        self.windowConfirm:CloseWindow()
        self.windowConfirm = nil
    end
end

--开关子页面
function LiveLessonBasic:ShowSubPage(pageName)
    if pageName == "broadcast" then
        if self.windowBroadCast then
            self.windowBroadCast:CloseWindow()
            self.windowBroadCast = nil
        else
            self.windowBroadCast = AdaptWindow:QuickWindow(self.params.broadcast)
        end
    elseif pageName == "award" then
        if self.windowAward then
            self.windowAward:CloseWindow()
            self.windowAward = nil
        else
            self.windowAward = AdaptWindow:QuickWindow(self.params.award)
        end
    elseif pageName == "group" then
        if self.windowWorldInfo then self.windowWorldInfo:CloseWindow() end
        self.windowWorldInfo = nil
        if self.windowConfirm then self.windowConfirm:CloseWindow() end
        self.windowConfirm = nil

        local params = nil
        if self.ifGroupedFlag then
            params = self.params.group
        else
            -- 打开之前先设置input标签的EmptyText文本颜色
            EditBox:Property({"EmptyTextColor", "#ffffff", auto=true})
            params = self.params.tipboard
        end

        if self.windowGroup then
            -- 关闭页面之后要还原为默认的，避免影响其它页面
	        EditBox:Property({"EmptyTextColor", "#888888", auto=true})
            self.windowGroup:CloseWindow()
            self.windowGroup = nil
        else
            self.tipBoardFlag = "grouping"  -- 通用html,标记是分组页面
            self.windowGroup = AdaptWindow:QuickWindow(params)
        end
    elseif pageName == "roominfo" then
        if self.windowGroup then self.windowGroup:CloseWindow() end
        self.windowGroup = nil
        if self.windowConfirm then self.windowConfirm:CloseWindow() end
        self.windowConfirm = nil

        if self.windowWorldInfo then
            self.windowWorldInfo:CloseWindow()
            self.windowWorldInfo = nil
        else
            self.tipBoardFlag = "roominfo"  -- 通用html,标记是房间信息页面
            self.windowWorldInfo = AdaptWindow:QuickWindow(self.params.tipboard)
        end
    elseif pageName == "confirm" then
        if self.windowWorldInfo then self.windowWorldInfo:CloseWindow() end
        self.windowWorldInfo = nil

        if self.windowConfirm then
            self.windowConfirm:CloseWindow()
            self.windowConfirm = nil
        else
            self.tipBoardFlag = "confirm"  -- 通用html,标记是房间信息页面
            self.windowConfirm = AdaptWindow:QuickWindow(self.params.tipboard)
        end
    elseif pageName == "groupwindow" then
        if self.windowGroupWindow then
            self.windowGroupWindow:CloseWindow()
            self.windowGroupWindow = nil
        else
            if self.windowGroupWindow then self.windowGroupWindow:CloseWindow() end
            self.windowGroupWindow = AdaptWindow:QuickWindow(self.params.groupwindow)
        end

    end
end

function LiveLessonBasic:OnInit()
    LOG.std("", "info", "LiveLessonBasic", "OnInit")
    GameLogic:Connect("WorldLoaded", self, self.OnWorldLoaded, "UniqueConnection")
    GameLogic:Connect("WorldUnloaded", self, self.OnWorldUnloaded, "UniqueConnection")
end

-- 进入直播世界
function LiveLessonBasic:OnWorldLoaded()
    --如果当前正在进入直播课就在进入世界后设置直播课判定变量为true
    if System.Codepku.isLoadingLiveLesson then
        System.Codepku.isLiveLesson = true

        local mytimer = commonlib.Timer:new({callbackFunc = function(timer)
            self:RunGGSCommand("entrance")
        end})
        mytimer:Change(self.behaviorDelay, nil)  --连上ggs服务器有延迟,需要延迟提示

        --计时
        self.startTime = os.time()

    else
        System.Codepku.isLiveLesson = false
    end
    --判定结束后置为false
    System.Codepku.isLoadingLiveLesson = false
end

-- 退出直播世界
function LiveLessonBasic:OnWorldUnloaded()
    self.ifGroupedFlag = nil

    if self:IsInLiveLesson() then
        -- todo
        -- local LiveLessonSettlement = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonSettlement.lua");
        -- LiveLessonSettlement:CloseTimer()

        self.endTime = os.time()
        if self.startTime then
            local retentionTime =  self.endTime - self.startTime
            -- todo 直播世界时间统计
            -- 初始化
            self.startTime = nil
            self.endTime = nil
        end
    end
end

-- 判断是否在直播课世界
function LiveLessonBasic:IsInLiveLesson()
    return System.Codepku and (System.Codepku.isLiveLesson or System.Codepku.isLoadingLiveLesson)
end

local function GetUserName(text)
    if type(text) ~= 'string' then
        return ''
    end

    local utf8Text = UniString:new(text)

    if _guihelper.GetTextWidth(text) > 112 then
        return utf8Text:sub(1, 8).text .. '...'
    else
        return text
    end
end

-- 设置头顶显示,用于表现学生行为举手/举牌
function LiveLessonBasic:SetHeadOnDisplay(entityid,_type,userid)
    local index =  self:GetStudentIndexByUserId(userid)
    if index then
        self.students[index].behavior = _type
        --todo 改为setvalue
        self.windowRight:Refresh(0)

    end
    local mytimer = commonlib.Timer:new({callbackFunc = function(timer)
        self.students[index].behavior = nil
        self.windowRight:Refresh(0)

    end})
    mytimer:Change(self.behaviorDelay, nil)

    self:SetHeadOnDisplaySelf(userid,_type) -- 触发者自己
    self:SetHeadOnDisplayBehaviorOthers(entityid,_type) -- 其他人看到触发者
end

-- 其他人看到触发者头顶显示信息
function LiveLessonBasic:SetHeadOnDisplayBehaviorOthers(entityid, _type)
    local netHandler = GeneralGameServerMod:GetClientClass("CodePku"):GetWorldNetHandler()
    if not netHandler then
        return
    end
    local player = netHandler:GetPlayerManager():GetPlayerByEntityId(entityid)
    if not player then
        return
    end

    local playerInfo = player:GetPlayerInfo()
    local userinfo = playerInfo.userinfo or {}
    local username = userinfo.nickname or playerInfo.username
    local state = playerInfo.state
    local usertag = state == "online" and userinfo.usertag or ""
    local color = self.isMainPlayer and "#ffffff" or "#0cff05"
    local playerUsernameStyle = state == "online" and "" or "shadow-quality:8; shadow-color:#2b2b2b;text-shadow:true;"
    local schoolName = userinfo.schoolName or ""
    if (schoolName ~= "") then schoolName = "&lt;" .. schoolName .. "&gt;" end

    local tagName = userinfo.is_employee and LiveLessonBasic:GetIconPath("live_lesson_tag_teacher.png") or LiveLessonBasic:GetIconPath("live_lesson_tag_student.png")
    local behaviorPath = self.behaviorTable[_type]["path"]
    local mcml_behavior = string.format([[
        <pe:mcml>
            <div style="width:200px; margin-left: -100px; margin-top: -90px; color: %s;">
                <div align="center" style="width:40;height:40;background:url(%s);background-animation:url(script/UIAnimation/CommonBounce.lua.table#ShakeUD);"></div>
                <div align="center" style="margin-top: 20px;">
                    %s
                    <div style="float:left; margin-left: -11px; margin-top: -2px; width:48;height:23;background:url(%s);"></div>
                    <div style="float:left; margin-left: 2px; font-weight:bold; font-size: 14px; base-font-size:14px; %s">%s</div>
                </div>
                <div style="text-align: center; font-weight: bold; font-size: 12px; base-font-size:12px; margin-top: 0px;">%s</div>
            </div>
        </pe:mcml>
        ]], color, behaviorPath, usertag, tagName, playerUsernameStyle, GetUserName(username), schoolName)
    player:SetHeadOnDisplay({url = ParaXML.LuaXML_ParseString(mcml_behavior)})

    local mytimer = commonlib.Timer:new({callbackFunc = function(timer)
        local mcml = string.format([[
            <pe:mcml>
                <div style="width:200px; margin-left: -100px; margin-top: -30px; color: %s;">
                    <div align="center" style="">
                        %s
                        <div style="float:left; margin-left: -11px; margin-top: -2px; width:48;height:23;background:url(%s);"></div>
                        <div style="float:left; margin-left: 2px; font-weight:bold; font-size: 14px; base-font-size:14px; %s">%s</div>
                    </div>
                    <div style="text-align: center; font-weight: bold; font-size: 12px; base-font-size:12px; margin-top: 0px;">%s</div>
                </div>
            </pe:mcml>
            ]], color, usertag, tagName, playerUsernameStyle, GetUserName(username), schoolName)
        player:SetHeadOnDisplay({url = ParaXML.LuaXML_ParseString(mcml)});
    end})

    mytimer:Change(self.behaviorDelay, nil)

end

-- 触发者自己头顶行为显示
function LiveLessonBasic:SetHeadOnDisplaySelf(userid,_type)
    if System.User.info.id ~= tonumber(userid) then
        -- 不是触发者直接return
        return
    end
    local EM = GameLogic.EntityManager
    local player = EM.GetPlayer()
    local playerInfo = player:GetPlayerInfo()
    local userinfo = playerInfo.userinfo or {}
    local username = userinfo.nickname or playerInfo.username
    local state = playerInfo.state
    local usertag = state == "online" and userinfo.usertag or ""
    local color = self.isMainPlayer and "#ffffff" or "#0cff05"
    local playerUsernameStyle = state == "online" and "" or "shadow-quality:8; shadow-color:#2b2b2b;text-shadow:true;"
    local schoolName = userinfo.schoolName or ""
    if (schoolName ~= "") then schoolName = "&lt;" .. schoolName .. "&gt;" end

    local tagName = userinfo.is_employee and LiveLessonBasic:GetIconPath("live_lesson_tag_teacher.png") or LiveLessonBasic:GetIconPath("live_lesson_tag_student.png")
    local behaviorPath = self.behaviorTable[_type]["path"]
    local mcml_behavior = string.format([[
        <pe:mcml>
            <div style="width:200px; margin-left: -100px; margin-top: -90px; color: %s;">
                <div align="center" style="width:40;height:40;background:url(%s);background-animation:url(script/UIAnimation/CommonBounce.lua.table#ShakeUD);"></div>
                <div align="center" style="margin-top: 20px;">
                    %s
                    <div style="float:left; margin-left: -11px; margin-top: -2px; width:48;height:23;background:url(%s);"></div>
                    <div style="float:left; margin-left: 2px; font-weight:bold; font-size: 14px; base-font-size:14px; %s">%s</div>
                </div>
                <div style="text-align: center; font-weight: bold; font-size: 12px; base-font-size:12px; margin-top: 0px;">%s</div>
            </div>
        </pe:mcml>
        ]], color, behaviorPath, usertag, tagName, playerUsernameStyle, GetUserName(username), schoolName)
    player:SetHeadOnDisplay({url = ParaXML.LuaXML_ParseString(mcml_behavior)})

    local mytimer = commonlib.Timer:new({callbackFunc = function(timer)
        local mcml = string.format([[
            <pe:mcml>
                <div style="width:200px; margin-left: -100px; margin-top: -30px; color: %s;">
                    <div align="center" style="">
                        %s
                        <div style="float:left; margin-left: -11px; margin-top: -2px; width:48;height:23;background:url(%s);"></div>
                        <div style="float:left; margin-left: 2px; font-weight:bold; font-size: 14px; base-font-size:14px; %s">%s</div>
                    </div>
                    <div style="text-align: center; font-weight: bold; font-size: 12px; base-font-size:12px; margin-top: 0px;">%s</div>
                </div>
            </pe:mcml>
                ]], color, usertag, tagName, playerUsernameStyle, GetUserName(username), schoolName)
        player:SetHeadOnDisplay({url = ParaXML.LuaXML_ParseString(mcml)});
    end})

    mytimer:Change(self.behaviorDelay, nil)
end