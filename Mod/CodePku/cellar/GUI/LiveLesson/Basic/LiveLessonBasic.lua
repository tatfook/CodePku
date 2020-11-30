--[[usage:
NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasic.lua")
local LiveLessonBasic = commonlib.gettable("Mod.CodePku.Common.LiveLessonBasic")
LiveLessonBasic:ShowPage()
--]]
local LiveLessonBasic = NPL.export();
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local LiveLessonBasic = commonlib.gettable("Mod.CodePku.Common.LiveLessonBasic")

LiveLessonBasic.userSize = 1
LiveLessonBasic.teachTools = {
    [1] = {name = L"快速广播", bShow=true},
    [2] = {name = L"集合学生", bShow=true},
    [3] = {name = L"变大", bShow=true},
    [4] = {name = L"奖励", bShow=true},
    [5] = {name = L"分组", bShow=true},
}
LiveLessonBasic.studentTools = {
    [1] = {name = L"举手", bShow=true},
    [2] = {name = L"瞬移到老师身边", bShow=true},
    [3] = {name = L"举牌√", bShow=true},
    [4] = {name = L"举牌×", bShow=true},
}
LiveLessonBasic.broadcastTips = {
    [1] = {text = L"大家请安静", bShow=true},
    [2] = {text = L"大家现在自由练习3分钟", bShow=true},
    [3] = {text = L"还有1分钟, 大家抓紧时间", bShow=false},
    [4] = {text = L"我们继续上课", bShow=true},
    [5] = {text = L"有问题, 请举手", bShow=true},
    [6] = {text = L"上课了", bShow=false},
    [7] = {text = L"下课了", bShow=false},
}
LiveLessonBasic.students = {
    [1] = {name="名字最多七个一", bShow=true},
    [2] = {name="名字最多七个二", bShow=true},
    [3] = {name="名字最多七个三", bShow=true},
    [4] = {name="名字最多七个四", bShow=true},
    [5] = {name="名字最多七个五", bShow=true},
    [6] = {name="名字最多七个六", bShow=true},
    [7] = {name="名字最多七个七", bShow=true},
    [8] = {name="名字最多七个八", bShow=true},
    [9] = {name="名字最多七个九", bShow=true},
    [10] = {name="名字最多七个十", bShow=true},
    [11] = {name="名字最多七十一", bShow=true},
    [12] = {name="名字最多七十二", bShow=true},
}

LiveLessonBasic.params = {
    left = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicLeft.html",
		alignment="_lt", left = 20, top = 20, width = 200, height = 500, zorder=9,
    },
    right = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicRight.html",
		alignment="_lt", left = 1500, top = 20, width = 400, height = 800, zorder=9,
    },
    right_closed = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicRight.html",
		alignment="_lt", left = 1850, top = 20, width = 50, height = 800, zorder=9,
    },
    broadcast = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasicBroadCast.html",
		alignment="_lt", left = 220, top = 20, width = 200, height = 500, zorder=9,
    },
}

function LiveLessonBasic:GetStudents()
    return LiveLessonBasic.students
end

function LiveLessonBasic:GetIentity()
    return System.User.info.is_employee == 1
end

function LiveLessonBasic:RunGGSCommand(commandName, params)
    if commandName == "broadcast" then
        if params and params.text then
            GameLogic.RunCommand(string.format("/ggs cmd tip -color #ff0000 -duration 3000 %s", params.text))
        end
    elseif commandName == "call" then
        local EM = GameLogic.EntityManager
        local player = EM.GetPlayer()
        if(player) then
            local x, y, z = player:GetBlockPos()
            GameLogic.RunCommand(string.format("/ggs cmd goto %d %d %d", x, y, z))
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
    else
        GameLogic.RunCommand(string.format("/ggs cmd tip -color #0000ff -duration 3000 %s", commandName))
    end
end

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
    if self.windowBroadCast then
        self.windowBroadCast:CloseWindow()
        self.windowBroadCast = nil
    end
end

function LiveLessonBasic:ShowBroadCastPage()
    if self.windowBroadCast then
        self.windowBroadCast:CloseWindow()
        self.windowBroadCast = nil
    else
        self.windowBroadCast = AdaptWindow:QuickWindow(self.params.broadcast)
    end
end

function LiveLessonBasic:OnInit()
    LOG.std("", "info", "LiveLessonBasic", "OnInit");
    GameLogic:Connect("WorldLoaded", self, self.OnWorldLoaded, "UniqueConnection");
end

function LiveLessonBasic:OnWorldLoaded()
    --如果当前正在进入直播课就在进入世界后设置直播课判定变量为true
    if System.Codepku.isLoadingLiveLesson then
        System.Codepku.isLiveLesson = true
    else
        System.Codepku.isLiveLesson = false
    end
    --判定结束后置为false
    System.Codepku.isLoadingLiveLesson = false
end

-- 判断是否在直播课世界
function LiveLessonBasic:IsInLiveLesson()
    return System.Codepku and (System.Codepku.isLiveLesson or System.Codepku.isLoadingLiveLesson)
end