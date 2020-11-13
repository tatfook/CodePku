NPL.load("./MainSceneUIButtons.lua");
NPL.load("(gl)script/ide/timer.lua");
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeManage.lua")
NPL.load("(gl)script/ide/System/Windows/Screen.lua")
local HomeManage = commonlib.gettable("Mod.CodePku.Common.HomeManage")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");
local Screen = commonlib.gettable("System.Windows.Screen")
NPL.load("(gl)script/apps/Aries/Creator/Game/GUI/TouchController.lua");
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")

-- CommonFunc = NPL.load("(gl)Mod/CodePku/cellar/Common/CommonFunc/CommonFunc.lua")
CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")

local TouchController = commonlib.gettable("MyCompany.Aries.Game.GUI.TouchController");
-- MainUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons")
local MainUIButtons = NPL.export();

MainUIButtons.flag = true
MainUIButtons.hasshown = false
MainUIButtons.is_dialog_open = true
MainUIButtons.main_close_window_height = 80

MainUIButtons.common_window = nil
MainUIButtons.function_window = nil
MainUIButtons.dialog_window = nil
MainUIButtons.money_window = nil
MainUIButtons.open_function = nil
MainUIButtons.open_common = nil
MainUIButtons.account_up = nil
MainUIButtons.user_asset = nil
MainUIButtons.home_window = nil
MainUIButtons.showData = {}
MainUIButtons.lt_avatar = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_avatar_1.png"),top=30,width=88,height=116,name="main_icon_Avatar_1",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_avatar_2.png"),top=30,width=88,height=116,name="main_icon_Avatar_2",bShow=true,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_avatar_3.png"),top=14,width=108,height=134,name="main_icon_Avatar_3",bShow=true,},
	[4]={url=mainFrameImageData:GetIconUrl("main_icon_avatar_4.png"),top=11,width=101,height=135,name="main_icon_Avatar_4",bShow=true,},
}

MainUIButtons.left_buttons = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_signin.png"),top=0,width=115,height=107,left=26,name="ClickSignin",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_task.png"),top=19,width=116,height=113,left=25,name="ClickTask",bShow=true,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_calendar.png"),top=19,width=113,height=112,left=27,name="ClickShareApp",bShow=true,},
}

MainUIButtons.top_buttons = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_parent.png"),top=30,width=122,height=104,left=0,name="ClickEldership",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_map.png"),top=27,width=104,height=107,left=22,name="ClickSamllMap",bShow=true,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_detach.png"),top=36,width=122,height=98,left=22,name="ClickAntiJamming",bShow=true,},
	[4]={url=mainFrameImageData:GetIconUrl("main_icon_upgrade.png"),top=33,width=122,height=102,left=23,name="ClickUpBtn",bShow=false,},
	[5]={url=mainFrameImageData:GetIconUrl("main_icon_switch.png"),top=32,width=122,height=102,left=23,name="ClickChangeBranch",bShow=false,},
}

MainUIButtons.middle_buttons = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_raiders_1.png"),top=22,width=103,height=134,name="ClickUserInfo",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_home.png"),top=20,width=93,height=134,name="ClickFriend",bShow=true,},
}

MainUIButtons.dialog_top = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_feedback.png"),top=4,width=74,height=100,left=0,name="ClickFeedback",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_notice.png"),top=8,width=74,height=95,left=47,name="ClickNotice",bShow=false,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_ranking.png"),top=7,width=73,height=96,left=47,name="ClickRank",bShow=true,},
	[4]={url=mainFrameImageData:GetIconUrl("main_icon_qq.png"),top=2,width=94,height=103,left=39,name="ClickQQGroup",bShow=true,},
	[5]={url=mainFrameImageData:GetIconUrl("main_icon_community.png"),top=5,width=97,height=98,left=40,name="ClickCommunity",bShow=true,},
	[6]={url=mainFrameImageData:GetIconUrl("main_icon_mailbox.png"),top=9,width=86,height=94,left=40,name="ClickEmail",bShow=false,},
	[7]={url=mainFrameImageData:GetIconUrl("main_icon_shareit.png"),top=8,width=87,height=95,left=41,name="ClickShareApp",bShow=false,},
}

