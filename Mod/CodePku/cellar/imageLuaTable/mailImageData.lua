--[[
des: mail image data file
local mailImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mailImageData.lua")
]]

local mailImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["mail_boot.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 2, ["top"] = 1674, ["width"] = 960, ["height"] = 267,},
		["mail_bottomborder.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 2, ["top"] = 915, ["width"] = 1033, ["height"] = 756,},
		["mail_btn_1.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1175, ["top"] = 915, ["width"] = 166, ["height"] = 86,},
		["mail_btn_2.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1499, ["top"] = 914, ["width"] = 380, ["height"] = 120,},
		["mail_btn_delete.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1918, ["top"] = 427, ["width"] = 68, ["height"] = 78,},
		["mail_btn_delete_normal.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1882, ["top"] = 914, ["width"] = 161, ["height"] = 87,},
		["mail_btn_read_normal.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1429, ["top"] = 2501, ["width"] = 370, ["height"] = 110,},
		["mail_btn_read_selected.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1429, ["top"] = 2378, ["width"] = 380, ["height"] = 120,},
		["mail_btn_receive_normal.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1882, ["top"] = 1004, ["width"] = 161, ["height"] = 87,},
		["mail_btn_unread_selected.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1429, ["top"] = 2614, ["width"] = 370, ["height"] = 110,},
		["mail_icon_coin_0.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1918, ["top"] = 113, ["width"] = 126, ["height"] = 125,},
		["mail_icon_coin_1.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1038, ["top"] = 915, ["width"] = 134, ["height"] = 134,},
		["mail_icon_coin_3.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1918, ["top"] = 353, ["width"] = 73, ["height"] = 71,},
		["mail_icon_coin_4.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1918, ["top"] = 508, ["width"] = 63, ["height"] = 29,},
		["mail_icon_gift.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1994, ["top"] = 353, ["width"] = 50, ["height"] = 46,},
		["mail_Label.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1038, ["top"] = 1094, ["width"] = 983, ["height"] = 384,},
		["mail_pic.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 776, ["top"] = 2378, ["width"] = 650, ["height"] = 417,},
		["mail_pop_bg.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 2, ["top"] = 2, ["width"] = 1494, ["height"] = 910,},
		["mail_pop_delete.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 965, ["top"] = 1894, ["width"] = 905, ["height"] = 481,},
		["mail_popup_gain.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1038, ["top"] = 1481, ["width"] = 974, ["height"] = 410,},
		["mail_popup_remind.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 2, ["top"] = 1944, ["width"] = 771, ["height"] = 469,},
		["mail_tab_new.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1918, ["top"] = 241, ["width"] = 82, ["height"] = 53,},
		["mail_tab_read.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1918, ["top"] = 297, ["width"] = 82, ["height"] = 53,},
		["mail_title_shape.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1499, ["top"] = 2, ["width"] = 511, ["height"] = 108,},
		["mail_zhezhao.png"] = { ["url"] = "codepku/image/textures/UI/mail/mail.png", ["left"] = 1499, ["top"] = 113, ["width"] = 416, ["height"] = 798,},
	},
}

function mailImageData:GetIconUrl(index)
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