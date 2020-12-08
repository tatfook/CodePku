--[[
Author:zouren
Date: 2020-12-05 11:07:23
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/FeatKeyboard.lua")
local FeatKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard")
FeatKeyboard:show()
-----------------------------------
]]--
NPL.load("(gl)script/ide/System/Windows/Screen.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchSession.lua")
NPL.load("(gl)script/ide/System/Windows/Keyboard.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Entity/EntityManager.lua");
NPL.load("(gl)script/apps/Aries/Creator/Game/GameRules/GameMode.lua")
NPL.load("(gl)script/ide/System/Windows/Mouse.lua")
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchFuncKeyboard.lua")
local Mouse = commonlib.gettable("System.Windows.Mouse")
local GameMode = commonlib.gettable("MyCompany.Aries.Game.GameLogic.GameMode")
local Keyboard = commonlib.gettable("System.Windows.Keyboard")
local TouchSession = commonlib.gettable("MyCompany.Aries.Game.Common.TouchSession")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local Screen = commonlib.gettable("System.Windows.Screen")
local TouchFuncKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchFuncKeyboard")

local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua")
local Table = NPL.load("(gl)Mod/CodePku/util/Table.lua")
local Design = NPL.load("(gl)Mod/CodePku/util/Design.lua")
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")

local FeatKeyboard = commonlib.inherit(
        commonlib.gettable("System.Core.ToolBase"),
        commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard")
)

FeatKeyboard.align = "_lt"
FeatKeyboard.zorder = -10
FeatKeyboard.colors = { normal = "#ffffff", pressed = "#888888" }
FeatKeyboard.isClickFly = false

function FeatKeyboard:ctor()
    self.btnList = {
        ["jumpFeatBtn"] = {
            name = "jumpFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_tiao.png"),
            clickedBackground = nil,
            left = 1594, top = 845, width = 212, height = 212, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_SPACE, 
            },
            type = 2, -- 1按住维持状态的按键  2点击效果按键  3特殊效果按键
        },
        ["flyFeatBtn"] = {
            name = "flyFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_flying.png"),
            clickedBackground = mainFrameImageData:GetIconUrl("main_icon_fly02.png"),
            left = 1803, top = 566, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_F, 
            },
            downFunc = nil,
            type = 3,
            downFunc = FeatKeyboard.flyBtnDown,
        },
        ["funcFeatBtn"] = {
            name = "funcFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_more.png"),
            clickedBackground = nil,
            left = 1803, top = 456, width = 94, height = 94, alignment = "_lt",
            key = {},
            type = 3,
            downFunc = FeatKeyboard.funcBtnDown,
            upFunc = FeatKeyboard.funcBtnUp,
        },
        ["ctrlFeatBtn"] = {
            name = "ctrlFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_ctrl.png"),
            clickedBackground = nil,
            left = 1450, top = 746, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LCONTROL, 
            },
            type = 1,
        },
        ["shitfFeatBtn"] = {
            name = "shitfFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_shift_s.png"),
            clickedBackground = nil,
            left = 1555, top = 670, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LSHIFT, 
            },
            type = 3,
            downFunc = FeatKeyboard.shitfBtnDown,
            upFunc = FeatKeyboard.shitfBtnUp,
        },
        ["altFeatBtn"] = {
            name = "altFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_alt.png"),
            clickedBackground = nil,
            left = 1399, top = 864, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LMENU, 
            },
            type = 1,
        },
        ["upFeatBtn"] = {
            name = "upFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_fly_up.png"),
            clickedBackground = nil,
            left = 1596, top = 845, width = 202, height = 107, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_SPACE, 
            },
            type = 2,
        },
        ["downFeatBtn"] = {
            name = "downFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_fly_down.png"),
            clickedBackground = nil,
            left = 1596, top = 954, width = 202, height = 103, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_X, 
            },
            type = 2,
        },
    }
end

function FeatKeyboard:generalUI()
    for k,v in pairs(self.btnList) do 
        self:getUIControl(v)
    end
end

