--[[
Title: ChestPage
Author(s): LiXizhi
Date: 2014/1/7
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/GUI/ChestPage.lua");
local ChestPage = commonlib.gettable("MyCompany.Aries.Game.GUI.ChestPage");
ChestPage.ShowPage(entity);
-------------------------------------------------------
]]

-- local ChestPage = commonlib.gettable("MyCompany.Aries.Game.GUI.ChestPage");
local CodePkuChestPage = NPL.export();

function CodePkuChestPage.PageParams()
	return {
		url = "Mod/CodePku/cellar/GUI/ChestPage.html", 
		name = "ChestPage.ShowPage", 
		isShowTitleBar = false,
		DestroyOnClose = true,
		bToggleShowHide=false, 
		style = CommonCtrl.WindowFrame.ContainerStyle,
		allowDrag = false,
		enable_esc_key = true,
		bShow = true,
		click_through = false, 
		zorder = -1,
		app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
		directPosition = true,
		align = "_ct",
		x = -512/2,
		y = -512/2,
		width = 512,
		height = 512,
	};
end
