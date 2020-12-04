--[[
Title: LiveLessonEntrance
Author: loujiayu
Date: 2020/11/26

Example:
-----------------------------------------------
local LiveLessonEntrance = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Entrance/LiveLessonEntrance.lua");
LiveLessonEntrance:ShowEntrancePage()   -- 加入房间
LiveLessonEntrance:ShowEstablishPage()  -- 创建房间
-----------------------------------------------
]]

local LiveLessonEntrance = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local liveLessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/liveLessonImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

-- 常量table
LiveLessonEntrance.constant = {
    MatchCodeLimit = 4,     -- 匹配码输入字数限制
    RoomNameLimit = 30,     -- 房间名字数限制
    CoursewareIDLimit = 8,  -- 课件ID字数限制
    CodeLimit = 10,         -- 匹配码CD
}

-- 获取图标
function LiveLessonEntrance:GetIconPath(index)
    return liveLessonImageData:GetIconUrl(index)
end

-- 获取匹配码
function LiveLessonEntrance:GetMatchCode(param, page)
    if LiveLessonEntrance.get_code then
        return
    end
    local RoomName = param.room_name
    local CoursewareID = param.keep_work_id
    if commonlib.utf8.len(CoursewareID) < 1 then
        GameLogic.AddBBS("CodeGlobals", L"请输入课件ID", 3000, "#FF0000");
        return
    end
    if commonlib.utf8.len(CoursewareID) > LiveLessonEntrance.constant.CoursewareIDLimit then
        GameLogic.AddBBS("CodeGlobals", L"课件ID不超过" .. tostring(LiveLessonEntrance.constant.CoursewareIDLimit) .. L"个字", 3000, "#FF0000");
        return
    end
    if commonlib.utf8.len(RoomName) < 1 then
        GameLogic.AddBBS("CodeGlobals", L"请输入房间名称", 3000, "#FF0000");
        return
    end
    if commonlib.utf8.len(RoomName) > LiveLessonEntrance.constant.RoomNameLimit then
        GameLogic.AddBBS("CodeGlobals", L"房间名称不超过" .. tostring(LiveLessonEntrance.constant.RoomNameLimit) .. L"个字", 3000, "#FF0000");
        return
    end
    if System.User.info.is_employee ~= 1 then
        GameLogic.AddBBS("CodeGlobals", L"只有老师才能创建房间", 3000, "#FF0000");
        return
    end
    -- 计时器CD
    if LiveLessonEntrance.TimerTimes then
        GameLogic.AddBBS("CodeGlobals", tostring(LiveLessonEntrance.TimerTimes) .. "秒后才能重新生成匹配码", 3000, "#FF0000");
        return
    end
    LiveLessonEntrance.TimerTimes = LiveLessonEntrance.constant.CodeLimit
    LiveLessonEntrance.get_code_timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            if LiveLessonEntrance.TimerTimes == 0 then
                LiveLessonEntrance.TimerTimes = nil
                timer:Change()
            else
                LiveLessonEntrance.TimerTimes = LiveLessonEntrance.TimerTimes - 1
            end
        end
    })

    LiveLessonEntrance.get_code = true
    request:post('/class-room/store',param):next(function(response)
        local data = response.data.data
        local code = tostring(data.match_code)
        page:SetValue("matchcode", code)
        LiveLessonEntrance.get_code_timer:Change(0, 1000)       -- 匹配码CD开启
        LiveLessonEntrance.get_code = false
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", L"匹配码生成失败,请检查输入的信息", 3000, "#FF0000");
        LiveLessonEntrance.TimerTimes = nil
        LiveLessonEntrance.get_code_timer:Change()
        LiveLessonEntrance.get_code = false
    end);
end