MainUIButtons.dialog_right = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_information.png"),top=0,width=81,height=99,left=15,name="ClickUserInfo",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_backpack.png"),top=20,width=90,height=99,left=6,name="ClickBag",bShow=false,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_achievement.png"),top=19,width=83,height=89,left=11,name="ClickAchievement",bShow=false,},
	[4]={url=mainFrameImageData:GetIconUrl("main_icon_title.png"),top=19,width=68,height=109,left=18,name="ClickTitle",bShow=false,},
	[5]={url=mainFrameImageData:GetIconUrl("main_icon_buddy.png"),top=19,width=75,height=98,left=15,name="ClickFriend",bShow=true,},
	[6]={url=mainFrameImageData:GetIconUrl("main_icon_setup.png"),top=18,width=78,height=91,left=22,name="ClickSetting",bShow=true,},
	[7]={url=mainFrameImageData:GetIconUrl("main_icon_dressup.png"),top=20,width=85,height=86,left=14,name="ClickChange",bShow=false,},
	[8]={url="",top=20,width=85,height=86,left=14,name="ClickSchoolyard",bShow=true,},
}

MainUIButtons.main_open_pc = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_3.png"),top=9,width=122,height=109,left=22,name="ClickSamllMap",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_2.png"),top=11,width=164,height=107,left=41,name="ClickAntiJamming",bShow=true,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_1.png"),top=6,width=100,height=111,left=53,name="ClickFeedback",bShow=true,},
}

MainUIButtons.main_open_mobile = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_3_p.png"),top=20,width=157,height=147,left=53,name="ClickSamllMap",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_2_p.png"),top=20,width=213,height=145,left=36,name="ClickAntiJamming",bShow=true,},
	[3]={url=mainFrameImageData:GetIconUrl("main_icon_1_p.png"),top=20,width=129,height=151,left=36,name="ClickFeedback",bShow=true,},
}

MainUIButtons.activity = {
	[1]={url=mainFrameImageData:GetIconUrl("main_icon_raiders_1.png"),top=0,width=129,height=152,left=3,name="ClickActivity1",bShow=true,},
	[2]={url=mainFrameImageData:GetIconUrl("main_icon_home.png"),top=7,width=147,height=162,left=1,name="ClickActivity2",bShow=true,},
}

-- MainUIButtons.isIOSApproval = CommonFunc.isIOSApproval()

--[[
	@desc get width of button group
	@param array: array of buttons
	@param space: the spacing of buttons
	@param flag: 0-horizontal/1-vertical
]]
function MainUIButtons:getWidth(array, flag)
	local width = 0;
	for key,value in ipairs(array) do
		if flag == 0 then
			if value["bShow"] then
				width = width + value["left"] + value["width"];
			end
		elseif flag == 1 then
			if value["bShow"] then
				width = width + value["top"] + value["height"];
			end
		end
	end
	return width;
end

function MainUIButtons:ClickOpenDialog()
	-- 点击布
	MainUIButtons:show_dialog(true)
end

function MainUIButtons:ClickCloseDialog()
	-- 点击锤头
	MainUIButtons:show_dialog(false)
end

-- 限时活动页
function MainUIButtons:show_activity_ui()
	local open_height = MainUIButtons:getWidth(MainUIButtons.activity, 1)
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_activity.html", 
		alignment="_lt", left = 230, top = 205, width = 200, height = 176, click_through = true,
	}
	MainUIButtons.main_open_window = AdaptWindow:QuickWindow(params)
end

