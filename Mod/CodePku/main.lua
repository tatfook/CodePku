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

-- codepku
NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
NPL.load("(gl)Mod/CodePku/online/main.lua");
NPL.load("(gl)Mod/CodePku/cellar/GUI/GenAndName.lua")


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
local AntiStuckPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/AntiStuck.lua")
local MainEntrencePage = NPL.load("(gl)Mod/CodePku/cellar/GUI/FastEntrence/MainEntrence.lua")
local SystemEntrence = NPL.load("(gl)Mod/CodePku/cellar/GUI/FastEntrence/SystemEntrence.lua")
local CompeteEntrence = NPL.load("(gl)Mod/CodePku/cellar/GUI/FastEntrence/CompeteEntrence.lua")
local TopicEntrence = NPL.load("(gl)Mod/CodePku/cellar/GUI/FastEntrence/TopicEntrence.lua")
local SharePage = NPL.load("(gl)Mod/CodePku/cellar/GUI/Share.lua")
local SubjectPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/Subject.lua")
local PropsInfo = NPL.load("(gl)Mod/CodePku/cellar/GUI/Props/PropsInfo.lua")
local RankPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/rank/RankPage.lua")
local Messages = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Messages.lua")
local MainPopup = NPL.load("(gl)Mod/CodePku/cellar/GUI/MainPopup/MainPopup.lua")
local SmallMap = NPL.load("(gl)Mod/CodePku/cellar/GUI/SmallMap/SmallMap.lua")
local ToWhere = NPL.load("(gl)Mod/CodePku/cellar/GUI/SmallMap/Popup/ToWhere.lua")
local SignInPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/SignIn/SignInPage.lua")
local FastEntrence = NPL.load("(gl)Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/FastEntrence.lua")
local TopicCourse = NPL.load("(gl)Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TopicCourse.lua")

local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")

local CodePku = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.CodePku"));
local GenAndName = commonlib.gettable("Mod.CodePku.GenAndName")


NPL.load("(gl)Mod/CodePku/cellar/Common/AriesWindow/pe_aries_window2.lua");
local pe_aries_window2 = commonlib.gettable("Mod.CodePku.Common.AriesWindow.pe_aries_window2");
pe_aries_window2:RegisterAs("pe:aries_window2");

CodePku:Property({"Name", "CodePku", "GetName", "SetName", { auto = true }})

