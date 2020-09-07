NPL.load("./MainSceneUIButtons.lua");
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

local MainUIButtons = NPL.export();

NPL.load("(gl)Mod/CodePku/cellar/GUI/UserInfo.lua");
MainUIButtons.hasshown = false

MainUIButtons.common_window = nil
MainUIButtons.function_window = nil
MainUIButtons.dialog_window = nil
MainUIButtons.money_window = nil
MainUIButtons.open_function = nil
MainUIButtons.open_common = nil
MainUIButtons.account_up = nil


MainUIButtons.lt_buttons = {
	[1]={url="codepku/image/textures/main_ui/main.png#41 175 105 120",top=30,width=88,height=116,name="ClickMainEntrence"},
	[2]={url="codepku/image/textures/main_ui/main.png#165 175 90 120",top=30,width=88,height=116,name="ClickAntiJamming"},
	[3]={url="codepku/image/textures/main_ui/main.png#38 314 108 134",top=14,width=108,height=134,name="ClickSamllMap"},
	[4]={url="codepku/image/textures/main_ui/main.png#160 313 101 135",top=11,width=101,height=135,name="ClickCommunity"},
	[5]={url="codepku/image/textures/main_ui/main.png#805 313 105 137",top=11,width=101,height=135,name="ClickFeedback"},
}

MainUIButtons.rb_buttons = {
	[1]={url="codepku/image/textures/main_ui/main.png#148 25 107 142",top=22,width=103,height=134,name="ClickUserInfo"},
	[2]={url="codepku/image/textures/main_ui/main.png#285 18 97 148",top=20,width=93,height=134,name="ClickFriend"},
	[3]={url="codepku/image/textures/main_ui/main.png#416 18 84 148",top=20,width=80,height=134,name="ClickRank"},
	[4]={url="codepku/image/textures/main_ui/main.png#416 18 84 148",top=20,width=100,height=134,name="ClickRank"},
	[5]={url="codepku/image/textures/main_ui/main.png#416 18 84 148",top=20,width=80,height=134,name="ClickRank"},
	[6]={url="codepku/image/textures/main_ui/main.png#416 18 84 148",top=20,width=80,height=134,name="ClickRank"},
	[7]={url="codepku/image/textures/main_ui/main.png#416 18 84 148",top=20,width=80,height=134,name="ClickRank"},
}

-- get width of button group of left top corner
function MainUIButtons.get_lt_width()
	local width = 45;
	for key,value in ipairs(MainUIButtons.lt_buttons) do
		width = width + 45 + value["width"];
	end
	return width;
end

-- get width of button group of right bottom corner
function MainUIButtons.get_rb_width()
	local width = 45+82;
	for key,value in ipairs(MainUIButtons.rb_buttons) do
		width = width + 45 + value["width"];
	end
	return width;
end

function MainUIButtons.show_common_ui(flag)
	local open_width = MainUIButtons.get_lt_width() + 82
	local open_height = 178
	local close_width = 82
	local close_height = 178

	local params = {
		open = {
			url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_common.html", 
			alignment="_lt", left = 0, top = 0, width = open_width, height = open_height, click_through = true,
		},
		close = {
			url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_common.html", 
			alignment="_lt", left = 0, top = 0, width = close_width, height = close_height, click_through = true,
		}
	}
	if("close" == flag)then
		MainUIButtons.open_common = false
	else
		MainUIButtons.open_common = true
	end
	if(flag ~= nil)then
		MainUIButtons.common_window = AdaptWindow:QuickWindow(params['close'])
	else
		MainUIButtons.common_window = AdaptWindow:QuickWindow(params["open"])
	end
	
end

function MainUIButtons.show_function_ui(flag)	--flag == true,工具栏展开
	local width = MainUIButtons.get_rb_width();
	local params = {
		open = {
			url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_function.html", 
			alignment="_rb", left = -width, top = -178, width = width, height = 178,
			click_through = true,
		},
		close = {
			url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_function.html", 
			alignment="_rb", left = -85, top = -178, width = 85, height = 178,
			click_through = true,
		}
	}

	if("close" == flag)then
		MainUIButtons.open_function = false
	else
		MainUIButtons.open_function = true
	end
	
	if(flag ~= nil)then
		MainUIButtons.function_window = AdaptWindow:QuickWindow(params[flag])
	else
		MainUIButtons.function_window = AdaptWindow:QuickWindow(params["open"])
	end
end

function MainUIButtons.show_dialog_ui(bshow)
	MainUIButtons.dialog_window = MainSceneUIButtons.show_dialog_ui(bshow, 0)
end

function MainUIButtons.show_money_ui()
	local width = 746
	local height = 89

	local params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainMoney.html", 
		alignment="_lt", left = 1309, top = 0, width = width, height = height,
	}
	MainUIButtons.money_window = AdaptWindow:QuickWindow(params)	
end

function MainUIButtons.show_account_up_ui()
	local params = {
		url = "Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_account_up.html",
		alignment = "_lt", left = 1027, top = -8, width = 264, height = 127,
	}

	local isVisitor = commonlib.getfield("System.User.isVisitor")

	if isVisitor then
		MainUIButtons.account_up = AdaptWindow:QuickWindow(params)
	end
end

function MainUIButtons.ShowPage()
	if MainUIButtons.common_window ~= nil then
		MainUIButtons.common_window:CloseWindow()
		MainUIButtons.common_window = nil
	end
	if MainUIButtons.function_window ~= nil then
		MainUIButtons.function_window:CloseWindow()
		MainUIButtons.function_window = nil
	end
	if MainUIButtons.dialog_window ~= nil then
		MainUIButtons.dialog_window:CloseWindow()
		MainUIButtons.dialog_window = nil
	end
	if MainUIButtons.money_window ~= nil then
		MainUIButtons.money_window:CloseWindow()
		MainUIButtons.money_window = nil
	end

	local hideMenu = false;
	local hideAllMenu = false;
	if (System.Codepku and System.Codepku.Coursewares) then		
		hideMenu = System.Codepku.Coursewares.hide_menu;
		hideAllMenu = System.Codepku.Coursewares.hide_all_menu;
	end
		
	if not hideAllMenu then
		if not hideMenu then 
			MainUIButtons.show_common_ui()
			MainUIButtons.show_dialog_ui(false)
			MainUIButtons.show_money_ui()		
			MainUIButtons.show_function_ui()
			-- MainUIButtons.show_account_up_ui()
		else
			MainUIButtons.show_common_ui()
		end
	end
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