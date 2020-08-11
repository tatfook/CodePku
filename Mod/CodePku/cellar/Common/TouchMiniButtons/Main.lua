NPL.load("./MainSceneUIButtons.lua");
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");
local GenAndName = commonlib.gettable("Mod.CodePku.GenAndName")
local UserInfo = commonlib.gettable("Mod.CodePku.UserInfo")


local MainUIButtons = NPL.export();

MainUIButtons.hasshown = false

MainUIButtons.common_window = nil
MainUIButtons.function_window = nil
MainUIButtons.dialog_window = nil
MainUIButtons.money_window = nil
MainUIButtons.open_function = nil
MainUIButtons.open_common = nil


function MainUIButtons.show_common_ui(flag)
	local open_width = 664
	local open_height = 178
	local close_width = 82
	local close_height = 178

	params = {
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
	MainUIButtons.common_window = AdaptWindow:QuickWindow(params[flag])
end

function MainUIButtons.show_function_ui(flag)	--flag == true,工具栏展开

	params = {
		open = {
			url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_function.html", 
			alignment="_rb", left = -541, top = -178, width = 541, height = 178,
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
	local width = 611
	local height = 89

	params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainMoney.html", 
		alignment="_lt", left = 1309, top = 0, width = width, height = height,
	}
	MainUIButtons.money_window = AdaptWindow:QuickWindow(params)
end

function MainUIButtons.ShowPage()
	local show = false
	if System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.category then 
		local wid = System.Codepku.Coursewares.category

		local worldtable = {3}

		for _, v in ipairs(worldtable) do
			if(v == wid) then
				show = true
			end
		end
	end

	MainUIButtons.show_common_ui("open")
	MainUIButtons.show_dialog_ui(false)
	MainUIButtons.show_money_ui()
	if(show)then
		if(not MainUIButtons.hasshown) then			
			MainUIButtons.show_function_ui()					
			MainUIButtons.hasshown = true
			-- GenAndName:ShowPage()
		end
	else
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
		MainUIButtons.hasshown = false
	end
end


distance = 10
length_limit = 7

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

	info = obj:GetPlayerInfo()
	if not info or not info.userinfo then
		return
	end
	pid = info.userinfo.id
	
	width = 1920
	height = 1080

	params = {
		url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_interact.html?pname=%s&pid=%s", pname, pid),
		alignment="_lt", left = 0, top = 0, width = width, height = height,
		click_through = false,
	}
	local window = AdaptWindow:QuickWindow(params)

end