--[[
des: branch image data file
local branchImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/branchImageData.lua")
]]

local branchImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["branch_arrow_pen.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 906, ["top"] = 2, ["width"] = 88, ["height"] = 60,},
		["branch_boot_01.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 2, ["top"] = 2, ["width"] = 699, ["height"] = 1000,},
		["branch_boot_f.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 704, ["top"] = 46, ["width"] = 143, ["height"] = 38,},
		["branch_boot_g.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 2, ["top"] = 1115, ["width"] = 515, ["height"] = 106,},
		["branch_boot_w.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 2, ["top"] = 1005, ["width"] = 515, ["height"] = 107,},
		["branch_currentline.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 704, ["top"] = 87, ["width"] = 134, ["height"] = 57,},
		["branch_currentline_fireballoon.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 960, ["top"] = 65, ["width"] = 35, ["height"] = 57,},
		["branch_icon_g.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 850, ["top"] = 46, ["width"] = 52, ["height"] = 52,},
		["branch_icon_g_mat.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 704, ["top"] = 2, ["width"] = 199, ["height"] = 41,},
		["branch_icon_r.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 905, ["top"] = 65, ["width"] = 52, ["height"] = 52,},
		["branch_icon_y.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 841, ["top"] = 101, ["width"] = 52, ["height"] = 52,},
	},
}

function branchImageData:GetIconUrl(index)
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