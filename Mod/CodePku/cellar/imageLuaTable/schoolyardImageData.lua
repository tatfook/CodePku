--[[
des: schoolyard image data file
local schoolyardImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/schoolyardImageData.lua")
]]

local schoolyardImageData = NPL.export()

local imageTable = {
	["frames"] = {
		["bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1317, ["top"] = 1669, ["width"] = 432, ["height"] = 609,},
		["schoolyard_bg.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2, ["top"] = 2, ["width"] = 1920, ["height"] = 1080,},
		["schoolyard_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1925, ["top"] = 877, ["width"] = 1348, ["height"] = 898,},
		["schoolyard_btn_cancel.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3951, ["top"] = 1712, ["width"] = 99, ["height"] = 47,},
		["schoolyard_btn_confirm.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3951, ["top"] = 1661, ["width"] = 100, ["height"] = 48,},
		["schoolyard_btn_gray_01.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 1909, ["width"] = 146, ["height"] = 65,},
		["schoolyard_btn_gray_02.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 2213, ["width"] = 238, ["height"] = 81,},
		["schoolyard_btn_gray_mat.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3951, ["top"] = 1762, ["width"] = 99, ["height"] = 39,},
		["schoolyard_btn_green_01.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 1977, ["width"] = 146, ["height"] = 65,},
		["schoolyard_btn_green_02.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2179, ["top"] = 2124, ["width"] = 238, ["height"] = 81,},
		["schoolyard_btn_green_mat.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3951, ["top"] = 1804, ["width"] = 98, ["height"] = 39,},
		["schoolyard_btn_in.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 1669, ["width"] = 159, ["height"] = 39,},
		["schoolyard_btn_quit.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 1711, ["width"] = 159, ["height"] = 39,},
		["schoolyard_btn_r.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2967, ["top"] = 1778, ["width"] = 263, ["height"] = 89,},
		["schoolyard_checkin_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2, ["top"] = 2120, ["width"] = 1171, ["height"] = 748,},
		["schoolyard_comm_x.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4002, ["top"] = 605, ["width"] = 77, ["height"] = 123,},
		["schoolyard_common_tips_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3300, ["top"] = 2, ["width"] = 723, ["height"] = 412,},
		["schoolyard_cursor.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4061, ["top"] = 35, ["width"] = 14, ["height"] = 21,},
		["schoolyard_exp.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4061, ["top"] = 2, ["width"] = 32, ["height"] = 30,},
		["schoolyard_exp_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2916, ["top"] = 1986, ["width"] = 339, ["height"] = 40,},
		["schoolyard_guidepost.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4002, ["top"] = 417, ["width"] = 91, ["height"] = 105,},
		["schoolyard_head_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2002, ["top"] = 2068, ["width"] = 174, ["height"] = 174,},
		["schoolyard_head_eg.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 1753, ["width"] = 153, ["height"] = 153,},
		["schoolyard_id_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2475, ["top"] = 2066, ["width"] = 307, ["height"] = 77,},
		["schoolyard_information_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3300, ["top"] = 417, ["width"] = 699, ["height"] = 981,},
		["schoolyard_information_mat.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1317, ["top"] = 1316, ["width"] = 458, ["height"] = 350,},
		["schoolyard_join_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2, ["top"] = 1085, ["width"] = 1312, ["height"] = 832,},
		["schoolyard_ranking_mat.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2525, ["top"] = 1954, ["width"] = 388, ["height"] = 109,},
		["schoolyard_school_tag.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1317, ["top"] = 1085, ["width"] = 533, ["height"] = 228,},
		["schoolyard_school_x.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4002, ["top"] = 731, ["width"] = 77, ["height"] = 106,},
		["schoolyard_schoolid_inputbox.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1908, ["top"] = 1778, ["width"] = 645, ["height"] = 83,},
		["schoolyard_schooltag_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3276, ["top"] = 1401, ["width"] = 672, ["height"] = 644,},
		["schoolyard_screening_results_01.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2556, ["top"] = 1778, ["width"] = 408, ["height"] = 85,},
		["schoolyard_screening_results_02.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1908, ["top"] = 1864, ["width"] = 408, ["height"] = 85,},
		["schoolyard_seek.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4002, ["top"] = 525, ["width"] = 78, ["height"] = 77,},
		["schoolyard_seek_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2525, ["top"] = 1866, ["width"] = 408, ["height"] = 85,},
		["schoolyard_surbase.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2, ["top"] = 2108, ["width"] = 1282, ["height"] = 9,},
		["schoolyard_tag_knot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 4026, ["top"] = 2, ["width"] = 32, ["height"] = 68,},
		["schoolyard_tag_pitchon_b.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2225, ["top"] = 1979, ["width"] = 247, ["height"] = 142,},
		["schoolyard_tagpitchon__y.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1752, ["top"] = 2068, ["width"] = 247, ["height"] = 142,},
		["schoolyard_term_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2319, ["top"] = 1864, ["width"] = 203, ["height"] = 68,},
		["schoolyard_trends_whole_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2319, ["top"] = 1935, ["width"] = 203, ["height"] = 41,},
		["shoolyard_comm_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1925, ["top"] = 2, ["width"] = 1372, ["height"] = 872,},
		["shoolyard_head_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3951, ["top"] = 1401, ["width"] = 131, ["height"] = 136,},
		["shoolyard_mat_head.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 3951, ["top"] = 1540, ["width"] = 117, ["height"] = 118,},
		["shoolyard_member_mat_bot.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2, ["top"] = 1920, ["width"] = 1295, ["height"] = 185,},
		["shoolyard_pagingtag_01.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2936, ["top"] = 1870, ["width"] = 322, ["height"] = 113,},
		["shoolyard_pagingtag_02.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 1901, ["top"] = 1952, ["width"] = 321, ["height"] = 113,},
		["shoolyard_pagingtag_03.png"] = { ["url"] = "codepku/image/textures/UI/schoolyard/schoolyard.png", ["left"] = 2916, ["top"] = 2029, ["width"] = 322, ["height"] = 113,},
	},
}

function schoolyardImageData:GetIconUrl(index)
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