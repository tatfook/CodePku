--[[
des: common1 image data file
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")
]]

local common1ImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["btn_head.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 714, ["width"] = 238, ["height"] = 228,},
		["comm_btn_close.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 1925, ["top"] = 103, ["width"] = 77, ["height"] = 123,},
		["comm_btn_tips.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 1925, ["top"] = 229, ["width"] = 67, ["height"] = 67,},
		["comm_btn_yellow01.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 243, ["top"] = 714, ["width"] = 414, ["height"] = 160,},
		["common_bot_tooltip1.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 299, ["width"] = 723, ["height"] = 412,},
		["common_btn_b02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 231, ["width"] = 146, ["height"] = 65,},
		["common_btn_b_265_89.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 660, ["top"] = 714, ["width"] = 265, ["height"] = 88,},
		["common_btn_blue02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 151, ["top"] = 231, ["width"] = 146, ["height"] = 65,},
		["common_btn_cancel.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 1925, ["top"] = 53, ["width"] = 99, ["height"] = 47,},
		["common_btn_confirm.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 1925, ["top"] = 2, ["width"] = 100, ["height"] = 48,},
		["common_btn_green01.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 243, ["top"] = 877, ["width"] = 298, ["height"] = 101,},
		["common_btn_green02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 300, ["top"] = 231, ["width"] = 146, ["height"] = 65,},
		["common_btn_r_265_89.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 544, ["top"] = 877, ["width"] = 263, ["height"] = 89,},
		["common_btn_red01.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 810, ["top"] = 805, ["width"] = 238, ["height"] = 81,},
		["common_btn_red02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 449, ["top"] = 231, ["width"] = 146, ["height"] = 65,},
		["common_btn_yellow02.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 598, ["top"] = 231, ["width"] = 146, ["height"] = 65,},
		["common_tips_bg.png"] = { ["url"] = "codepku/image/textures/UI/common1/common1.png", ["left"] = 2, ["top"] = 2, ["width"] = 1920, ["height"] = 226,},
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