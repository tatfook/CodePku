NPL.load("./MainSceneUIButtons.lua");
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

NPL.load("(gl)script/apps/Aries/Creator/Game/GUI/TouchController.lua");
local TouchController = commonlib.gettable("MyCompany.Aries.Game.GUI.TouchController");

local MainUIButtons = NPL.export();

MainUIButtons.hasshown = false

MainUIButtons.common_window = nil
MainUIButtons.function_window = nil
MainUIButtons.dialog_window = nil
MainUIButtons.money_window = nil
MainUIButtons.action_window = nil
MainUIButtons.open_function = nil
MainUIButtons.open_common = nil
MainUIButtons.task_window = nil


function MainUIButtons.show_common_ui(flag)
	local open_width = 906
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

	local params = {
		open = {
			url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_function.html", 
			alignment="_rb", zorder=11, left = -541, top = -178, width = 541, height = 178,
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

function MainUIButtons.show_action_ui(left, right, bottom)

	if left ~= nil then
		MainUIButtons.show_action_left()
	end

	if right ~= nil then
		MainUIButtons.show_action_right()
	end

	if bottom ~= nil then
		MainUIButtons.show_action_bottom()
	end
	
end

function MainUIButtons.show_action_left()
	params = { url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainAction/MainActionLeft.html", 
			alignment="_lt", left = 101, top = 534, width = 350, height = 350
		}
		MainUIButtons.action_window_left = AdaptWindow:QuickWindow(params)
end

function MainUIButtons.show_action_right()
	params = { url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainAction/MainActionRight.html", 
			alignment="_lt", left = 1758, top = 471, width = 130, height = 300
		}
		MainUIButtons.action_window_right = AdaptWindow:QuickWindow(params)
end

function MainUIButtons.show_action_bottom()
	params = { url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainAction/MainActionBottom.html", 
			alignment="_lt", zorder = 10, left = 1510, top = 755, width = 300, height = 305
		}
		MainUIButtons.action_window_bottom = AdaptWindow:QuickWindow(params)
end

function MainUIButtons.show_task_ui()
	params = { url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_task.html", 
			alignment="_lt", zorder = 10, left = 1820, top = 300, width = 100, height = 100
		}
		MainUIButtons.task_window = AdaptWindow:QuickWindow(params)
end

function MainUIButtons.JudgeNil()
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
	if MainUIButtons.action_window_left ~= nil then
		MainUIButtons.action_window_left:CloseWindow()
		MainUIButtons.action_window_left = nil
	end
	if MainUIButtons.action_window_right ~= nil then
		MainUIButtons.action_window_right:CloseWindow()
		MainUIButtons.action_window_right = nil
	end
	if MainUIButtons.action_window_bottom ~= nil then
		MainUIButtons.action_window_bottom:CloseWindow()
		MainUIButtons.action_window_bottom = nil
	end	
	if MainUIButtons.task_window ~= nil then
		MainUIButtons.task_window:CloseWindow()
		MainUIButtons.task_window = nil
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
			MainUIButtons.show_common_ui()
			MainUIButtons.show_dialog_ui(false)
			MainUIButtons.show_money_ui()		
			MainUIButtons.show_function_ui()
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