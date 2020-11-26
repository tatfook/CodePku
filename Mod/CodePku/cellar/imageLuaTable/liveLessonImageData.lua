--[[
des: liveLesson image data file
local liveLessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/liveLessonImageData.lua")
]]

local liveLessonImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["live_lesson_cion01.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 2, ["width"] = 337, ["height"] = 106,},
		["live_lesson_cion_pin.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 872, ["top"] = 179, ["width"] = 103, ["height"] = 113,},
		["live_lesson_cion_return01.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 179, ["width"] = 198, ["height"] = 67,},
		["live_lesson_cion_return02.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 872, ["top"] = 295, ["width"] = 96, ["height"] = 37,},
		["live_lesson_comm.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 2, ["top"] = 2, ["width"] = 666, ["height"] = 470,},
		["live_lesson_comm_frame.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 111, ["width"] = 316, ["height"] = 65,},
		["live_lesson_frame_generatebtn.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 833, ["top"] = 335, ["width"] = 86, ["height"] = 43,},
		["live_lesson_icon_enter_into01.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 249, ["width"] = 198, ["height"] = 67,},
		["live_lesson_icon_enter_into02.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 319, ["width"] = 159, ["height"] = 39,},
	},
}

function liveLessonImageData:GetIconUrl(index)
	local path = ""
	path = path..imageTable["frames"][index].url
	if imageTable["frames"][index].left then
		path = path..'#'
		path = path..tostring(imageTable["frames"][index].left)
		path = path..' '..tostring(imageTable["frames"][index].top)
		path = path..' '..tostring(imageTable["frames"][index].width)
		path = path..' '..tostring(imageTable["frames"][index].height)
	end
	return path
end