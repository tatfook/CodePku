--[[
des: invite image data file
local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")
]]

local inviteImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["invite_popup_bg.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 2, ["width"] = 1779, ["height"] = 969,},
		["invite_popup_btn.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1966, ["top"] = 50, ["width"] = 77, ["height"] = 123,},
		["invite_popup_btn_blue.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 50, ["width"] = 179, ["height"] = 61,},
		["invite_popup_btn_red.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 114, ["width"] = 179, ["height"] = 61,},
		["invite_popup_btn_s_b.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 247, ["width"] = 146, ["height"] = 55,},
		["invite_popup_btn_s_g.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 305, ["width"] = 146, ["height"] = 55,},
		["invite_popup_btn_s_r.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 363, ["width"] = 146, ["height"] = 55,},
		["invite_popup_btn_text_back.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1975, ["top"] = 2, ["width"] = 71, ["height"] = 28,},
		["invite_popup_btn_text_copy.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 421, ["width"] = 143, ["height"] = 30,},
		["invite_popup_btn_text_invitation_records.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1930, ["top"] = 421, ["width"] = 114, ["height"] = 30,},
		["invite_popup_btn_text_invite.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1913, ["top"] = 454, ["width"] = 114, ["height"] = 30,},
		["invite_popup_frame.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 974, ["width"] = 1484, ["height"] = 147,},
		["invite_popup_frame1.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 793, ["top"] = 1124, ["width"] = 660, ["height"] = 238,},
		["invite_popup_frame2.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 1141, ["width"] = 788, ["height"] = 414,},
		["invite_popup_frame4.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 178, ["width"] = 168, ["height"] = 66,},
		["invite_popup_image.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 2, ["top"] = 1558, ["width"] = 645, ["height"] = 258,},
		["invite_popup_tab.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1489, ["top"] = 1008, ["width"] = 298, ["height"] = 130,},
		["invite_popup_title.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 454, ["width"] = 126, ["height"] = 30,},
		["invite_popup_title0.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1784, ["top"] = 2, ["width"] = 188, ["height"] = 45,},
		["invite_popup_title2.png"] = { ["url"] = "codepku/image/textures/UI/invite/invite.png", ["left"] = 1489, ["top"] = 974, ["width"] = 554, ["height"] = 31,},
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