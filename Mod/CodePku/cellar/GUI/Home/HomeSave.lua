--[[
Author:zouren
Date: 2020-11-17 18:26:03
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeSave.lua")
local HomeSave = commonlib.gettable("Mod.CodePku.GUI.HomeSave")
HomeSave:ShowPage()
-----------------------------------
]]--
-- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local HomeSave = commonlib.gettable("Mod.CodePku.GUI.HomeSave")

HomeSave.ui = nil

-- init default value
function HomeSave:OnInit()
    
end

-- 当且仅当bShow为false时为关闭页面
function HomeSave:ShowPage(bShow)
    --body
    if HomeSave.ui then
        HomeSave.ui:CloseWindow()
        HomeSave.ui = nil
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

    --HomeSave.ui = AdaptWindow:QuickWindow(params)
end
