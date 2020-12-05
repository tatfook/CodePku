--功能按钮
--author:John mai
--date: 2020-05-29 15:55:40
NPL.load("(gl)script/ide/System/Windows/Screen.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchSession.lua")
NPL.load("(gl)script/ide/System/Windows/Keyboard.lua")
NPL.load("(gl)script/ide/System/Windows/Mouse.lua")
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchFuncKeyboard.lua")
local Mouse = commonlib.gettable("System.Windows.Mouse")
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

function FeatKeyboard:ctor()
    self.btnList = {
        {
            name = "jumpFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_tiao.png"),
            clickedBackground = nil,
            left = 1594, top = 845, width = 212, height = 212, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_SPACE, 
            },
            type = 2, -- 1按住维持状态的按键  2点击效果按键  3特殊效果按键
        },
        {
            name = "flyFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_flying.png"),
            clickedBackground = mainFrameImageData:GetIconUrl("main_icon_fly02.png"),
            left = 1803, top = 566, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_F, 
            },
            type = 3,
        },
        {
            name = "funcFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_more.png"),
            clickedBackground = nil,
            left = 1803, top = 456, width = 94, height = 94, alignment = "_lt",
            key = {},
            type = 3,
        },
        {
            name = "ctrlFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_ctrl.png"),
            clickedBackground = nil,
            left = 1450, top = 746, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LCONTROL, 
            },
            type = 1,
        },
        {
            name = "shitfFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_shift_s.png"),
            clickedBackground = nil,
            left = 1555, top = 670, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LSHIFT, 
            },
            type = 1,
        },
        {
            name = "altFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_alt.png"),
            clickedBackground = nil,
            left = 1399, top = 864, width = 94, height = 94, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LMENU, 
            },
            type = 1,
        },
        {
            name = "upFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_fly_up.png"),
            clickedBackground = nil,
            left = 1596, top = 845, width = 202, height = 107, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LMENU, 
            },
            type = 2,
        },
        {
            name = "downFeatBtn",
            background = mainFrameImageData:GetIconUrl("main_icon_fly_down.png"),
            clickedBackground = nil,
            left = 1596, top = 954, width = 202, height = 103, alignment = "_lt",
            key = { 
                DIK_SCANCODE.DIK_LMENU, 
            },
            type = 2,
        },
    }
end

function FeatKeyboard:generalBtn()
    for k,v in pairs(self.btnList) do 
        self:getBtn(v)
    end
end

function FeatKeyboard:getBtn(item)
    local buttonUI = ParaUI.GetUIObject(item.id or item.name)

    local left = Design:adapterWidth(item.left)
    local top = Design:adapterHeight(item.top)
    local width = Design:adapterWidth(item.width)
    local height = Design:adapterWidth(item.height) --维持宽高一致  adapterWidth

    if not buttonUI:IsValid() then
        buttonUI = ParaUI.CreateUIObject(
            "button",
            item.name,
            item.alignment,
            left,
            top,
            width,
            height
        )
        buttonUI.background = item.background
        _guihelper.SetUIColor(buttonUI, self.colors.normal)

        buttonUI.enabled = true
        buttonUI.zorder = self.zorder
        buttonUI:SetScript("ontouch", function() self:handleTouch(msg) end)
        buttonUI:SetScript("onmousedown", function() self:handleMouseDown() end)
        buttonUI:SetScript("onmouseup", function() self:handleMouseUp() end)
        buttonUI:SetScript("onmousemove", function() self:handleMouseMove() end)

        buttonUI:AttachToRoot()
        item.id  = buttonUI.id
    else
        buttonUI:Reposition(item.alignment, left, top, width, height)
    end
    return buttonUI
end

function FeatKeyboard:getButtonItem(x, y)
	for _, item in ipairs(self.btnList) do
		local right = Design:adapterWidth(item.left) + Design:adapterWidth(item.width)
		local bottom = Design:adapterWidth(item.top) + Design:adapterWidth(item.height)
		local left = Design:adapterWidth(item.left)
		local top = Design:adapterHeight(item.top)
        if (top and top <= y and y <= bottom and left <= x and x <= right) then
            return item
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
    local button = self:getButtonItem(touch.x, touch.y)
    GameLogic.AddBBS(nil, button.name..touch.type, 2000, "0 0 255", 21)
	if button then
        -- GameLogic.AddBBS(nil, button.name, 2000, "0 0 255", 21)
        local buttonUI = self:getBtn(button)
        -- button.type 1按住维持状态的按键  2点击效果按键  3特殊效果按键
		if touch.type == "WM_POINTERDOWN" then
            button.isPressed = true
            if button.type == 1 then
                -- 清除功能按键的点击状态
                TouchFuncKeyboard:clearButtonState()
                for _,v in pairs(button.key) do
                    Keyboard:SendKeyEvent("keyDownEvent", button.key)
                end
                _guihelper.SetUIColor(buttonUI, self.colors.pressed)				
			elseif button.type == 2 then
				for _,v in pairs(button.key) do
                    Keyboard:SendKeyEvent("keyDownEvent", button.key)
                end
                _guihelper.SetUIColor(buttonUI, self.colors.pressed)
                -- 按住不放的时候循环触发按下事件
                commonlib.TimerManager.SetTimeout(function()
                    for _,v in pairs(button.key) do
                        Keyboard:SendKeyEvent("keyDownEvent", button.key)
                    end
                    _guihelper.SetUIColor(buttonUI, self.colors.normal)
                end, 300)
			elseif button.type == 3 then
				-- TODO
			end
		elseif touch.type == "WM_POINTERUP" then
            button.isPressed = false
			if button.type == 1 then
				for _,v in pairs(button.key) do
                    Keyboard:SendKeyEvent("keyUpEvent", button.key)
                end
                _guihelper.SetUIColor(buttonUI, self.colors.normal)
            elseif button.type == 2 then
                for _,v in pairs(button.key) do
                    Keyboard:SendKeyEvent("keyUpEvent", button.key)
                end
                _guihelper.SetUIColor(buttonUI, self.colors.normal)
            elseif button.type == 3 then
				-- TODO
			end
		elseif touch.type == "WM_POINTERUPDATE" then
			return
		end
	end
end

function FeatKeyboard:show(_show)
    self:generalBtn()

    for k,v in pairs(self.btnList) do 
        local button = self:getBtn(v)
        button.visible = (false == (_show == false))
    end
end

function FeatKeyboard:Destroy()
    FeatKeyboard._super.Destroy(self)
    for k,v in pairs(self.btnList) do
        ParaUI.Destroy(v.id or v.name)
        v.id = nil
    end
end

FeatKeyboard:InitSingleton()
