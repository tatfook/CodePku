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
    CoursewareIDLimit = 8   -- 课件ID字数限制
}

-- 获取图标
function LiveLessonEntrance:GetIconPath(index)
    return liveLessonImageData:GetIconUrl(index)
end

-- 获取匹配码
function LiveLessonEntrance:GetMatchCode(param, page)
    --[[
    request:post('/class-room/store',param):next(function(response)
        
    end):catch(function(e)
        
    end);
    --]]
    page:SetValue("matchcode", "123456")
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