-- 进入房间
function LiveLessonEntrance:EnterRoom(code)
    if LiveLessonEntrance.entre_room then
        return
    end
    if commonlib.utf8.len(code) ~= 4 then
        GameLogic.AddBBS("CodeGlobals", L"请输入完整的匹配码", 3000, "#FF0000");
        return
    end
    local temp_code = tonumber(code)
    if not temp_code then
        GameLogic.AddBBS("CodeGlobals", L"请输入正确的匹配码", 3000, "#FF0000");
        return
    end
    local path = "/class-room/enter?match_code=" .. code
    LiveLessonEntrance.entre_room = true
    request:get(path):next(function(response)
        local data = response.data.data
        System.User.LiveLessonData = data       -- 房间信息存全局，进入房间后需要用到
        local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");
        if Config.defaultEnv == "RELEASE" then
            local command = "/connectCodePku -no=1 -isSyncBlock -isSyncCmd -host=106.53.147.185 -port=9901 " .. tostring(data.keep_work_id) .. " " .. tostring(data.match_code)
            GameLogic.RunCommand(command)
        else
            local command = "/connectCodePku -no=1 -isSyncBlock -isSyncCmd " .. tostring(data.keep_work_id) .. " " .. tostring(data.match_code)
            GameLogic.RunCommand(command)
        end
        System.Codepku.isLoadingLiveLesson = true       -- 统计时间的进入标记
        -- 关闭所有窗口
        LiveLessonEntrance:EntrancePageSpecialClose()
        LiveLessonEntrance:EstablishPageSpecialClose()
        LiveLessonEntrance.entre_room = false
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        LiveLessonEntrance.entre_room = false
    end);
end

-- 加入页面有输入框，需要把两个窗口都关掉
function LiveLessonEntrance:EntrancePageSpecialClose()
    if LiveLessonEntrance.EmptyBG then
        LiveLessonEntrance.EmptyBG:CloseWindow()
        LiveLessonEntrance.EmptyBG = nil
    end
    if LiveLessonEntrance.frist_page then
        LiveLessonEntrance.frist_page:CloseWindow()
        LiveLessonEntrance.frist_page = nil
    end
end

-- 加入房间弹窗
function LiveLessonEntrance:ShowEntrancePage()
    -- 这里有输入框，为了IOS适配，需要特殊处理下，再开一个空页面放下面
    if LiveLessonEntrance.EmptyBG then
        LiveLessonEntrance.EmptyBG:CloseWindow()
        LiveLessonEntrance.EmptyBG = nil
    end

    local BGparams = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/LiveLessonEmptyPage.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 21,
    }
    LiveLessonEntrance.EmptyBG = AdaptWindow:QuickWindow(BGparams)

    -- 加入房间页面
    if LiveLessonEntrance.frist_page then
        LiveLessonEntrance.frist_page:CloseWindow()
        LiveLessonEntrance.frist_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Entrance/LiveLessonEntrance.html",
        alignment="_lt", left = 608, top = 200, width = 704 , height = 528, zorder = 22
    }
    LiveLessonEntrance.frist_page = AdaptWindow:QuickWindow(params)
    return LiveLessonEntrance.frist_page
end

-- 关闭创建房间弹窗
function LiveLessonEntrance:EstablishPageSpecialClose()
    if LiveLessonEntrance.EmptyBG then
        LiveLessonEntrance.EmptyBG:CloseWindow()
        LiveLessonEntrance.EmptyBG = nil
    end
    if LiveLessonEntrance.establish_page then
        LiveLessonEntrance.establish_page:CloseWindow()
        LiveLessonEntrance.establish_page = nil
    end
end

-- 创建房间弹窗
function LiveLessonEntrance:ShowEstablishPage()
    if LiveLessonEntrance.EmptyBG then
        LiveLessonEntrance.EmptyBG:CloseWindow()
        LiveLessonEntrance.EmptyBG = nil
    end

    local BGparams = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/LiveLessonEmptyPage.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 21,
    }
    LiveLessonEntrance.EmptyBG = AdaptWindow:QuickWindow(BGparams)

    -- 创建房间页面
    if LiveLessonEntrance.establish_page then
        LiveLessonEntrance.establish_page:CloseWindow()
        LiveLessonEntrance.establish_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Entrance/LiveLessonEstablish.html",
        alignment="_lt", left = 608, top = 200, width = 704 , height = 528, zorder = 22
    }
    LiveLessonEntrance.establish_page = AdaptWindow:QuickWindow(params)
    return LiveLessonEntrance.establish_page
end