NPL.load("./MainSceneUIButtons.lua");
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");

local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");

local MainUIButtons = NPL.export();

function MainUIButtons.show_common_ui()
	local width = 410
	local height = 110

    System.App.Commands.Call("File.MCMLWindowFrame", {
		url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_common.html"), 
		name = "MainUIButtons_common", 
		isShowTitleBar = false,
		DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
		style = CommonCtrl.WindowFrame.ContainerStyle,
		zorder = 10,
        allowDrag = false,
        click_through = false,
		directPosition = true,
			align = "_lt",
			x = 0,
			y = 0,
			width = width,
			height = height,
	});
end


function MainUIButtons.show_function_ui()
	local width = 720
	local height = 100


    System.App.Commands.Call("File.MCMLWindowFrame", {
		url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_function.html"), 
		name = "MainUIButtons_function", 
		isShowTitleBar = false,
		DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
		style = CommonCtrl.WindowFrame.ContainerStyle,
		zorder = 10,
        allowDrag = false,
        click_through = true,
		directPosition = true,
			align = "_rb",
			x = -width,
			y = -height,
			width = width,
			height = height,
	});
end


function MainUIButtons.show_dialog_ui(bshow)
	MainSceneUIButtons.show_dialog_ui(bshow)
end


function MainUIButtons.ShowPage()
	echo("---------------------")
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
			ParaUI.SetMinimumScreenSize(1920,1080,true);
		end
	end
end


distance = 10
length_limit = 7

function MainUIButtons.show_interact_ui(obj)
	-- local x, y, z = obj:GetPosition()
	-- local px, py, pz = EntityManager.GetPlayer():GetPosition()
	-- if(math.abs(x-px) > distance or math.abs(y-py) > distance or math.abs(z-pz) > distance) then
	-- 	GameLogic.AddBBS("CodeGlobals", L"距离玩家过远，走进点再尝试。", 3000, "#ff0000");
	-- 	return
	-- end

	-- local pname = obj:GetDisplayName()

	-- pname = string.sub(pname,1,length_limit)

	-- info = obj:GetPlayerInfo()

	-- -- pid = info["UserId"]
	-- -- echo("click other player:"..pid)

	-- System.App.Commands.Call("File.MCMLWindowFrame", {
	-- 	url = format("Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_interact.html?pname=%s&pid=%s", pname, pid), 
	-- 	name = "MainUIButtons_interact", 
	-- 	isShowTitleBar = false,
	-- 	DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
	-- 	style = CommonCtrl.WindowFrame.ContainerStyle,
	-- 	zorder = 10,
    --     allowDrag = false,
	-- 	click_through = false,
	-- 	directPosition = true,
	-- 		align = "_lt",
	-- 		x = 0,
	-- 		y = 0,
	-- 		width = 1920,
	-- 		height = 1080,
	-- });

	-- ParaUI.SetMinimumScreenSize(1920,1080,true);
end