-- register mod global variable
CodePku.Store = Store
CodePku.MsgBox = MsgBox
CodePku.Utils = Utils
CodePku.BasicConfig = {}

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
	ParaAsset.SetAssetServerUrl("http://cdn.wanxue.codepku.com/");
	-- ParaAsset.SetAssetServerUrl("http://cdnwanxue.local.codepku.com/");

	local manifestUrl = "http://cdnwanxue.codepku.com/assets_manifest_codepku.txt?version=" .. os.time();
	local _, _, asset = System.os.GetUrl(manifestUrl);

	NPL.load("(gl)script/apps/Aries/Creator/Game/Login/ParaWorldLoginDocker.lua");
	local ParaWorldLoginDocker = commonlib.gettable("MyCompany.Aries.Game.MainLogin.ParaWorldLoginDocker")
	local redistFolder = ParaWorldLoginDocker.GetCurrentRedistFolder();
	redistFolder = redistFolder:gsub("\\", "/");
	
	local assetManifest = ParaIO.open(redistFolder.."assets_manifest_codepku.txt", 'w');
	assetManifest:WriteString(asset);
	assetManifest:close();

	local asset_manager = ParaEngine.GetAttributeObject():GetChild("AssetManager");
	local asset_manifest = asset_manager:GetChild("CAssetManifest");
	asset_manifest:SetField("LoadManifestFile", redistFolder.."assets_manifest_codepku.txt");

	self:BasicConfig();

	GameLogic.GetFilters():add_filter(
			"ShowLoginModePage",
			function()
				MainLogin:Show()
				LOG.std(nil, "info", "CodePku", "add_filter ShowLoginModePage")
				return false
			end
	)

	--退出世界时将世界课程数据置位空
	GameLogic.GetFilters():add_filter(
			"OnWorldUnloaded",
			function()
				if System.Codepku.isHome or System.Codepku.isLoadingHome then
					commonlib.setfield("System.Codepku.Coursewares", nil)
				end
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
			if GenAndName.CheckNickName() then
				UserConsole:ShowPage()
			else
				GenAndName.Init()
				GenAndName:ShowPage()
			end
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
		function (show, rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css, mode)							
			local codepku_pe_aries_window = NPL.load("(gl)Mod/CodePku/cellar/Common/AriesWindow/pe_aries_window.lua");
			if (mode == "center") then
				codepku_pe_aries_window.create_center(rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css);
			elseif (mode == "thin" or mode == "mc") then
				codepku_pe_aries_window.create_thin_mc(rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css);
			elseif (mode == "modal") then
				codepku_pe_aries_window.create_modal(rootName, mcmlNode, bindingContext, _parent, left, top, right, bottom, myLayout, css);
			end
			return true;
		end
	)

	GameLogic.GetFilters():add_filter(
		"EscFramePage.ShowPage",
		function (default, bShow)
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
		"SkinPage.PageParams",
		function ()
			local CodePkuSkinPage = NPL.load("(gl)Mod/CodePku/cellar/Areas/SkinPage.lua")
			return CodePkuSkinPage.PageParams()
		end
	)

	GameLogic.GetFilters():add_filter(
		"ShowExitDialog",
		function (bRestart) 
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

	GameLogic.GetFilters().add_filter(
		"AntiStuckPage:AntiStuck",
		function (bShow)
			AntiStuckPage:ShowPage(bShow)
			return true
		end
	)
	
	GameLogic.GetFilters():add_filter(
		"GameName",
		function ()
			return L"玩学世界"
		end
	)

	GameLogic.GetFilters():add_filter(
		"GameDescription",
		function ()
			return L"3D沉浸式游戏化教育平台"
		end
	)

	GameLogic.GetFilters():add_filter(
		"WorldName.ResetWindowTitle",
		function (title, windowTitle)
			echo("WorldName.ResetWindowTitle")
			
			return windowTitle
		end
	)

	-- 主界面ui按钮
	GameLogic.GetFilters():add_filter(
		"MainUIButtons",
		function()
			local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
			return MainUIButtons;
		end
	)

	-- 重写加载世界页面
	Map3DSystem.App.MiniGames.SwfLoadingBarPage.url = "Mod/CodePku/cellar/World/SwfLoadingBarPage.mc.html"

	local guiHelperDefaultTemplate = "Mod/CodePku/cellar/GUI/DefaultMessageBox.html"
	_guihelper.SetDefaultMsgBoxMCMLTemplate(guiHelperDefaultTemplate)
	-- prevent indulage
	PreventIndulge:Init()

	local Online = commonlib.gettable("Mod.CodePku.Online");
    Online:Init();   

    local CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");
	CodepkuChatChannel.StaticInit();

	NPL.load("(gl)Mod/CodePku/cellar/GUI/CourseLoadTips/CourseLoadTips.lua");
	local CourseLoadTips = commonlib.gettable("Mod.CodePku.GUI.CourseLoadTips")
	CourseLoadTips.StaticInit();

	--初始化世界加载完毕后时候家园区标识变量
	NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeManage.lua");
	local HomeManage = commonlib.gettable("Mod.CodePku.Common.HomeManage")
	HomeManage:OnInit()

	GameLogic.GetFilters():add_filter(
		"DesktopMenuPage.ShowPage",
		function(bShow)
			return true;
		end
	);

	GameLogic.GetFilters():add_filter(
		"QuickSelectBar.ShowPage",
		function(bShow)
			return not (System.Codepku.Coursewares and (System.Codepku.Coursewares.category == 1 or System.Codepku.Coursewares.category == 2 or System.Codepku.Coursewares.category == 7) or System.Codepku.isHome);
		end
	);
	GameLogic.GetFilters():add_filter(
		"CodeBlockUIUrl",
		function (defaultUrl) 
			local subjectId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.course_subject_id;
			if (subjectId and tonumber(subjectId) == 10) then
				-- return defaultUrl;
				return "Mod/CodePku/cellar/CodeBlock/CodeBlockWindow.html";
			else
				return defaultUrl;
			end
		end
	)
	GameLogic.GetFilters():add_filter(
		"CodeBlockEditorOpened",
		function (CodeBlockWindow, entity) 
			local subjectId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.course_subject_id;
			if (subjectId and tonumber(subjectId) == 10) then
				-- CodeBlockWindow.OpenBlocklyEditor();		
			end
		end
	)

	GameLogic.GetFilters():add_filter(
		"CustomCodeBlockClicked",
		function (default, entityCode, mouse_button, entity)
			local subjectId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.course_subject_id;
			if (subjectId and tonumber(subjectId) == 10 and mouse_button == "right") then
				entityCode:OpenEditor("entity", entity);	
				return true;
			end

			return default;	
		end
	)

	GameLogic.GetFilters():add_filter(
		"KeyPressEvent",
		function(callbackVal, event)
			local isEmployee = System.User and System.User.info and System.User.info.is_employee;
			if isEmployee and tonumber(isEmployee) == 1 then
				return true;
			end

			if event.keyname == "DIK_F5" then
				event:accept();
			elseif event.keyname == "DIK_B" then
				if not (System.Codepku.Coursewares and (System.Codepku.Coursewares.category == 1 or System.Codepku.Coursewares.category == 2)) then
					event:accept();
				end
			elseif event.keyname == "DIK_E" then
				if not (System.Codepku.Coursewares and (System.Codepku.Coursewares.category == 1 or System.Codepku.Coursewares.category == 2)) then
					event:accept();
				end
			elseif event.keyname == "DIK_F1" then
				event:accept();
			elseif event.keyname == "DIK_F4" then
				event:accept();
			elseif event.keyname == "DIK_F5" then
				event:accept();
			elseif event.keyname == "DIK_F9" then
				event:accept();
			elseif event.keyname == "DIK_F11" then
				event:accept();
			elseif event.keyname == "DIK_F12" then
				event:accept();
			elseif event.keyname == "DIK_DELETE" or event.keyname == "DIK_BACKSPACE" or event.keyname == "DIK_DECIMAL" then
				event:accept();
			elseif event.keyname == "DIK_F12" then
				event:accept();
			elseif event.keyname == 'DIK_RETURN' then
				event:accept();
			end

			return true;
		end
	)

	GameLogic.GetFilters():add_filter(
		"KeepworkPermission",
		function (defaultBool,name,bOpenUIIfNot, callback)
			if type(callback) == "function" then
                callback(true)
            end
			return true;
		end
	)
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

function CodePku:BasicConfig()
	local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
	request:get('/config/basic',{}):next(function(response)		
		CodePku.BasicConfig = response.data.data; 		
    end):catch(function(e)
        
    end);
end

