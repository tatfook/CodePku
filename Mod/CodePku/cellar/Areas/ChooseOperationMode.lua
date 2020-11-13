--[[
Title: 切换操作方式
Author: NieXX
Date: 2020/11/12
-----------------------------------------------

local ChooseOperationMode = NPL.load("(gl)Mod/CodePku/cellar/Areas/ChooseOperationMode.lua");
ChooseOperationMode:ShowPage();

NPL.load("(gl)Mod/CodePku/cellar/Areas/ChooseOperationMode.lua")
local ChooseOperationMode = commonlib.gettable("Mod.CodePku.cellar.Areas.ChooseOperationMode")
-----------------------------------------------
]]
local ChooseOperationMode = commonlib.gettable("Mod.CodePku.cellar.Areas.ChooseOperationMode")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local TouchMiniKeyboard = GameLogic.GetFilters():apply_filters("TouchMiniKeyboard");

ChooseOperationMode.isShow = GameLogic.GetPlayerController():LoadLocalData('isDirectionKeyboard',false,true);

--[[
    @param type 0-方向轮盘 1-方向键盘
]]
function ChooseOperationMode:ChangeOperationMode(type)
    if type == 0 then
        ChooseOperationMode.isShow = false
    elseif type == 1 then
        ChooseOperationMode.isShow = true
    end
    if ChooseOperationMode.page then
        ChooseOperationMode.page:CloseWindow()
    end
    ChooseOperationMode:ShowPage()
end

function ChooseOperationMode:Confirm()
    if ChooseOperationMode.page then
        ChooseOperationMode.page:CloseWindow()
    end
    GameLogic.GetPlayerController():SaveLocalData('isDirectionKeyboard',ChooseOperationMode.isShow,true)
    if TouchMiniKeyboard then
        TouchMiniKeyboard.CheckShow(true)
    end
end

function ChooseOperationMode:ShowPage()
    if ChooseOperationMode.page then
        ChooseOperationMode.page:CloseWindow()
		ChooseOperationMode.page = nil
	end
    local params = {
        url="Mod/CodePku/cellar/Areas/ChooseOperationMode.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 1001,
    };
    ChooseOperationMode.page = AdaptWindow:QuickWindow(params)
end