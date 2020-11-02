--[[
Title: Schoolyard
Author: loujiayu
Date: 2020/11/02
-----------------------------------------------
local Schoolyard = NPL.load("(gl)Mod/CodePku/cellar/GUI/Schoolyard/Schoolyard.lua");
Schoolyard:ShowPage();
-----------------------------------------------
]]

local Schoolyard = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

function Schoolyard:ShowPage()
    local params = {
    url="Mod/CodePku/cellar/GUI/Schoolyard/Schoolyard.html",
    alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 20
    };
    AdaptWindow:QuickWindow(params)
end
