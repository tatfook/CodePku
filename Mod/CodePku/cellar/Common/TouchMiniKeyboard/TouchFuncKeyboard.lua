--[[
Author:zouren
Date: 2020-11-22 16:05:02
Des: 特殊世界移动端tab ctrl shift alt功能键小键盘
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchFuncKeyboard.lua")
local TouchFuncKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchFuncKeyboard")
TouchFuncKeyboard.getSingleton():show()
-----------------------------------
]]--


NPL.load("(gl)script/ide/System/Windows/Screen.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchSession.lua")
NPL.load("(gl)script/ide/System/Windows/Keyboard.lua")
NPL.load("(gl)script/ide/System/Windows/Mouse.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Commands/CommandManager.lua")
NPL.load("(gl)script/ide/UIAnim/UIAnimManager.lua")
local CommandManager = commonlib.gettable("MyCompany.Aries.Game.CommandManager")   
local Mouse = commonlib.gettable("System.Windows.Mouse")
local Keyboard = commonlib.gettable("System.Windows.Keyboard")
local TouchSession = commonlib.gettable("MyCompany.Aries.Game.Common.TouchSession")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local Screen = commonlib.gettable("System.Windows.Screen")

local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua")
local Table = NPL.load("(gl)Mod/CodePku/util/Table.lua")
local Design = NPL.load("(gl)Mod/CodePku/util/Design.lua")
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")
local funcKeyboardImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/funcKeyboardImageData.lua")

local TouchFuncKeyboard = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"),commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchFuncKeyboard"))
TouchFuncKeyboard:Property("Name", "TouchFuncKeyboard")

TouchFuncKeyboard.name = "default_TouchFuncKeyboard"

TouchFuncKeyboard.colors = { normal = "#ffffff", pressed = "#888888" }
-- GameLogic.GetEvents():AddEventListener("game_mode_change", TouchFuncKeyboard.OnGameModeChanged, TouchFuncKeyboard, "TouchFuncKeyboard")
function TouchFuncKeyboard:ctor()
	self.keylayout = {
		{
			name = "Ctrl+C",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_C,
			},
			type = 2, -- 1为切换状态按键 2为点击按键 3为特殊触发 0没有点击事件
		},
		{
			name = "Ctrl",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 219, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
			},
			type = 1,
		},
		{
			name = "Ctrl+V",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 18,top = 146,width = 192,height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_V,
			},
			type = 2,
		},
		{
			name = "Alt",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 219, top = 146, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LMENU,
				},
			type = 1,
		},
		{
			name = "Ctrl+Z",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 18, top = 228, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_Z,
				},
			type = 2,
		},
		{
			name = "Shift",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 219, top = 228, width = 192, height = 80,
			key = {
				DIK_SCANCODE.DIK_LSHIFT,
			},
			type = 1,
		},
		{
			name = "Tab",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 18, top = 310, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_TAB,
				},
			type = 2,
		},
		{
			name = "Ctrl+Shift",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 219, top = 310, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_LSHIFT,
				},
			type = 1,
		},
		{
			name = "Shift+Tab",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 18, top = 392, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LSHIFT,
				DIK_SCANCODE.DIK_TAB,
				},
			type = 2,
		},
		{
			name = "Alt+Shift",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 219, top = 392, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LMENU,
				DIK_SCANCODE.DIK_LSHIFT,
				},
			type = 1,
		},
		{
			name = "DEL",
			background = funcKeyboardImageData:GetIconUrl("funckeyboard_key_bot.png"),
			left = 18, top = 474, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_DELETE,
				},
			type = 2,
		},
	}

	self.questionItem = {
		name = "questionBtn",
		background = funcKeyboardImageData:GetIconUrl("funckeyboard_tips_question.png"),
		left = 370, top = 21, width = 34, height = 33,
		type = 3,
	}

	self.titleItem = {
		name = "titleLable",
		background = funcKeyboardImageData:GetIconUrl("funckeyboard_keypad_titlemat.png"),
		left = 131, top = 16, width = 166, height = 41,
		type = 0,
	}

	self:initUIComponent()
end