-- 竞技区，教学区顶部导航-开启
function MainUIButtons:show_main_open_ui()
	if MainUIButtons.main_open_window then
		MainUIButtons.main_open_window:CloseWindow()
		MainUIButtons.main_open_window = nil
	end
	local open_heght = 250
	local open_width = 688
	if System.os.IsMobilePlatform() then
		MainUIButtons.main_open = MainUIButtons.main_open_mobile
	else
		open_heght = 176
		open_width = 530
		MainUIButtons.main_open = MainUIButtons.main_open_pc
	end
	local open_left = 1920*0.5 - open_width*0.5
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_main_open.html", 
		alignment="_lt", left = open_left, top = 0, width = open_width, height = open_heght, click_through = true,
	}
	MainUIButtons.main_open_window = AdaptWindow:QuickWindow(params)
	MainUIButtons.CloseNav()
end

-- 竞技区，教学区顶部导航-关闭
function MainUIButtons:show_main_close_ui()
	if MainUIButtons.main_close_window then
		MainUIButtons.main_close_window:CloseWindow()
		MainUIButtons.main_close_window = nil
	end
	local open_heght = 0
	local open_width = 0
	local open_left = 0
	if System.os.IsMobilePlatform() then
		open_heght = 49
		open_heght = MainUIButtons.main_close_window_height
		open_width = 340
		open_left = 790
	else
		-- open_heght = 36
		open_heght = MainUIButtons.main_close_window_height
		open_width = 264
		open_left = 828
	end
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_main_close.html", 
		alignment="_lt", left = open_left, top = 0, width = open_width, height = open_heght, click_through = true,
	}
	MainUIButtons.main_close_window = AdaptWindow:QuickWindow(params)
end

-- 头像，等级N
function MainUIButtons:show_avatar_ui()
	if MainUIButtons.avatar_window then
		MainUIButtons.avatar_window:CloseWindow()
		MainUIButtons.avatar_window = nil
	end
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_avatar.html", 
		alignment="_lt", left = 0, top = 0, width = 200, height = 220, click_through = true,
	}
	MainUIButtons.avatar_window = AdaptWindow:QuickWindow(params)
end

--[[
	@param flag true打开目录/false关闭目录
]]
function MainUIButtons:show_dialog(flag)
	if flag then
		MainUIButtons.is_dialog_open = true
		if MainUIButtons.dialog_close_window ~= nil then
			MainUIButtons.dialog_close_window:CloseWindow()
			MainUIButtons.dialog_close_window = nil
		end
		MainUIButtons:show_dialog_open_ui()
		MainUIButtons:show_dialog_top_ui()
		MainUIButtons:show_dialog_right_ui()
	else
		MainUIButtons.is_dialog_open = false
		if MainUIButtons.dialog_top_window ~= nil then
			MainUIButtons.dialog_top_window:CloseWindow()
			MainUIButtons.dialog_top_window = nil
		end
		if MainUIButtons.dialog_right_window ~= nil then
			MainUIButtons.dialog_right_window:CloseWindow()
			MainUIButtons.dialog_right_window = nil
		end
		if MainUIButtons.dialog_open_window ~= nil then
			MainUIButtons.dialog_open_window:CloseWindow()
			MainUIButtons.dialog_open_window = nil
		end
		MainUIButtons:show_dialog_close_ui()
	end
end

-- 锤头
function MainUIButtons:show_dialog_open_ui()
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_open.html", 
		alignment="_lt", left = 1807, top = 153, width = 80, height = 80, click_through = true,
	}
	MainUIButtons.dialog_open_window = AdaptWindow:QuickWindow(params)
end

-- 布
function MainUIButtons:show_dialog_close_ui()
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_close.html", 
		alignment="_lt", left = 1807, top = 153, width = 80, height = 80, click_through = true,
	}
	MainUIButtons.dialog_close_window = AdaptWindow:QuickWindow(params)
end

-- 右上横向目录
function MainUIButtons:show_dialog_top_ui()
	local open_width = MainUIButtons:getWidth(MainUIButtons.dialog_top, 0)
	local open_left = 1920 - open_width - 113 - 20
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_top.html", 
		alignment="_lt", left = open_left, top = 140, width = open_width, height = 110, click_through = true,
	}
	MainUIButtons.dialog_top_window = AdaptWindow:QuickWindow(params)
