--[[
des: escFrame image data file
local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")
]]

local escFrameImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["esc_frame__btn_green03.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 560, ["width"] = 238, ["height"] = 81,},
		["esc_frame_arrow_pen.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1932, ["top"] = 2, ["width"] = 88, ["height"] = 60,},
		["esc_frame_arrow_pen01.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1814, ["top"] = 314, ["width"] = 55, ["height"] = 75,},
		["esc_frame_bot_406_83.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 376, ["width"] = 406, ["height"] = 83,},
		["esc_frame_bot_428_109.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 88, ["width"] = 428, ["height"] = 109,},
		["esc_frame_bot_608_83.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 2, ["width"] = 608, ["height"] = 83,},
		["esc_frame_bot_floor.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 800, ["top"] = 945, ["width"] = 936, ["height"] = 721,},
		["esc_frame_bot_ground.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 2, ["top"] = 2, ["width"] = 1316, ["height"] = 940,},
		["esc_frame_bot_head.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1730, ["top"] = 393, ["width"] = 256, ["height"] = 256,},
		["esc_frame_bot_paper.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 2, ["top"] = 945, ["width"] = 795, ["height"] = 778,},
		["esc_frame_bot_tape.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1893, ["top"] = 294, ["width"] = 118, ["height"] = 79,},
		["esc_frame_btn.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1732, ["top"] = 201, ["width"] = 190, ["height"] = 68,},
		["esc_frame_btn_408_85.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 200, ["width"] = 408, ["height"] = 85,},
		["esc_frame_btn_408_85n.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 288, ["width"] = 408, ["height"] = 85,},
		["esc_frame_btn_cancel.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1576, ["top"] = 462, ["width"] = 78, ["height"] = 32,},
		["esc_frame_btn_enroll.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1752, ["top"] = 159, ["width"] = 158, ["height"] = 39,},
		["esc_frame_btn_nauthcode.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1321, ["top"] = 462, ["width"] = 252, ["height"] = 95,},
		["esc_frame_btn_nexttime.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1732, ["top"] = 272, ["width"] = 158, ["height"] = 39,},
		["esc_frame_btn_switch.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1752, ["top"] = 124, ["width"] = 159, ["height"] = 32,},
		["esc_frame_btn_upgrade.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1752, ["top"] = 88, ["width"] = 161, ["height"] = 33,},
		["esc_frame_r.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1732, ["top"] = 314, ["width"] = 79, ["height"] = 76,},
		["esc_frame_thumbtac.png"] = { ["url"] = "codepku/image/textures/UI/escFrame/escFrame.png", ["left"] = 1932, ["top"] = 65, ["width"] = 81, ["height"] = 226,},
	},
}

function escFrameImageData:GetIconUrl(index)
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