--[[
Author:zouren
Date: 2020-11-22 16:05:02
Des: 特殊世界移动端tab ctrl shift alt功能键小键盘
use the lib:
------------------------------------
NPL.load("(gl)path")
local TouchCSAKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchCSAKeyboard")
TouchCSAKeyboard:show()
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

local TouchCSAKeyboard = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"),commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchCSAKeyboard"))
TouchCSAKeyboard:Property("Name", "TouchCSAKeyboard");

TouchCSAKeyboard.name = "TouchCSAKeyboard";
TouchCSAKeyboard:Signal("hidden")

function TouchCSAKeyboard:ctor()
	self.alignment = "_rt";
	self.zorder = 1000;
	self.alphaAnimSpeed = 10/256;
	self.keylayout = {
		-- row 1
		{
			{name="Ctrl", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL}, tips = "", type = 1,},
			{name="Ctrl+C", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_C}, tips = "", type = 2,},
		},
		{
			{col=1, },
			{name="Ctrl+Z", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_Z}, tips = "", type = 2,},
			{name="Ctrl+V", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_V}, tips = "", type = 2,},
		},
		{
			{col=1, },
			{name="Ctrl+Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 1,},
			{name="Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 1,},
		},
		{
			{col=1, },
			{name="Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 2,},
			{name="Shift+Tab", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LSHIFT, DIK_SCANCODE.DIK_TAB}, tips = "", type = 2,},
        },
        {
			{col=1, },
			{name="Alt", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LMENU}, tips = "", type = 2,},
			{name="Alt+Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LMENU, DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 2,},
        },
        {
			{col=1, },
			{name="Tab", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_TAB}, tips = "", type = 2,},
			{name="DEL", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_BACK}, tips = "", type = 2,},
		},
	};

	-- normalBtn, comboBtn, frequentBtn
	self.colors = { 
		{normal="#ffffff", pressed="#888888"}, 
		{normal="#cccccc", pressed="#333333"}, 
		{normal="#8888ff", pressed="#3333cc"}
	};
	self.finger_size = 10;
	self.transparency = 1;
	-- when key is up
	self.defaultTransparency = 0.7;
	-- when key is down
	self.touchTransparency = 0.9;
end

function TouchCSAKeyboard:Init(name, left, top, width)
	self.name = name or self.name;
	-- self:SetPosition(left, top, width);
	return self;
end

function TouchCSAKeyboard:GetUIControl()
	local _parent = ParaUI.GetUIObject(self.id or self.name);
	
	if(not _parent:IsValid()) then
		_parent = ParaUI.CreateUIObject("container",self.name, self.alignment,self.left,self.top,self.width,self.height);
		_parent.background = "Texture/whitedot.png";
		_guihelper.SetUIColor(_parent, "#000000");
		_parent:AttachToRoot();
		_parent.zorder = self.zorder;
		_parent:SetScript("ontouch", function() self:OnTouch(msg) end);
		_parent:SetScript("onmousedown", function() self:OnMouseDown() end);
		_parent:SetScript("onmouseup", function() self:OnMouseUp() end);
		_parent:SetScript("onmousemove", function() self:OnMouseMove() end);

		self.id = _parent.id;
	else
		_parent:Reposition(self.alignment,self.left,self.top,self.width,self.height);
	end
	return _parent;
end

function TouchCSAKeyboard:isVisible()
	return self.bIsVisible;
end

function TouchCSAKeyboard:Destroy()
	TouchCSAKeyboard._super.Destroy(self);
	ParaUI.Destroy(self.id or self.name);
	self.id = nil;
end

function TouchCSAKeyboard:SetFocusedMode(bFocused)
	self.focused_mode = bFocused;
end

function TouchCSAKeyboard:IsFocusedMode()
	return self.focused_mode;
end

function TouchCSAKeyboard:SetTransparency(alpha, bAnimate)
	if(self.transparency ~= alpha) then
		if(bAnimate) then
			self.target_transparency = alpha;
			self.timer = self.timer or commonlib.Timer:new({callbackFunc = function(timer)
				
				if( math.abs(self.transparency - self.target_transparency) < self.alphaAnimSpeed ) then
					self:SetTransparencyImp(self.target_transparency);
					timer:Change();
				else
					self:SetTransparencyImp(self.transparency - self.alphaAnimSpeed*math.abs(self.transparency - self.target_transparency)/(self.transparency - self.target_transparency));
				end
			end})
			self.timer:Change(0, 33);
		else
			if(self.timer) then
				self.timer:Change();
			end
			self:SetTransparencyImp(alpha)
		end
	end
	return self;
end

function TouchCSAKeyboard:SetTransparencyImp(alpha)
	self.transparency = alpha;
	local _parent = self:GetUIControl();
	_guihelper.SetColorMask(_parent, format("255 255 255 %d",math.floor(alpha * 255)))
	_parent:ApplyAnim();
end

function TouchCSAKeyboard:CreateWindow()
	local _parent = self:GetUIControl();
	_parent:RemoveAll();
	_parent.visible = false;

	local btn_margin = self.key_margin;
	for row = 1, #self.keylayout do
		local cols = self.keylayout[row];
		local left_col = 0;
		for _, item in ipairs(cols) do
			if (item.name) then
				-- get global screen position
				item.left = left_col*self.button_width;
				item.top = (row-1)*self.button_height;
				item.right = item.left+ item.col*self.button_width;
				item.bottom = item.top + self.button_height;

				local keyBtn = ParaUI.CreateUIObject("button",item.name, "_lt", left_col*self.button_width + btn_margin, (row-1)*self.button_height+btn_margin, item.col*self.button_width-btn_margin*2, self.button_height-btn_margin*2);
				keyBtn.background = "Texture/whitedot.png";
				keyBtn.enabled = false;
				keyBtn.text = self:GetItemDisplayText(item);
				_guihelper.SetButtonFontColor(keyBtn, "#000000");
				_guihelper.SetUIColor(keyBtn, self.colors[item.colorid or 1].normal);
				_parent:AddChild(keyBtn);
			end
			left_col = left_col + item.col;
		end
	end
end



