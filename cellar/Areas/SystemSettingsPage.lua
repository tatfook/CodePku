--[[
Title: code behind for page SystemSettingsPage.html
Author(s): LiXizhi
Date: 2009/10/18
Desc: script/apps/Aries/Creator/Game/Areas/SystemSettingsPage.html
Use Lib:
-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/SystemSettingsPage.lua");
MyCompany.Aries.Creator.Game.Desktop.SystemSettingsPage.AutoAdjustGraphicsSettings(true, function(bChanged) end)
local stats = MyCompany.Aries.Creator.Game.Desktop.SystemSettingsPage.GetPCStats()
MyCompany.Aries.Creator.Game.Desktop.SystemSettingsPage.DoCheckMinimumSystemRequirement();
-------------------------------------------------------

-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/SystemSettingsPage.lua");
local SystemSettingsPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SystemSettingsPage");
SystemSettingsPage.ShowPage()
-------------------------------------------------------
]]

local SystemSettingsPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SystemSettingsPage");

local CodePkuSystemSettingsPage = NPL.export();

function CodePkuSystemSettingsPage.PageParams()
	return {
		url = "Mod/CodePku/cellar/Areas/SystemSettingsPage.html", 
		name = "SystemSettingsPage.ShowPage", 
		isShowTitleBar = false,
		DestroyOnClose = true,
		bToggleShowHide=true, 
		style = CommonCtrl.WindowFrame.ContainerStyle,
		allowDrag = false,
		enable_esc_key = true,
		--bShow = bShow,
		click_through = true, 
		zorder = -1,
		app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
		directPosition = true,
			align = "_ct",
			x = -480/2,
			y = -536/2,
			width = 490,
			height = 536,
	};
end

function CodePkuSystemSettingsPage.CheckBoxBackground(page, name, bChecked) 
	-- 系统设置弹框 - 各开关checked状态时的绿色背景
	page:CallMethod(name, "SetUIBackground", bChecked and "codepku/image/textures/modal/setting_32bits.png#964 595 268 46" or "codepku/image/textures/modal/setting_32bits.png#964 476 268 46");
end