--[[
Author:zouren
Date: 2020-11-13 15:30:40
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeTitle.lua")
local HomeTitle = commonlib.gettable("Mod.CodePku.GUI.HomeTitle")
HomeTitle:ShowPage()
-----------------------------------
]]--
-- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local HomeTitle = commonlib.gettable("Mod.CodePku.GUI.HomeTitle")

HomeTitle.ui = nil

-- init default value
function HomeTitle:OnInit()
    
end

-- 当且仅当bShow为false时为关闭页面
function HomeTitle:ShowPage(bShow)
    --body
    if HomeTitle.ui then
        HomeTitle.ui:CloseWindow()
        HomeTitle.ui = nil
    end
    if bShow == false then
        return
    end
    params = {
        url = "",
        alignment="_ct",
        left = -960,
        top = -540,
        width = 1920,
        height = 1080,
        zorder = 20,
    }

    --HomeTitle.ui = AdaptWindow:QuickWindow(params)
end
