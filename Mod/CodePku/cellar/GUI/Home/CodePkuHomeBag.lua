--[[
Author:zouren
Date: 2020-09-25 10:00:06
Des: 家园区建造背包
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/CodePkuHomeBag.lua")
local CodePkuHomeBag = commonlib.gettable("Mod.CodePku.GUI.CodePkuHomeBag")
CodePkuHomeBag:ShowPage()
-----------------------------------
]]--
-- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local CodePkuHomeBag = commonlib.gettable("Mod.CodePku.GUI.CodePkuHomeBag")
CodePkuHomeBag.imagePath = "codepku/image/textures/bag/bag.png"

-- init default value
function CodePkuHomeBag:OnInit()
    
end

function CodePkuHomeBag:ShowPage()
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
