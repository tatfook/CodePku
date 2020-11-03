--[[
des: mainFrame image data file
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")
]]

local mainFrameImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["main_wheel.png"] = { ["url"] = "codepku/image/textures/UI/mainFrame/mainFrame.png", ["left"] = 2, ["top"] = 326, ["width"] = 134, ["height"] = 134,},
		["main_wheel_arrows.png"] = { ["url"] = "codepku/image/textures/UI/mainFrame/mainFrame.png", ["left"] = 139, ["top"] = 326, ["width"] = 134, ["height"] = 134,},
		["main_wheel_bot.png"] = { ["url"] = "codepku/image/textures/UI/mainFrame/mainFrame.png", ["left"] = 2, ["top"] = 2, ["width"] = 321, ["height"] = 321,},
	},
}

function mainFrameImageData:GetIconUrl(index)
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