function FeatKeyboard:getUIControl(item)
	local _parent = ParaUI.GetUIObject(item.uiControlId or item.name.."UIControl")
	local left = Design:adapterWidth(item.left)
    local top = Design:adapterHeight(item.top)
    local width = Design:adapterWidth(item.width)
    local height = Design:adapterWidth(item.height) --维持宽高一致  adapterWidth
	if(not _parent:IsValid()) then
		_parent = ParaUI.CreateUIObject("container", item.name.."UIControl", item.alignment, left, top, width, height)
		_parent.background = item.background
		_guihelper.SetUIColor(_parent, self.colors.normal)
		_parent:AttachToRoot()
		_parent.zorder = self.zorder
		_parent:SetScript("ontouch", function() self:handleTouch(msg) end)
		_parent:SetScript("onmousedown", function() self:handleMouseDown() end)
		_parent:SetScript("onmouseup", function() self:handleMouseUp() end)
		_parent:SetScript("onmousemove", function() self:handleMouseMove() end)
		item.uiControlId = _parent.id
	else
		_parent:Reposition(item.alignment, left, top, width, height)
	end
	return _parent
end

function FeatKeyboard:StaticInit()
    -- GameLogic:Connect("WorldLoaded", FeatKeyboard, FeatKeyboard.OnWorldLoaded, "UniqueConnection")
    -- 由于执行顺序的问题要用filter而不是connect
    GameLogic.GetFilters():add_filter("OnWorldLoaded", FeatKeyboard.OnWorldLoaded)


    -- GameLogic.events:RemoveEventListener("game_mode_change", FeatKeyboard.OnGameModeChanged, FeatKeyboard)
    -- GameLogic:Connect("WorldUnloaded", FeatKeyboard, FeatKeyboard.OnWorldUnloaded, "UniqueConnection")
end

function FeatKeyboard.OnWorldLoaded()
    if System.options.IsMobilePlatform or ParaEngine.GetAttributeObject():GetField("IsTouchInputting", false) or System.options.IsTouchDevice then
        local entity = EntityManager.GetFocus()
        entity.bFlying = entity:IsFlying() == true
        
        FeatKeyboard:show()
    end
end

function FeatKeyboard.OnGameModeChanged()
    FeatKeyboard:show()
end

function FeatKeyboard:getItem(x, y)
	for _, item in pairs(self.btnList) do
		local right = Design:adapterWidth(item.left) + Design:adapterWidth(item.width)
		local bottom = Design:adapterHeight(item.top) + Design:adapterWidth(item.height)
		local left = Design:adapterWidth(item.left)
		local top = Design:adapterHeight(item.top)
        if (top and top <= y and y <= bottom and left <= x and x <= right) then
            local uiControl = self:getUIControl(item)
            if uiControl.visible then
                return item
            end
        end
	end
end