function TouchFuncKeyboard:initUIComponent()
	self.name = name or self.name
	local container = self:getContainer()
    container:RemoveAll()
	container.visible = false
	
	for _, item in ipairs(self.keylayout) do
        if item.name then
            local width = Design:adapterWidth(item.width)
            local height = Design:adapterWidth(item.height)

            local left = Design:adapterWidth(item.left)
            local top = Design:adapterWidth(item.top)

            local button = ParaUI.CreateUIObject(
				"button",
                item.name,
                "_lt",
                left,
                top,
                width,
				height
			)

			button.background = item.background
			button.text = item.name
			button.font = "Noto Sans S Chinese Regular;25.5;bold"
			button.enabled = false
			item.id = button.id
			_guihelper.SetButtonFontColor(button, "#7d3b02", "#7d3b02")
			_guihelper.SetUIColor(button, "#FFFFFF")
            container:AddChild(button)
        end
	end

	self.questionBtn = ParaUI.CreateUIObject(
		"button",
		self.questionItem.name,
		"_lt",
		Design:adapterWidth(self.questionItem.left),
		Design:adapterWidth(self.questionItem.top),
		Design:adapterWidth(self.questionItem.width),
		Design:adapterWidth(self.questionItem.height)
	)

	self.questionBtn.background = self.questionItem.background
	self.questionBtn.enabled = false

	_guihelper.SetUIColor(self.questionBtn, "#FFFFFF")
	container:AddChild(self.questionBtn)

	self.titleLable = ParaUI.CreateUIObject(
		"button",
		self.titleItem.name,
		"_lt",
		Design:adapterWidth(self.titleItem.left),
		Design:adapterWidth(self.titleItem.top),
		Design:adapterWidth(self.titleItem.width),
		Design:adapterWidth(self.titleItem.height)
	)

	self.titleLable.background = self.titleItem.background
	self.titleLable.enabled = false

	_guihelper.SetUIColor(self.titleLable, "#FFFFFF")
	container:AddChild(self.titleLable)
	return self
end

function TouchFuncKeyboard:refreshUIComponent()
	self:getContainer()
	for _, item in ipairs(self.keylayout) do
        if item.name then
			local button = ParaUI.GetUIObject(item.id or item.name)
			local width = Design:adapterWidth(item.width)
            local height = Design:adapterWidth(item.height)

            local left = Design:adapterWidth(item.left)
			local top = Design:adapterWidth(item.top)
			
			button:Reposition("_lt", left, top, width, height)
        end
	end
	self.questionBtn:Reposition(
		"_lt",
		Design:adapterWidth(self.questionItem.left),
		Design:adapterWidth(self.questionItem.top),
		Design:adapterWidth(self.questionItem.width),
		Design:adapterWidth(self.questionItem.height)
	)
	self.titleLable:Reposition(
		"_lt",
		Design:adapterWidth(self.titleItem.left),
		Design:adapterWidth(self.titleItem.top),
		Design:adapterWidth(self.titleItem.width),
		Design:adapterWidth(self.titleItem.height)
	)
end

function TouchFuncKeyboard:getContainer()
	local container = ParaUI.GetUIObject(self.id or self.name)
	self.zorder = 31
	self.alignment = "_lt"
	self.left = Design:adapterWidth(1354)
    self.top = Design:adapterWidth(58)
    self.width = Design:adapterWidth(429)
    self.height = Design:adapterWidth(577)
	
	if(not container:IsValid()) then
		container = ParaUI.CreateUIObject("container",self.name, self.alignment,self.left,self.top,self.width,self.height)
		container.background = funcKeyboardImageData:GetIconUrl("funckeyboard_bot.png")

		container:AttachToRoot()
		container.zorder = self.zorder
		container:SetScript("ontouch", function() self:handleTouch(msg) end)
		container:SetScript("onmousedown", function() self:handleMouseDown() end)
		container:SetScript("onmouseup", function() self:handleMouseUp() end)
		container:SetScript("onmousemove", function() self:handleMouseMove() end)

		self.id = container.id
	else
		container:Reposition(self.alignment,self.left,self.top,self.width,self.height)
	end
	return container
end

