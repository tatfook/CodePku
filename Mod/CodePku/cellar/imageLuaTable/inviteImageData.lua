--[[
des: invite image data file
local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")
]]

local inviteImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["invite_popup_bg.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 2, ["width"] = 1779, ["height"] = 969,},
		["invite_popup_btn.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 383, ["width"] = 77, ["height"] = 123,},
		["invite_popup_btn_blue.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 1965, ["width"] = 179, ["height"] = 61,},
		["invite_popup_btn_red.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 2, ["width"] = 179, ["height"] = 61,},
		["invite_popup_btn_s_b.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 665, ["top"] = 1670, ["width"] = 146, ["height"] = 55,},
		["invite_popup_btn_s_g.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1611, ["top"] = 1459, ["width"] = 146, ["height"] = 55,},
		["invite_popup_btn_s_r.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 375, ["top"] = 1965, ["width"] = 146, ["height"] = 55,},
		["invite_popup_btn_text_back.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 559, ["top"] = 1931, ["width"] = 71, ["height"] = 28,},
		["invite_popup_btn_text_copy.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 665, ["top"] = 1728, ["width"] = 143, ["height"] = 30,},
		["invite_popup_btn_text_invitation_records.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1483, ["top"] = 1699, ["width"] = 114, ["height"] = 30,},
		["invite_popup_btn_text_invite.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1483, ["top"] = 1732, ["width"] = 114, ["height"] = 30,},
		["invite_popup_btn_y.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1611, ["top"] = 1395, ["width"] = 179, ["height"] = 61,},
		["invite_popup_frame.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 974, ["width"] = 1484, ["height"] = 147,},
		["invite_popup_frame1.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 820, ["top"] = 1541, ["width"] = 660, ["height"] = 238,},
		["invite_popup_frame2.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 820, ["top"] = 1124, ["width"] = 788, ["height"] = 414,},
		["invite_popup_frame4.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 66, ["width"] = 168, ["height"] = 66,},
		["invite_popup_frame5.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 1670, ["width"] = 660, ["height"] = 258,},
		["invite_popup_frame6.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 1124, ["width"] = 815, ["height"] = 543,},
		["invite_popup_icon0.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1890, ["top"] = 135, ["width"] = 52, ["height"] = 51,},
		["invite_popup_icon1.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1793, ["top"] = 1395, ["width"] = 46, ["height"] = 61,},
		["invite_popup_icon2.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1966, ["top"] = 2, ["width"] = 51, ["height"] = 60,},
		["invite_popup_icon3.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1483, ["top"] = 1541, ["width"] = 103, ["height"] = 121,},
		["invite_popup_icon4.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1313, ["top"] = 1782, ["width"] = 103, ["height"] = 121,},
		["invite_popup_icon5.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1313, ["top"] = 1906, ["width"] = 102, ["height"] = 121,},
		["invite_popup_icon6.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 259, ["width"] = 102, ["height"] = 121,},
		["invite_popup_icon7.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 135, ["width"] = 103, ["height"] = 121,},
		["invite_popup_image.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 665, ["top"] = 1782, ["width"] = 645, ["height"] = 258,},
		["invite_popup_tab.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1489, ["top"] = 974, ["width"] = 298, ["height"] = 130,},
		["invite_popup_text1.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1611, ["top"] = 1517, ["width"] = 127, ["height"] = 30,},
		["invite_popup_text2.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1483, ["top"] = 1665, ["width"] = 124, ["height"] = 31,},
		["invite_popup_text3.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1483, ["top"] = 1765, ["width"] = 114, ["height"] = 29,},
		["invite_popup_title.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 184, ["top"] = 2013, ["width"] = 126, ["height"] = 30,},
		["invite_popup_title0.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 184, ["top"] = 1965, ["width"] = 188, ["height"] = 45,},
		["invite_popup_title2.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 1931, ["width"] = 554, ["height"] = 31,},
		["wechat_code.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1611, ["top"] = 1107, ["width"] = 264, ["height"] = 285,},
	},
}

function inviteImageData:GetIconUrl(index)
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