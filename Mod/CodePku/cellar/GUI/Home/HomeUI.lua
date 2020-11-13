--[[
Author:zouren
Date: 2020-11-13 15:23:24
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeUI.lua")
local HomeUI = commonlib.gettable("Mod.CodePku.GUI.HomeUI")
HomeUI:ShowPage()
-----------------------------------
]]--
-- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local HomeUI = commonlib.gettable("Mod.CodePku.GUI.HomeUI")

HomeUI.ui = nil

-- init default value
function HomeUI:OnInit()
    
end

-- 当且仅当bShow为false时为关闭页面
function HomeUI:ShowPage(bShow)
    --body
    if HomeUI.ui then
        HomeUI.ui:CloseWindow()
        HomeUI.ui = nil
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

    --HomeUI.ui = AdaptWindow:QuickWindow(params)
end
