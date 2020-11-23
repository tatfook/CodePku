--[[
Author:zouren
Date: 2020-11-22 16:05:02
Des: 特殊世界移动端tab ctrl shift alt功能键小键盘
use the lib:
------------------------------------
NPL.load("(gl)path")
local TouchCSAKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchCSAKeyboard")
TouchCSAKeyboard:Show()
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
			{name="Ctrl+Z", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_Z}, tips = "", type = 2,},
			{name="Ctrl+V", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_V}, tips = "", type = 2,},
		},
		{
			{name="Ctrl+Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LCONTROL, DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 1,},
			{name="Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 1,},
		},
		{
			{name="Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 2,},
			{name="Shift+Tab", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LSHIFT, DIK_SCANCODE.DIK_TAB}, tips = "", type = 2,},
        },
        {
			{name="Alt", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LMENU}, tips = "", type = 2,},
			{name="Alt+Shift", combo=true, col=1.5, colorid=2, vKey = {DIK_SCANCODE.DIK_LMENU, DIK_SCANCODE.DIK_LSHIFT}, tips = "", type = 2,},
        },
        {
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

function TouchCSAKeyboard:GetContainer()
	local container = ParaUI.GetUIObject(self.id or self.name);
	
	if(not container:IsValid()) then
		container = ParaUI.CreateUIObject("container",self.name, self.alignment,self.left,self.top,self.width,self.height);
		container.background = "Texture/whitedot.png";
		_guihelper.SetUIColor(container, "#000000");
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


