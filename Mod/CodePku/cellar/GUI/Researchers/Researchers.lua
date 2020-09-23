--[[
Title: Researchers
Author: loujiayu
Date: 2020/9/23
-----------------------------------------------

local Researchers = NPL.load("(gl)Mod/CodePku/cellar/GUI/Researchers/Researchers.lua");
Researchers:ShowPage(id);
-----------------------------------------------
]]

local Researchers = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");


Researchers.params = {
    [1] = {url="Mod/CodePku/cellar/GUI/Researchers/Board.html", alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,},
}

function Researchers:ShowPage(id)
    local id = tonumber(id)
    
end