--[[
Title: test pe_custom controls
Author(s): LiXizhi
Date: 2015/5/6
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/AriesWindow/pe_modal.lua");
local ModalControl = commonlib.gettable("Mod.CodePku.Common.AriesWindow.ModalControl");
------------------------------------------------------------
]]

-- NPL.load("(gl)script/ide/System/Windows/mcml/PageElement.lua");
NPL.load("(gl)script/ide/System/Windows/Window.lua");
NPL.load("(gl)script/ide/System/Windows/Controls/Button.lua");
local Button = commonlib.gettable("System.Windows.Controls.Button");
-- local UIElement = commonlib.gettable("System.Windows.UIElement");
local Window = commonlib.gettable("System.Windows.Window")
-- local Event = commonlib.gettable("System.Core.Event");
local ModalControl = commonlib.inherit(commonlib.gettable("System.Windows.UIElement"), commonlib.gettable("Mod.CodePku.Common.AriesWindow.ModalControl"));

ModalControl:Property("Name", "ModalControl");

ModalControl:Property({"Color", "#000000", auto=true});
ModalControl:Property({"Background", "codepku/image/textures/common_32bits.png#99 275 1158 588", auto=true});
ModalControl:Property({"CloseButtonWidth", 64, auto=true});
ModalControl:Property({"CloseButtonHeight", 74, auto=true});
ModalControl:Property({"CloseButtonBackground", "codepku/image/textures/common_32bits.png#110 73 68 78", auto=true});

ModalControl:Property({"TitleText", nil, auto=true});

function ModalControl:ctor()
    self.closeButton = nil;
end

function ModalControl:init(parent)
    ModalControl._super.init(self,parent);
    self:initButton();
    return self;
end

function ModalControl:initButton()
    self.closeButton = Button:new():init(self);
    self.closeButton:setGeometry(1158 - self.CloseButtonWidth - 33, 5, self.CloseButtonWidth, self.CloseButtonHeight);
    self.closeButton:SetBackground(self.CloseButtonBackground);
	self.closeButton:Connect("clicked", function (event)
		_guihelper.MessageBox("you clicked me");
	end)
    self.closeButton:Connect("released", function(event)
		_guihelper.MessageBox("mouse up");
    end)
end


function ModalControl:initTitle()
    -- self.titleButton = Button:new():init(self);
end

function ModalControl:setGeometry(ax, ay, aw, ah)
    ModalControl._super.setGeometry(self, ax, ay, w, h);
end

function ModalControl:paintEvent(painter)
    echo('@34 painter')
	local x, y = self:x(), self:y();
    local background = self.Background;
    echo(self:GetBackgroundColor())
    painter:SetPen("#ffffff");
    painter:DrawRectTexture(x, y, 1158 or self:width(), 588 or self:height(), background);
end


function ModalControl:ApplyCss(css)
    echo("@@@@@@ applied css")
    ModalControl._super.ApplyCss(self, css);
end

-- function ModalControl:OnLoadComponentBeforeChild(parentElem, parentLayout, css)
--     echo("@jfhlaksjdlf")
--     local _this = self.control;
--     if (not _this) then
--         _this = ModalControl:new():init(parentElem);
-- 		self:SetControl(_this);
--     else
-- 		_this:SetParent(parentElem);
--     end
-- 	_this:ApplyCss(css);
--     _this:SetText(self:GetAttributeWithCode("title", nil, true));
--     ModalControl._super.OnLoadComponentBeforeChild(self, parentElem, parentLayout, css)
-- end