end

-- 右侧垂直目录
function MainUIButtons:show_dialog_right_ui()
	local open_height = MainUIButtons:getWidth(MainUIButtons.dialog_right, 1)
	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_right.html", 
		alignment="_lt", left = 1790, top = 267, width = 100, height = open_height, click_through = true,
	}
	MainUIButtons.dialog_right_window = AdaptWindow:QuickWindow(params)
end

-- 左上横向目录
function MainUIButtons:show_common_ui()
	if MainUIButtons.common_window then
		MainUIButtons.common_window:CloseWindow()
		MainUIButtons.common_window = nil
	end

	local isVisitor = commonlib.getfield("System.User.isVisitor")
	if isVisitor then
		MainUIButtons.top_buttons[4]["bShow"] = true
	else
		MainUIButtons.top_buttons[4]["bShow"] = false
	end
	local open_width = MainUIButtons:getWidth(MainUIButtons.top_buttons, 0)
	local open_height = 110

	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_common.html", 
		alignment="_lt", left = 238, top = 0, width = open_width, height = open_height, click_through = true,
	}
	MainUIButtons.common_window = AdaptWindow:QuickWindow(params)
end

-- 左侧垂直目录
function MainUIButtons:show_common_left_ui()
	if MainUIButtons.common_left_window then
		MainUIButtons.common_left_window:CloseWindow()
		MainUIButtons.common_left_window = nil
	end

	local open_height = MainUIButtons:getWidth(MainUIButtons.left_buttons, 1)
	local open_width = 120

	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_common_left.html", 
		alignment="_lt", left = 0, top = 283, width = open_width, height = open_height, click_through = true,
	}
	MainUIButtons.common_left_window = AdaptWindow:QuickWindow(params)
end

MainUIButtons.money = {goldcoin=0, wanxuecoin=0};

function MainUIButtons.show_money_ui()
	local width = 546
	local height = 89

	local info = Mod.CodePku.Store:Get('user/info');
	local wallets = info.user_wallets or {};
	for _, v in ipairs(wallets) do
		if v.currency_id == 1 then
			MainUIButtons.money.goldcoin = v.amount;
		elseif v.currency_id == 2 then
			MainUIButtons.money.wanxuecoin = v.amount;
		end
	end

	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainMoney.html", 
		alignment="_lt", left = 1323, top = 0, width = width, height = height,
	}
	
	if MainUIButtons.isHuaweiApproval then
		return
	else 
		MainUIButtons.money_window = AdaptWindow:QuickWindow(params)	
	end
end

function MainUIButtons.show_home_window_ui()
	local params = {
		url = "Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_home_window.html",
		alignment = "_lt", left = 1592, top = 250, width = 150, height = 355,
	}

	local isHome = HomeManage:IsMyHome()
	
	if isHome then
		MainUIButtons.home_window = AdaptWindow:QuickWindow(params)
	end
end

-- 关闭所有按钮
function MainUIButtons.JudgeNil()
	if MainUIButtons.main_open_window ~= nil then
		MainUIButtons.main_open_window:CloseWindow()
		MainUIButtons.main_open_window = nil
	end
	if MainUIButtons.main_close_window ~= nil then
		MainUIButtons.main_close_window:CloseWindow()
		MainUIButtons.main_close_window = nil
	end
	if MainUIButtons.avatar_window ~= nil then
		MainUIButtons.flag = true
		MainUIButtons.avatar_window:CloseWindow()
		MainUIButtons.avatar_window = nil
	end
	if MainUIButtons.dialog_open_window ~= nil then
		MainUIButtons.dialog_open_window:CloseWindow()
		MainUIButtons.dialog_open_window = nil
	end
	if MainUIButtons.dialog_close_window ~= nil then
		MainUIButtons.dialog_close_window:CloseWindow()
		MainUIButtons.dialog_close_window = nil
	end
	if MainUIButtons.dialog_top_window ~= nil then
		MainUIButtons.dialog_top_window:CloseWindow()
		MainUIButtons.dialog_top_window = nil
	end
	if MainUIButtons.dialog_right_window ~= nil then
		MainUIButtons.dialog_right_window:CloseWindow()
		MainUIButtons.dialog_right_window = nil
	end
	if MainUIButtons.common_window ~= nil then
		MainUIButtons.common_window:CloseWindow()
		MainUIButtons.common_window = nil
	end
	if MainUIButtons.common_left_window ~= nil then
		MainUIButtons.common_left_window:CloseWindow()
		MainUIButtons.common_left_window = nil
	end
	if MainUIButtons.money_window ~= nil then
		MainUIButtons.money_window:CloseWindow()
		MainUIButtons.money_window = nil
	end
	if MainUIButtons.home_window ~= nil then
		MainUIButtons.home_window:CloseWindow()
		MainUIButtons.home_window = nil
	end
