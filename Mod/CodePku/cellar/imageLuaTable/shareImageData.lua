--[[
des: share image data file
local shareImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/shareImageData.lua")
]]

local shareImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["share_btn.png"] = { ["url"] = "codepku/image/textures/UI/share/share.png", ["left"] = 2, ["top"] = 1077, ["width"] = 395, ["height"] = 193,},
		["share_x.png"] = { ["url"] = "codepku/image/textures/UI/share/share.png", ["left"] = 1821, ["top"] = 2, ["width"] = 101, ["height"] = 102,},
		["sharebot.png"] = { ["url"] = "codepku/image/textures/UI/share/share.png", ["left"] = 2, ["top"] = 2, ["width"] = 1816, ["height"] = 1072,},
		["tape.png"] = { ["url"] = "codepku/image/textures/UI/share/share.png", ["left"] = 2, ["top"] = 1273, ["width"] = 278, ["height"] = 175,},
	},
}

function shareImageData:GetIconUrl(index)
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