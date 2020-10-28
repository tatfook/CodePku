--[[
des: branch image data file
local branchImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/branchImageData.lua")
]]

local branchImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["branch_boot_01.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 2, ["top"] = 2, ["width"] = 699, ["height"] = 1000,},
		["branch_boot_g.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 2, ["top"] = 1115, ["width"] = 515, ["height"] = 106,},
		["branch_boot_w.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 2, ["top"] = 1005, ["width"] = 515, ["height"] = 107,},
		["branch_icon_g.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 906, ["top"] = 2, ["width"] = 52, ["height"] = 52,},
		["branch_icon_g_mat.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 704, ["top"] = 2, ["width"] = 199, ["height"] = 41,},
		["branch_icon_r.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 961, ["top"] = 2, ["width"] = 52, ["height"] = 52,},
		["branch_icon_y.png"] = { ["url"] = "codepku/image/textures/UI/branch/branch.png", ["left"] = 704, ["top"] = 46, ["width"] = 52, ["height"] = 52,},
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