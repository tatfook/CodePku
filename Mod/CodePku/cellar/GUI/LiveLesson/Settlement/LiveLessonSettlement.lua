--[[
Title: LiveLessonSettlement
Author: loujiayu
Date: 2020/11/26

Example:
-----------------------------------------------
local LiveLessonSettlement = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonSettlement.lua");
-----------------------------------------------
]]

local LiveLessonSettlement = NPL.export()
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local liveLessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/liveLessonImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");


-- 获取图标
function LiveLessonSettlement:GetIconPath(index)
    return liveLessonImageData:GetIconUrl(index)
end

-- 结算弹窗
function LiveLessonSettlement:ShowSettlementPage()
    if LiveLessonSettlement.settlement_page then
        LiveLessonSettlement.settlement_page:CloseWindow()
        LiveLessonSettlement.settlement_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonSettlement.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 10000
    }
    LiveLessonSettlement.settlement_page = AdaptWindow:QuickWindow(params)
    return LiveLessonSettlement.settlement_page
end