function TouchFuncKeyboard:getButtonItem(x, y)
    local x = x - self.left
    local y = y - self.top
	for _, item in ipairs(self.keylayout) do
		local right = Design:adapterWidth(item.left) + Design:adapterWidth(item.width)
		local bottom = Design:adapterWidth(item.top) + Design:adapterWidth(item.height)
		local left = Design:adapterWidth(item.left)
		local top = Design:adapterWidth(item.top)
        if (top and top <= y and y <= bottom and left <= x and x <= right) then
            return item
        end
	end
	local right = Design:adapterWidth(self.questionItem.left) + Design:adapterWidth(self.questionItem.width)
	local bottom = Design:adapterWidth(self.questionItem.top) + Design:adapterWidth(self.questionItem.height)
	local left = Design:adapterWidth(self.questionItem.left)
	local top = Design:adapterWidth(self.questionItem.top)
	if (top and top <= y and y <= bottom and left <= x and x <= right) then
		return self.questionItem
	end
end

--处理鼠标移动事件
function TouchFuncKeyboard:handleMouseMove()
    local touch = { type = "WM_POINTERUPDATE", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:handleTouch(touch)
end

--处理鼠标点击事件
function TouchFuncKeyboard:handleMouseDown()
    local touch = { type = "WM_POINTERDOWN", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:handleTouch(touch)
end

--处理鼠标弹起事件
function TouchFuncKeyboard:handleMouseUp()
    local touch = { type = "WM_POINTERUP", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:handleTouch(touch)
end

--处理触摸事件
function TouchFuncKeyboard:handleTouch(touch)
	local touchSession = TouchSession.GetTouchSession(touch)
	local button = self:getButtonItem(touch.x, touch.y)
	if button then
		-- GameLogic.AddBBS(nil, button.name, 2000, "0 0 255", 21)
		if touch.type == "WM_POINTERDOWN" then
			if self.currClickedBtn and self.currClickedBtn ~= button then
				self:clearButtonState(self.currClickedBtn)
			end
			if button.type == 1 then
				self.currClickedBtn = button
				button.isPressed = not button.isPressed
				self:updataKeyboardBtn(button)
				
			elseif button.type == 2 then
				button.isPressed = true
				self:updataKeyboardBtn(button)
			elseif button.type == 3 then
				-- TODO show page
			end
		elseif touch.type == "WM_POINTERUP" then
			if button.type == 2 then
				button.isPressed = false
				self:updataKeyboardBtn(button)
			end
		elseif touch.type == "WM_POINTERUPDATE" then
			return
		end
	end
end

function TouchFuncKeyboard:updataKeyboardBtn(button)
	local containers = self:getContainer()
	local buttonUI = containers:GetChild(button.name)
	if button.isPressed then
		_guihelper.SetUIColor(buttonUI, self.colors.pressed)
	else
		_guihelper.SetUIColor(buttonUI, self.colors.normal)
	end
	if button.key then
		for _,val in pairs(button.key) do
			Keyboard:SendKeyEvent(button.isPressed and "keyDownEvent" or "keyUpEvent", val)
		end
	end
	Mouse:SetTouchButtonSwapped(button.isPressed)
end

function TouchFuncKeyboard:clearButtonState(button)
	if button then
		local containers = self:getContainer()
		local buttonUI = containers:GetChild(button.name)
		button.isPressed = false
		_guihelper.SetUIColor(buttonUI, self.colors.normal)
		if button.key then
			for _,val in pairs(button.key) do
				Keyboard:SendKeyEvent(button.isPressed and "keyDownEvent" or "keyUpEvent", val)
			end
		end
		Mouse:SetTouchButtonSwapped(button.isPressed)
	elseif self.currClickedBtn then
		local containers = self:getContainer()
		local buttonUI = containers:GetChild(self.currClickedBtn.name)
		self.currClickedBtn.isPressed = false
		_guihelper.SetUIColor(buttonUI, self.colors.normal)
		if self.currClickedBtn.key then
			for _,val in pairs(self.currClickedBtn.key) do
				Keyboard:SendKeyEvent(self.currClickedBtn.isPressed and "keyDownEvent" or "keyUpEvent", val)
			end
		end
		Mouse:SetTouchButtonSwapped(self.currClickedBtn.isPressed)
	end
	self.currClickedBtn = nil
end

--控制显示功能键盘
function TouchFuncKeyboard:show(_show)
	self:refreshUIComponent()
	local container = self:getContainer()
	self:clearButtonState()
	container.visible = (false == (_show == false))
end

function TouchFuncKeyboard:Destroy()
    TouchFuncKeyboard._super.Destroy(self)
    ParaUI.Destroy(self.id or self.name)
    self.id = nil
end

TouchFuncKeyboard:InitSingleton()