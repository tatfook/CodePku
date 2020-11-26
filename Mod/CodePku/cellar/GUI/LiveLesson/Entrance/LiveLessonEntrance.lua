--[[
Title: LiveLessonEntrance
Author: loujiayu
Date: 2020/11/26

Example:
-----------------------------------------------
local LiveLessonEntrance = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Entrance/LiveLessonEntrance.lua");
-----------------------------------------------
]]

local LiveLessonEntrance = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local live_lessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/live_lessonImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

