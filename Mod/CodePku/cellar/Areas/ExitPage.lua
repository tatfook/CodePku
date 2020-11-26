--[[
Title: ExitPage
Author: loujiayu
Date: 2020/10/23
-----------------------------------------------

local ExitPage = NPL.load("(gl)Mod/CodePku/cellar/Areas/ExitPage.lua");
ExitPage:ShowPage();
-----------------------------------------------
]]

local ExitPage = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")


function ExitPage:GetIcon(type, index)
    if type == 1 then
        return common1ImageData:GetIconUrl(index)
    elseif type == 2 then
        return escFrameImageData:GetIconUrl(index)
    end
end

function ExitPage:ShowPage()
    local params = {
        url="Mod/CodePku/cellar/Areas/ExitPage.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 1001, parent = ParaUI.GetUIObject("root")
    };
    AdaptWindow:QuickWindow(params)
end