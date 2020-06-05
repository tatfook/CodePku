--[[
Title: 
Author(s):  
Date: 
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/main.lua");
local CodePku = commonlib.gettable("Mod.CodePku");
------------------------------------------------------------
]]

NPL.load("(gl)script/ide/Files.lua")
NPL.load("(gl)script/ide/Encoding.lua")
NPL.load("(gl)script/ide/System/Encoding/sha1.lua")
NPL.load("(gl)script/ide/System/Encoding/base64.lua")
NPL.load("(gl)script/ide/System/Windows/Screen.lua")
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/InternetLoadWorld.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/CreateNewWorld.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/LocalLoadWorld.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/RemoteServerList.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/ShareWorldPage.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/DownloadWorld.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/RemoteWorld.lua")
NPL.load("(gl)script/ide/System/Core/UniString.lua")
NPL.load("(gl)script/ide/System/Core/Event.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/TeacherAgent/TeacherAgent.lua")
NPL.load("(gl)script/ide/System/os/os.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Network/NPLWebServer.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/World/SaveWorldHandler.lua")
NPL.load("(gl)Mod/CodePku/service/SocketService.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Network/NetworkMain.lua")
NPL.load("(gl)script/ide/System/Encoding/guid.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Login/ParaWorldLessons.lua")
NPL.load("(gl)script/ide/System/Encoding/jwt.lua")

local Store = NPL.load("(gl)Mod/CodePku/store/Store.lua")
local MsgBox = NPL.load("(gl)Mod/CodePku/cellar/Common/MsgBox/MsgBox.lua")
local Utils = NPL.load("(gl)Mod/CodePku/helper/Utils.lua")
local MainLogin = NPL.load("(gl)Mod/CodePku/cellar/MainLogin/MainLogin.lua")
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua")
local PreventIndulge = NPL.load("(gl)Mod/CodePku/cellar/PreventIndulge/PreventIndulge.lua")
local UserConsole = NPL.load("(gl)Mod/CodePku/cellar/UserConsole/Main.lua")
local CodePkuDownloadWorld = NPL.load("(gl)Mod/CodePku/cellar/World/DownloadWorld.lua")
local CodePkuEscFramePage = NPL.load("(gl)Mod/CodePku/cellar/Areas/EscFramePage.lua")
local CodePkuSystemSettingsPage = NPL.load("(gl)Mod/CodePku/cellar/Areas/SystemSettingsPage.lua")
			
local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")

local CodePku = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.CodePku"));

CodePku:Property({"Name", "CodePku", "GetName", "SetName", { auto = true }})

-- register mod global variable
CodePku.Store = Store
CodePku.MsgBox = MsgBox
CodePku.Utils = Utils

function CodePku:ctor()
	
end

-- virtual function get mod name

function CodePku:GetName()
	return "CodePku"
end

-- virtual function get mod description 

function CodePku:GetDesc()
	return "CodePku is a plugin in paracraft"
end

