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