end


function MainUIButtons.ShowPage()
	MainUIButtons.JudgeNil()

	local hideMenu = false;
	local hideAllMenu = false;
	if (System.Codepku and System.Codepku.Coursewares) then		
		hideMenu = System.Codepku.Coursewares.hide_menu;
		hideAllMenu = System.Codepku.Coursewares.hide_all_menu;
	end

	if not hideAllMenu then
		if not hideMenu then 
			-- MainUIButtons:show_activity_ui() -- 限时活动
			MainUIButtons:show_common_ui()
			MainUIButtons:show_money_ui()		
			MainUIButtons:show_home_window_ui()

			MainUIButtons:show_common_left_ui()
			MainUIButtons:show_avatar_ui()
			MainUIButtons:show_dialog(true)		
		else
			-- 竞技，教学区按钮
			MainUIButtons:show_main_open_ui()
			-- MainUIButtons.CloseNav()
		end
	end
	--进入家园区初始化时隐藏目录
	if HomeManage:IsMyHome() then
		if GameLogic.GameMode:IsEditor() then
			MainUIButtons.JudgeNil()
			MainUIButtons:show_home_window_ui()
			MainUIButtons:show_main_open_ui()
		else 
			if MainUIButtons.mytimer then
				MainUIButtons.mytimer:Change()
			end
			MainUIButtons:show_dialog(false)
		end
	end
end

function MainUIButtons.CloseNav()
	if MainUIButtons.mytimer then
		MainUIButtons.mytimer:Change()
	end
	MainUIButtons.mytimer = commonlib.Timer:new(
		{
			callbackFunc = function(timer)
				if MainUIButtons.main_open_window ~= nil then
					MainUIButtons.main_open_window:CloseWindow()
					MainUIButtons.main_open_window = nil
				end
				MainUIButtons:show_main_close_ui()
			end
		}
	);

	MainUIButtons.mytimer:Change(15000, nil)
end

local distance = 10
local length_limit = 7

function MainUIButtons.show_interact_ui(obj)
	local x, y, z = obj:GetPosition()
	local px, py, pz = EntityManager.GetPlayer():GetPosition()
	if(math.abs(x-px) > distance or math.abs(y-py) > distance or math.abs(z-pz) > distance) then
		GameLogic.AddBBS("CodeGlobals", L"距离玩家过远，走近点再尝试。", 3000, "#ff0000");
		return
	end
	-- asset
	MainUIButtons.user_asset = obj:GetMainAssetPath();
	
	local username =  obj:GetUserName()
	local displayname = obj:GetDisplayName()
	local pname = username or displayname
	pname = commonlib.utf8.sub(pname,1,length_limit)

	local info = obj:GetPlayerInfo()
	if not info or not info.userinfo then
		return
	end
	local pid = info.userinfo.id
	
	local width = 1920
	local height = 1080

	local params = {
		url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_interact.html?pname=%s&pid=%s", pname, pid),
		alignment="_lt", left = 0, top = 0, width = width, height = height,
		click_through = false,
	}
	local window = AdaptWindow:QuickWindow(params)

end