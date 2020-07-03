--[[
Title: Skin Page
Author(s): LiXizhi
Date: 2014/9/10
Desc: 
Use Lib:
-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/SkinPage.lua");
local SkinPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SkinPage");
SkinPage.ShowPage();
-------------------------------------------------------
]]

local CodePkuSkinPage = NPL.export();

function CodePkuSkinPage.PageParams()
	return {
		url = "Mod/CodePku/cellar/Areas/SkinPage.html", 
		name = "SkinPage.ShowPage", 
		isShowTitleBar = false,
		DestroyOnClose = true,
		--bToggleShowHide=true, 
		style = CommonCtrl.WindowFrame.ContainerStyle,
		allowDrag = true,
		enable_esc_key = true,
		--bShow = bShow,
		click_through = false, 
		zorder = -1,
		app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
		directPosition = true,
			align = "_ct",
			x = -500/2,
			y = -400/2,
			width = 500,
			height = 400,
	};
end