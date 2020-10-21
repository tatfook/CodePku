--[[
des: teach image data file
local teachImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/teachImageData.lua")
]]

local teachImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["class_1.png"] = { ["url"] = "codepku/image/textures/smallmap/teach/teach.png", ["left"] = 2, ["top"] = 2, ["width"] = 282, ["height"] = 219,},
		["class_2.png"] = { ["url"] = "codepku/image/textures/smallmap/teach/teach.png", ["left"] = 2, ["top"] = 224, ["width"] = 282, ["height"] = 219,},
		["class_3.png"] = { ["url"] = "codepku/image/textures/smallmap/teach/teach.png", ["left"] = 287, ["top"] = 2, ["width"] = 282, ["height"] = 219,},
		["class_4.png"] = { ["url"] = "codepku/image/textures/smallmap/teach/teach.png", ["left"] = 287, ["top"] = 224, ["width"] = 282, ["height"] = 219,},
		["class_5.png"] = { ["url"] = "codepku/image/textures/smallmap/teach/teach.png", ["left"] = 572, ["top"] = 2, ["width"] = 282, ["height"] = 219,},
		["class_6.png"] = { ["url"] = "codepku/image/textures/smallmap/teach/teach.png", ["left"] = 572, ["top"] = 224, ["width"] = 282, ["height"] = 219,},
	},
}

function teachImageData:GetIconUrl(index)
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