--[[
des: liveLesson image data file
local liveLessonImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/liveLessonImageData.lua")
]]

local liveLessonImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["live_lesson_btn_blue.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 646, ["top"] = 1342, ["width"] = 115, ["height"] = 51,},
		["live_lesson_btn_blue_big.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 1048, ["width"] = 199, ["height"] = 67,},
		["live_lesson_btn_breen.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 872, ["top"] = 1127, ["width"] = 146, ["height"] = 65,},
		["live_lesson_btn_yellow_big.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 835, ["width"] = 320, ["height"] = 105,},
		["live_lesson_chuangjian.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 808, ["top"] = 1315, ["width"] = 158, ["height"] = 39,},
		["live_lesson_cion01.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 726, ["width"] = 337, ["height"] = 106,},
		["live_lesson_cion_pin.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 917, ["top"] = 1011, ["width"] = 103, ["height"] = 113,},
		["live_lesson_cion_return01.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 1118, ["width"] = 198, ["height"] = 67,},
		["live_lesson_cion_return02.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 764, ["top"] = 1357, ["width"] = 97, ["height"] = 39,},
		["live_lesson_comm.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 2, ["top"] = 726, ["width"] = 666, ["height"] = 470,},
		["live_lesson_comm_box_new.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 2, ["top"] = 1788, ["width"] = 454, ["height"] = 85,},
		["live_lesson_comm_frame.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 943, ["width"] = 316, ["height"] = 65,},
		["live_lesson_comm_x.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 941, ["top"] = 2, ["width"] = 77, ["height"] = 123,},
		["live_lesson_common_cot_floor.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 2, ["top"] = 2, ["width"] = 936, ["height"] = 721,},
		["live_lesson_countdown_bot.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 1011, ["width"] = 243, ["height"] = 34,},
		["live_lesson_frame_generatebtn.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 646, ["top"] = 1396, ["width"] = 86, ["height"] = 43,},
		["live_lesson_icon_enter_into01.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 671, ["top"] = 1188, ["width"] = 198, ["height"] = 67,},
		["live_lesson_icon_enter_into02.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 646, ["top"] = 1258, ["width"] = 159, ["height"] = 39,},
		["live_lesson_icon_enter_into03.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 646, ["top"] = 1300, ["width"] = 159, ["height"] = 39,},
		["live_lesson_qq.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 941, ["top"] = 171, ["width"] = 41, ["height"] = 48,},
		["live_lesson_weixin.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 2, ["top"] = 1199, ["width"] = 641, ["height"] = 586,},
		["live_lesson_weixin02.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 941, ["top"] = 128, ["width"] = 42, ["height"] = 40,},
		["live_lesson_x.png"] = { ["url"] = "codepku/image/textures/UI/liveLesson/liveLesson.png", ["left"] = 872, ["top"] = 1195, ["width"] = 117, ["height"] = 117,},
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