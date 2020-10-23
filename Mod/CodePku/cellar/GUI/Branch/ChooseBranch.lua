--[[
Author:zouren
Date: 2020-10-22 19:07:23
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/ChooseBranch.lua")
local ChooseBranch = commonlib.gettable("Mod.CodePku.GUI.ChooseBranch")
ChooseBranch:ShowPage()
-----------------------------------
]]--
NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/BranchData.lua")
NPL.load("(gl)script/ide/UIAnim/UIAnimManager.lua")
local branchImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/branchImageData.lua")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")

local BranchData = commonlib.gettable("Mod.CodePku.GUI.BranchData")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local ChooseBranch = commonlib.gettable("Mod.CodePku.GUI.ChooseBranch")

ChooseBranch.ui = nil


ChooseBranch.HTMLStyleData = {
    [1] = { ["desc"] = "背景图片", ["position"] = "absolute", ["left"] = 624, ["top"] = 18, ["width"] = 699, ["height"] = 1000, ["background"] = "url("..branchImageData:GetIconUrl("branch_boot_01.png")..")",},
    [2] = { ["desc"] = "退出按钮", ["position"] = "absolute", ["left"] = 1213, ["top"] = 4, ["width"] = 77, ["height"] = 123, ["background"] = "url("..common1ImageData:GetIconUrl("comm_btn_close.png")..")",},
    [3] = { ["desc"] = "切换分线按钮", ["position"] = "absolute", ["left"] = 830, ["top"] = 957, ["width"] = 298, ["height"] = 101, ["background"] = "url("..common1ImageData:GetIconUrl("common_btn_green01.png")..")",},
    [4] = { ["desc"] = "爆满图标", ["position"] = "relative", ["left"] = 89, ["top"] = 186, ["width"] = 52, ["height"] = 52, ["background"] = "url("..branchImageData:GetIconUrl("branch_icon_r.png")..")",},
    [5] = { ["desc"] = "爆满文字", ["position"] = "relative", ["left"] = 161, ["top"] = 194, ["width"] = 104, ["height"] = 52, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "40px",},
    [6] = { ["desc"] = "繁忙图标", ["position"] = "relative", ["left"] = 278, ["top"] = 186, ["width"] = 52, ["height"] = 52, ["background"] = "url("..branchImageData:GetIconUrl("branch_icon_y.png")..")",},
    [7] = { ["desc"] = "繁忙文字", ["position"] = "relative", ["left"] = 350, ["top"] = 194, ["width"] = 104, ["height"] = 52, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "40px",},
    [8] = { ["desc"] = "流畅图标", ["position"] = "relative", ["left"] = 467, ["top"] = 186, ["width"] = 52, ["height"] = 52, ["background"] = "url("..branchImageData:GetIconUrl("branch_icon_g.png")..")",},
    [9] = { ["desc"] = "流畅文字", ["position"] = "relative", ["left"] = 539, ["top"] = 194, ["width"] = 104, ["height"] = 52, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "40px",},
    [10] = { ["desc"] = "标题文字", ["position"] = "relative", ["left"] = 210, ["top"] = 31, ["width"] = 400, ["height"] = 120, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "65px",},
    [11] = { ["desc"] = "滚动区域", ["position"] = "relative", ["left"] = 90, ["top"] = 256, ["width"] = 514, ["height"] = 670, ["background-color"] = "#00000010",},
    -- [11] = { ["desc"] = "滚动区域", ["position"] = "relative", ["left"] = 90, ["top"] = 256, ["width"] = 514, ["height"] = 670,},
    [12] = { ["desc"] = "分线栏背景(未选择)", ["position"] = "relative", ["width"] = 515, ["height"] = 106,["background"] = "url("..branchImageData:GetIconUrl("branch_boot_g.png")..")",},
    [13] = { ["desc"] = "分线栏背景(选中)", ["position"] = "relative", ["width"] = 515, ["height"] = 107,["background"] = "url("..branchImageData:GetIconUrl("branch_boot_w.png")..")",},
    [14] = { ["desc"] = "分线栏状态标签", ["position"] = "relative", ["left"] = 90, ["top"] = 256, ["width"] = 514, ["height"] = 670,["background"] = "url("..branchImageData:GetIconUrl("branch_boot_01.png")..")",},
    [15] = { ["desc"] = "分线栏文字",  ["position"] = "relative", ["left"] = 210, ["top"] = 31, ["width"] = 400, ["height"] = 120, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "50px",},
}

-- init default value
function ChooseBranch:OnInit()
    
end

function ChooseBranch:GetHTMLStyleStr(index)
    local htmlTable = ChooseBranch.HTMLStyleData[index]
    local styleStr = ""
    for k,v in pairs(htmlTable) do
        if k ~= "desc" then
            styleStr = styleStr..k..": "..v.."; "
        end
    end
    return styleStr
end

function ChooseBranch:PlayAnim()

end

-- 当且仅当bShow为false时为关闭页面
function ChooseBranch:ShowPage(bShow)
    --body
    if ChooseBranch.ui then
        ChooseBranch.ui:CloseWindow()
        ChooseBranch.ui = nil
    end
    if bShow == false then
        return
    end
    params = {
        name = "branch_choose",
        url = "Mod/CodePku/cellar/GUI/Branch/ChooseBranch.html",
        alignment="_ct",
        left = -960,
        top = -540,
        width = 1920,
        height = 1080,
        zorder = 20,
    }

    ChooseBranch.ui = AdaptWindow:QuickWindow(params)
end
