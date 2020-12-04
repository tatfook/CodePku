--[[
des: funcKeyboard image data file
local funcKeyboardImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/funcKeyboardImageData.lua")
]]

local funcKeyboardImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["funckeyboard_bot.png"] = { ["url"] = "codepku/image/textures/UI/funcKeyboard/funcKeyboard.png", ["left"] = 2, ["top"] = 958, ["width"] = 429, ["height"] = 577,},
		["funckeyboard_bot02.png"] = { ["url"] = "codepku/image/textures/UI/funcKeyboard/funcKeyboard.png", ["left"] = 2, ["top"] = 2, ["width"] = 749, ["height"] = 953,},
		["funckeyboard_key_bot.png"] = { ["url"] = "codepku/image/textures/UI/funcKeyboard/funcKeyboard.png", ["left"] = 754, ["top"] = 2, ["width"] = 192, ["height"] = 80,},
		["funckeyboard_keypad_titlemat.png"] = { ["url"] = "codepku/image/textures/UI/funcKeyboard/funcKeyboard.png", ["left"] = 754, ["top"] = 85, ["width"] = 166, ["height"] = 41,},
		["funckeyboard_tips_question.png"] = { ["url"] = "codepku/image/textures/UI/funcKeyboard/funcKeyboard.png", ["left"] = 949, ["top"] = 2, ["width"] = 34, ["height"] = 33,},
	},
}

function funcKeyboardImageData:GetIconUrl(index)
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