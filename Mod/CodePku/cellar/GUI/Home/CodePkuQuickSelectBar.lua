--[[
Author:zouren
Date: 2020-09-24 11:10:53
Des: 定制玩学世界自己的物品快速选择栏
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/CodePkuQuickSelectBar.lua")
local CodePkuQuickSelectBar = commonlib.gettable("Mod.CodePku.GUI.CodePkuQuickSelectBar")
CodePkuQuickSelectBar:ShowPage()
-----------------------------------
]]--
-- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local CodePkuQuickSelectBar = commonlib.gettable("Mod.CodePku.GUI.CodePkuQuickSelectBar")

-- init default value
function CodePkuQuickSelectBar:OnInit()
    
end

function CodePkuQuickSelectBar:ShowPage()
	--body
    params = {
        url = "",
        alignment="_ct",
        left = -960,
        top = -540,
        width = 1920,
        height = 1080,
        zorder = 20,
    }

    -- AdaptWindow:QuickWindow(params)
end
