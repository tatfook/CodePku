--[[
Author:zouren
Date: 2020-11-22 16:05:02
Des: 特殊世界移动端tab ctrl shift alt功能键小键盘
use the lib:
------------------------------------
NPL.load("(gl)path")
local TouchCASTKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchCASTKeyboard")
TouchCASTKeyboard:Show()
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

local TouchCASTKeyboard = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"),commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchCASTKeyboard"))
TouchCASTKeyboard:Property("Name", "TouchCASTKeyboard");

TouchCASTKeyboard.name = "TouchCASTKeyboard";
TouchCASTKeyboard:Signal("hidden")

function TouchCASTKeyboard:ctor()
	self.zorder = 1000;
	self.keylayout = {
		{
			name = "Ctrl",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {
				DIK_SCANCODE.DIK_LCONTROL,
			},
			type = 1, -- 1为切换状态按键 2为点击按键
		},
		{
			name = "Ctrl+C",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 219, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_C,
			},
			type = 2,
		},
		{
			name = "Ctrl+Z",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18,top = 146,width = 192,height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_Z,
			},
			type = 2,
		},
		{
			name = "Ctrl+V",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_V,
				},
			type = 2,
		},
		{
			name = "Ctrl+Shift",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LCONTROL,
				DIK_SCANCODE.DIK_LSHIFT,
				},
			type = 1,
		},
		{
			name = "Shift",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LSHIFT,
				},
			type = 1,
		},
		{
			name = "Shift+Tab",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LSHIFT,
				DIK_SCANCODE.DIK_TAB,
				},
			type = 2,
		},
		{
			name = "Alt",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LMENU,
				},
			type = 1,
		},
		{
			name = "Alt+Shift",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_LMENU,
				DIK_SCANCODE.DIK_LSHIFT,
				},
			type = 1,
		},
		{
			name = "Tab",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_TAB,
				},
			type = 2,
		},
		{
			name = "DEL",
			background = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			clickedBackground = mainFrameImageData:GetIconUrl("main_icon_up.png"),
			left = 18, top = 64, width = 192, height = 80,
			key = {	
				DIK_SCANCODE.DIK_BACK,
				},
			type = 2,
		},
	};
end

function TouchCASTKeyboard:Init(name, left, top, width)
	self.name = name or self.name;
	-- self:SetPosition(left, top, width);
	return self;
end

function TouchCASTKeyboard:GetContainer()
	local container = ParaUI.GetUIObject(self.id or self.name);
	self.alignment = "_rt";
	self.left = Design:adapterWidth(1354);
    self.top = Screen:GetHeight() - Design:adapterWidth(58);
    self.width = Design:adapterWidth(429);
    self.height = Design:adapterWidth(577);
	
	if(not container:IsValid()) then
		container = ParaUI.CreateUIObject("container",self.name, self.alignment,self.left,self.top,self.width,self.height);
		container.background = "";

		container:AttachToRoot();
		container.zorder = self.zorder;
		container:SetScript("ontouch", function() self:OnTouch(msg) end);
		container:SetScript("onmousedown", function() self:OnMouseDown() end);
		container:SetScript("onmouseup", function() self:OnMouseUp() end);
		container:SetScript("onmousemove", function() self:OnMouseMove() end);

		self.id = container.id;
	else
		container:Reposition(self.alignment,self.left,self.top,self.width,self.height);
	end
	return container;
end

--处理鼠标移动事件
function DirectionKeyboard:OnMouseMove()
    local touch = { type = "WM_POINTERUPDATE", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:OnTouch(touch);
end

--处理鼠标点击事件
function DirectionKeyboard:OnMouseDown()
    local touch = { type = "WM_POINTERDOWN", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:OnTouch(touch);
end

--处理鼠标弹起事件
function DirectionKeyboard:OnMouseUp()
    local touch = { type = "WM_POINTERUP", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:OnTouch(touch);
end

--处理触摸事件
function DirectionKeyboard:OnTouch(touch)
    local touchSession = TouchSession.GetTouchSession(touch);
    local button = self:getButtonItem(touch.x, touch.y);

    if touch.type == "WM_POINTERDOWN" then
        if button then
            touchSession:SetField("keydownBtn", button);
            self:updateButtonState(button, true);
            button.isDragged = nil;
        end
    elseif touch.type == "WM_POINTERUP" then
        local keydownBtn = touchSession:GetField("keydownBtn");
        if keydownBtn then
            self:updateButtonState(keydownBtn, false);
        end
    elseif touch.type == "WM_POINTERUPDATE" then
        local keydownBtn = touchSession:GetField("keydownBtn");

        if keydownBtn then
            keydownBtn.isDragged = true;

            if button and button ~= keydownBtn then
                if keydownBtn.isPressed then
                    self:updateButtonState(keydownBtn, false);
                end

                touchSession:SetField("keydownBtn", button);
                self:updateButtonState(button, true);
            end
        else
            if button then
                touchSession:SetField("keydownBtn", button);
                self:updateButtonState(button, true);
            end
        end
    end
end
