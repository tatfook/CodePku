--[[
des: common1 image data file
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")
]]

local common1ImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["btn_head.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 728, ["top"] = 185, ["width"] = 238, ["height"] = 228,},
		["comm_btn_close.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 669, ["width"] = 77, ["height"] = 123,},
		["comm_btn_tips.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 589, ["width"] = 67, ["height"] = 67,},
		["comm_btn_yellow01.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 417, ["width"] = 414, ["height"] = 160,},
		["common_bot_tooltip1.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 2, ["width"] = 723, ["height"] = 412,},
		["common_btn_b02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 720, ["top"] = 500, ["width"] = 146, ["height"] = 65,},
		["common_btn_b_265_89.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 728, ["top"] = 2, ["width"] = 265, ["height"] = 88,},
		["common_btn_blue02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 869, ["top"] = 500, ["width"] = 146, ["height"] = 65,},
		["common_btn_cancel.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 866, ["top"] = 619, ["width"] = 99, ["height"] = 47,},
		["common_btn_confirm.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 866, ["top"] = 568, ["width"] = 100, ["height"] = 48,},
		["common_btn_green01.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 419, ["top"] = 417, ["width"] = 298, ["height"] = 101,},
		["common_btn_green02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 419, ["top"] = 521, ["width"] = 146, ["height"] = 65,},
		["common_btn_r_265_89.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 728, ["top"] = 93, ["width"] = 263, ["height"] = 89,},
		["common_btn_red01.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 728, ["top"] = 416, ["width"] = 238, ["height"] = 81,},
		["common_btn_red02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 568, ["top"] = 521, ["width"] = 146, ["height"] = 65,},
		["common_btn_yellow02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 717, ["top"] = 568, ["width"] = 146, ["height"] = 65,},
	},
}

function common1ImageData:GetIconUrl(index)
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