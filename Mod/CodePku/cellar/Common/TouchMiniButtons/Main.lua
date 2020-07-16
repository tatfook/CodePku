NPL.load("./MainSceneUIButtons.lua");
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

local MainUIButtons = NPL.export();

function MainUIButtons.show_common_ui()
	local width = 410
	local height = 110

	params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_common.html", 
		alignment="_lt", left = 0, top = 0, width = width, height = height,
	}
	local window = AdaptWindow:QuickWindow(params)
end


function MainUIButtons.show_function_ui()
	local width = 720
	local height = 100

	params = {
		url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_function.html", 
		alignment="_rb", left = -width, top = -height, width = width, height = height,
		click_through = true,
	}
	local window = AdaptWindow:QuickWindow(params)
end


function MainUIButtons.show_dialog_ui(bshow)
	MainSceneUIButtons.show_dialog_ui(bshow)
end


function MainUIButtons.ShowPage()
	if System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.category then 
		local wid = System.Codepku.Coursewares.category

		local worldtable = {3}

		local show = false
		for _, v in ipairs(worldtable) do
			if(v == wid) then
				show = true
			end
		end
		if(show)then
			-- for temp test, view the effect of mobile phone
			-- local TouchMiniKeyboard = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/Main.lua");
			-- TouchMiniKeyboard.CheckShow(true)
			MainUIButtons.show_common_ui()
			MainUIButtons.show_function_ui()
			MainUIButtons.show_dialog_ui(false)

			-- ParaUI.SetMinimumScreenSize(1920,1080,true);
		end
	end
end


distance = 10
length_limit = 7

function MainUIButtons.show_interact_ui(obj)
	local x, y, z = obj:GetPosition()
	local px, py, pz = EntityManager.GetPlayer():GetPosition()
	if(math.abs(x-px) > distance or math.abs(y-py) > distance or math.abs(z-pz) > distance) then
		GameLogic.AddBBS("CodeGlobals", L"距离玩家过远，走进点再尝试。", 3000, "#ff0000");
		return
	end

	local pname = obj:GetDisplayName()

	pname = string.sub(pname,1,length_limit)

	info = obj:GetPlayerInfo()
	pid = info.userinfo.id
	
	width = 1920
	height = 1080

	params = {
		format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_interact.html?pname=%s&pid=%s", pname, pid),
		alignment="_lt", left = 0, top = 0, width = width, height = height,
		click_through = false,
	}
	local window = AdaptWindow:QuickWindow(params)

end