--处理鼠标移动事件
function FeatKeyboard:handleMouseMove()
    local touch = { type = "WM_POINTERUPDATE", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:handleTouch(touch)
end

--处理鼠标点击事件
function FeatKeyboard:handleMouseDown()
    local touch = { type = "WM_POINTERDOWN", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:handleTouch(touch)
end

--处理鼠标弹起事件
function FeatKeyboard:handleMouseUp()
    local touch = { type = "WM_POINTERUP", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:handleTouch(touch)
end

--处理触摸事件
function FeatKeyboard:handleTouch(touch)
	local touchSession = TouchSession.GetTouchSession(touch)
    local item = self:getItem(touch.x, touch.y)
	if item then
        GameLogic.AddBBS(nil, item.name..touch.type, 2000, "0 0 255", 21)
        local uiControl = self:getUIControl(item)
        -- item.type 1按住维持状态的按键  2点击效果按键  3特殊效果按键
		if touch.type == "WM_POINTERDOWN" then
            item.isPressed = true
            if item.type == 1 then
                -- 清除功能按键的点击状态
                TouchFuncKeyboard:clearButtonState()
                for _,v in pairs(item.key) do
                    Keyboard:SendKeyEvent("keyDownEvent", v)
                end
                _guihelper.SetUIColor(uiControl, self.colors.pressed)
			elseif item.type == 2 then
				for _,v in pairs(item.key) do
                    Keyboard:SendKeyEvent("keyDownEvent", v)
                end
                _guihelper.SetUIColor(uiControl, self.colors.pressed)
                -- 按住不放的时候循环触发按下事件
                -- commonlib.TimerManager.SetTimeout(function()
                --     for _,v in pairs(item.key) do
                --         Keyboard:SendKeyEvent("keyDownEvent", v)
                --     end
                --     _guihelper.SetUIColor(uiControl, self.colors.normal)
                -- end, 300)
			elseif item.type == 3 then
                if item.downFunc then
                    item.downFunc(self)
                end
			end
		elseif touch.type == "WM_POINTERUP" then
            item.isPressed = false
			if item.type == 1 then
				for _,v in pairs(item.key) do
                    Keyboard:SendKeyEvent("keyUpEvent", v)
                end
                _guihelper.SetUIColor(uiControl, self.colors.normal)
            elseif item.type == 2 then
                for _,v in pairs(item.key) do
                    Keyboard:SendKeyEvent("keyUpEvent", v)
                end
                _guihelper.SetUIColor(uiControl, self.colors.normal)
            elseif item.type == 3 then
                if item.upFunc then
                    item.upFunc(self)
                end
			end
		elseif touch.type == "WM_POINTERUPDATE" then
			if item.type == 3 then
                if item.updateFunc then
                    item.updateFunc(self)
                end
			end
		end
	end
end

function FeatKeyboard:show(_show)
    self:generalUI()
    for k,v in pairs(self.btnList) do 
        local uiControl = self:getUIControl(v)
        uiControl.visible = (false == (_show == false))
    end

    local uiControlCtrl = ParaUI.GetUIObject("ctrlFeatBtnUIControl")
    local uiControlAlt = ParaUI.GetUIObject("altFeatBtnUIControl")
    local uiControlFunc = ParaUI.GetUIObject("funcFeatBtnUIControl")
    if not GameMode:IsEditor() then
        if uiControlCtrl and uiControlCtrl:IsValid() then
            uiControlCtrl.visible = false
        end
        if uiControlAlt and uiControlAlt:IsValid() then
            uiControlAlt.visible = false
        end
        if uiControlFunc and uiControlFunc:IsValid() then
            uiControlFunc.visible = false
        end
    end

    local entity = EntityManager.GetFocus()
    -- 不可飞行状态下设置飞行按钮不可见
    local uiControlFly = ParaUI.GetUIObject("flyFeatBtnUIControl")
    if not GameMode:CanFly() then
        if uiControlFly and uiControlFly:IsValid() then
            uiControlFly.visible = false
        end
    else
        if self.isClickFly == entity:IsFlying() then
            uiControlFly.background = self.btnList["flyFeatBtn"].clickedBackground
        else
            uiControlFly.background = self.btnList["flyFeatBtn"].background
        end
    end

    
    if self.isClickFly == entity:IsFlying() then
        local uiControlUp = ParaUI.GetUIObject("upFeatBtnUIControl")
        if uiControlUp and uiControlUp:IsValid() then
            uiControlUp.visible = false
        end
        local uiControlDown = ParaUI.GetUIObject("downFeatBtnUIControl")
        if uiControlDown and uiControlDown:IsValid() then
            uiControlDown.visible = false
        end
    else
        local uiControl = ParaUI.GetUIObject("jumpFeatBtnUIControl")
        if uiControl and uiControl:IsValid() then
            uiControl.visible = false
        end
    end
    self.isClickFly = false

    GameLogic.events:RemoveEventListener("game_mode_change", FeatKeyboard.OnGameModeChanged, FeatKeyboard)
    GameLogic.events:AddEventListener("game_mode_change", FeatKeyboard.OnGameModeChanged, FeatKeyboard, "FeatKeyboard")
end

function FeatKeyboard:Destroy()
    FeatKeyboard._super.Destroy(self)
    for k,v in pairs(self.btnList) do
        ParaUI.Destroy(v.id or v.name)
        v.id = nil
    end
end

function FeatKeyboard.funcBtnDown(self)
    local _show = TouchFuncKeyboard:getContainer().visible
    TouchFuncKeyboard:show(not _show)
end

function FeatKeyboard.flyBtnDown(self)
    -- 点击事件会有个异步延迟 需要做个判定
    Keyboard:SendKeyEvent("keyDownEvent", DIK_SCANCODE.DIK_F)
    self.isClickFly = true
    -- --刷新界面
    self:show()
end

function FeatKeyboard.flyBtnUp(self)
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_F)
end

function FeatKeyboard.shitfBtnDown(self)
    Keyboard:SendKeyEvent("keyDownEvent", DIK_SCANCODE.DIK_X)
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_X)
    Keyboard:SendKeyEvent("keyDownEvent", DIK_SCANCODE.DIK_LSHIFT)
    local uiControl = self:getUIControl(self.btnList["shitfFeatBtn"])
    _guihelper.SetUIColor(uiControl, self.colors.pressed)
end

function FeatKeyboard.shitfBtnUp(self)
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_LSHIFT)
    local uiControl = self:getUIControl(self.btnList["shitfFeatBtn"])
    _guihelper.SetUIColor(uiControl, self.colors.normal)
end

FeatKeyboard:InitSingleton()