function CodePku:init()
	GameLogic.GetFilters():add_filter(
			"ShowLoginModePage",
			function()
				MainLogin:Show()
				LOG.std(nil, "info", "CodePku", "add_filter ShowLoginModePage")
				return false
			end
	)

	-- 重写移动端虚拟小键盘
	GameLogic.GetFilters():add_filter(
			"TouchMiniKeyboard",
			function()
				local TouchMiniKeyboard = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/Main.lua");
				return TouchMiniKeyboard;
			end
	)

	GameLogic.GetFilters():add_filter(
			"TouchVirtualKeyboardIcon",
			function()
				NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchVirtualKeyboardIcon.lua");
				local TouchVirtualKeyboardIcon = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchVirtualKeyboardIcon")
				return TouchVirtualKeyboardIcon;
			end
	)


	-- replace load world page
	GameLogic.GetFilters():add_filter(
        "InternetLoadWorld.ShowPage",
        function(bEnable, bShow)
            UserConsole:ShowPage()
            return false
        end
	)

	GameLogic.GetFilters():add_filter(
		"ShowLoginBackgroundPage", 
		function (bShow, bShowCopyRight, bShowLogo, bShowBg) 
			LOG.std(nil, "info", "codepku", "add_filter ShowLoginBackgroundPage")			
			MainLogin:ShowLoadingPage()
			MainLogin:ShowLoginBackgroundPage()
			return false
		end
	)

	GameLogic.GetFilters():add_filter(
		"show_custom_download_world", 
		function (show, url) 
			LOG.std(nil, "info", "codepku", "add_filter show_custom_download_world")
			CodePkuDownloadWorld:ShowPage(url)
			return "close"
		end
	)

	GameLogic.GetFilters():add_filter(
        "cmd_loadworld", 
		function(url, options)
			LOG.std(nil, "info", "codepku", "add_filter cmd_loadworld")
            local pid = UserConsole:GetProjectId(url)
            if pid then
                UserConsole:HandleWorldId(pid)
                return
            else
                return url
            end
        end
	)	

	-- 下载世界进度条
	GameLogic.GetFilters():add_filter(
		"downloadFile_notify",
		function (downloadState, text, currentFileSize, totalFileSize)
			DownloadWorld.UpdateProgressText2(text)
		end
	)

	GameLogic.GetFilters():add_filter(
		"desktop_menu",
		function (menuItems) 
			return {}
		end
	)

	GameLogic.GetFilters():add_filter(
		"download_remote_world_show_bbs", 
		function ()
			return false
		end
	)
	
	GameLogic.GetFilters():add_filter(
		"file_downloader_show_label", 
		function ()
			return false
		end
	)
	GameLogic.GetFilters():add_filter(
		"AriesWindow.CustomStyle", 
		function (rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css, mode)
			local codepku_pe_aries_window = NPL.load("(gl)Mod/CodePku/cellar/Common/AriesWindow/pe_aries_window.lua");
			if (mode == "center") then
				codepku_pe_aries_window.create_center(rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css);
			elseif (mode == "thin" or mode == "mc") then
				codepku_pe_aries_window.create_thin_mc(rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css);
			end
			return false;
		end
	)

	GameLogic.GetFilters():add_filter(
		"EscFramePage.ShowPage",
		function (bShow)
			CodePkuEscFramePage:ShowPage(bShow)
			return true
		end
	)

	GameLogic.GetFilters():add_filter(
		"EnterTextDialog.PageParams",
		function (showParams)
			local CodePkuEnterTextDialog = NPL.load("(gl)Mod/CodePku/cellar/GUI/EnterTextDialog.lua")
			return CodePkuEnterTextDialog.PageParams(showParams)
		end
	)

	GameLogic.GetFilters():add_filter(
		"SystemSettingsPage.PageParams",
		function ()
			return CodePkuSystemSettingsPage.PageParams()
		end
	)

	GameLogic.GetFilters():add_filter(
		"SystemSettingsPage.CheckBoxBackground",
		function (page, name, bChecked)
			CodePkuSystemSettingsPage.CheckBoxBackground(page, name, bChecked)
			return false
		end
	)

	GameLogic.GetFilters():add_filter(
		"InventoryPage.PageParams",
		function ()
			local CodePkuInventoryPage = NPL.load("(gl)Mod/CodePku/cellar/Areas/InventoryPage.lua")
			return CodePkuInventoryPage.PageParams()
		end
	)
	
	GameLogic.GetFilters():add_filter(
		"InventoryPage.PageParams",
		function ()
			local CodePkuInventoryPage = NPL.load("(gl)Mod/CodePku/cellar/Areas/InventoryPage.lua")
			return CodePkuInventoryPage.PageParams()
		end
	)

	GameLogic.GetFilters():add_filter(
		"ChestPage.PageParams",
		function ()
			local CodePkuChestPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/ChestPage.lua")
			return CodePkuChestPage.PageParams()
		end
	)

	GameLogic.GetFilters():add_filter(
		"ShowExitDialog",
		function () 
			local Desktop = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop");			
			local dialog = {
				text = L"确定要退出当前世界么？", 
				callback = function(res)
					Desktop.is_exiting = false;
					if(res and res == _guihelper.DialogResult.OK) then
						Desktop.ForceExit(bRestart);
					elseif(res and res == _guihelper.DialogResult.Cancel) then
						Desktop.ForceExit(bRestart);
					end
				end,
				messageBoxButton = _guihelper.MessageBoxButtons.OKCancel
			}
			return dialog
		end
	)

	-- 重写加载世界页面
	Map3DSystem.App.MiniGames.SwfLoadingBarPage.url = "Mod/CodePKu/cellar/World/SwfLoadingBarPage.mc.html"

	local guiHelperDefaultTemplate = "Mod/CodePku/cellar/GUI/DefaultMessageBox.html"
	_guihelper.SetDefaultMsgBoxMCMLTemplate(guiHelperDefaultTemplate)
	-- prevent indulage
	PreventIndulge:Init()
end

function CodePku:OnLogin()
end
-- called when a new world is loaded. 

function CodePku:OnWorldLoad()
	UserConsole:ClosePage()
end
-- called when a world is unloaded. 

function CodePku:OnLeaveWorld()
end

function CodePku:OnDestroy()
end

function CodePku:OnInitDesktop()
	-- we will show our own UI here	
	log("CodePku:OnInitDesktop")
	-- UserConsole:ShowPage()
	-- return true
end

