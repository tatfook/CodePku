--[[
Title: aries window for mcml2 element
Author(s): Maggie
Date: 
Desc: it create parent child relationship
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/AriesWindow/pe_aries_window2.lua");
local pe_aries_window2 = commonlib.gettable("Mod.CodePku.Common.AriesWindow.pe_aries_window2");
pe_aries_window2:RegisterAs("pe:aries_window2");

e.g.: <pe:aries_window2 alignment="_ct" title="yourtitle" style="width:...;height:...px;background:..."><div>Hello</div></pe:aries_window2>
------------------------------------------------------------
]]

NPL.load("(gl)script/ide/System/Windows/mcml/Elements/pe_div.lua");
NPL.load("(gl)script/ide/System/Windows/Controls/Canvas.lua");
NPL.load("(gl)script/ide/System/Windows/Controls/Label.lua");
NPL.load("(gl)script/ide/System/Windows/mcml/PageElement.lua");
NPL.load("(gl)script/ide/System/Windows/Shapes/Rectangle.lua");
local Button = commonlib.gettable("System.Windows.Controls.Button");
local Canvas = commonlib.gettable("System.Windows.Controls.Canvas");
local mcml = commonlib.gettable("System.Windows.mcml");
local Label = commonlib.gettable("System.Windows.Controls.Label");
local PageElement = commonlib.gettable("System.Windows.mcml.PageElement");
local Rectangle = commonlib.gettable("System.Windows.Shapes.Rectangle");
local Window = commonlib.gettable("System.Windows.Window");

local pe_aries_window2 = commonlib.inherit(commonlib.gettable("System.Windows.mcml.Elements.pe_div"), commonlib.gettable("Mod.CodePku.Common.AriesWindow.pe_aries_window2"));
pe_aries_window2:Property({"class_name", "pe:aries_window2"});

pe_aries_window2:Property({"Background", "codepku/image/textures/common_32bits.png#99 275 1158 588", auto=true});
pe_aries_window2:Property({"Width", 1158, auto=true});
pe_aries_window2:Property({"Height", 588, auto=true});
pe_aries_window2:Property({"CloseBtnWidth", 64, auto=true});
pe_aries_window2:Property({"CloseBtnHeight", 74, auto=true});
pe_aries_window2:Property({"CloseBtnBackground", "codepku/image/textures/common_32bits.png#110 73 68 78", auto=true});
pe_aries_window2:Property({"TitleWidth", 434, auto=true});
pe_aries_window2:Property({"TitleHeight", 115, auto=true});
pe_aries_window2:Property({"TitleBackground", "codepku/image/textures/common_32bits.png#1265 363 434 115", auto=true});

function pe_aries_window2:ctor()
    self.closeButton = nil;
    self.title = nil;
end

function pe_aries_window2:LoadComponent(parentElem, parentLayout, style)
    local _this = self.control;
    if (not _this) then
        _this = Canvas:new():init(parentElem);
        self:SetControl(_this);
    else
        _this:SetParent(parentElem);
    end
    PageElement.LoadComponent(self, _this, parentLayout, style);
    _this:ApplyCss(self:GetStyle());
end


function pe_aries_window2:OnLoadComponentBeforeChild(parentElem, parentLayout, css)
    css:Merge(mcml:GetStyleItem(self.class_name));
    css.width = css.width or self.Width;
    css.height = css.height or self.Height;
    css["background"] = self:GetAttributeWithCode("Background", nil, true) or css["background"] or self.Background;
    self:initHeader(parentElem, css);
    pe_aries_window2._super.OnLoadComponentBeforeChild(self, parentElem, parentLayout, css);
end

function pe_aries_window2:OnLoadComponentAfterChild(parentElem, parentLayout, css)
end

function pe_aries_window2:OnAfterChildLayout(layout, left, top, right, bottom)
	if(self.control) then
		self.control:setGeometry(left, top, right-left, bottom-top);
	end
end

function pe_aries_window2:initHeader(parentElem, css)
    --title
    local title_height = self:GetAttributeWithCode("TitleHeight", self.TitleHeight, true);
    local title_width = self:GetAttributeWithCode("TitleWidth", self.TitleWidth, true);
    local modal_width = css.width or self.Width;

    self.titleBg = Rectangle:new():init(parentElem);
    self.titleBg:SetBackground(self.TitleBackground);
    self.titleBg:setGeometry((modal_width - title_width)/2, -13, title_width, title_height);
    self.title = Label:new():init(parentElem);
    self.title:SetText(tostring(self:GetAttributeWithCode("title", nil, true) or ""));
    self.title:setGeometry((modal_width - title_width)/2, -13, title_width, title_height);
    self.title["Color"] = '#F46D3D';
    self.title:SetFont("Noto Sans S Chinese Regular;45;bold");

    -- close button
    self.closeBtn = Button:new():init(parentElem);
    local close_btn_width = self:GetAttributeWithCode("CloseBtnWidth", self.CloseBtnWidth, true);
    local close_btn_height = self:GetAttributeWithCode("CloseBtnHeight", self.CloseBtnHeight, true);
    self.closeBtn:setGeometry(modal_width - close_btn_width - 33, 5, close_btn_width, close_btn_height);
    self.closeBtn:SetBackground(self.CloseBtnBackground);
    self.closeBtn:Connect("clicked", function (event)
        local page = self:GetPageCtrl();
        page:CloseWindow();
    end);
end

function pe_aries_window2:OnBeforeChildLayout(layout)
	if(#self ~= 0) then
		local myLayout = layout:new();
		local css = self:GetStyle();
        local width, height = layout:GetPreferredSize();
        
        local title_height = self:GetAttributeWithCode("TitleHeight", self.TitleHeight, true);
        local padding_left = css:padding_left();
        local padding_top = title_height; --css:padding_top();
		myLayout:reset(padding_left,padding_top,width+padding_left, height+padding_top);
		self:UpdateChildLayout(myLayout);
		width, height = myLayout:GetUsedSize();
		width = width - padding_left;
		height = height - padding_top;
		layout:AddObject(width, height);
	end
	return true;
end