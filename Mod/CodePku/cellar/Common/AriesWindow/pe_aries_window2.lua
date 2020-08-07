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
------------------------------------------------------------
]]

NPL.load("(gl)script/ide/System/Windows/mcml/Elements/pe_div.lua");
NPL.load("(gl)script/ide/System/Windows/Controls/Canvas.lua");
NPL.load("(gl)script/ide/System/Windows/mcml/PageElement.lua");
local Button = commonlib.gettable("System.Windows.Controls.Button");
local Canvas = commonlib.gettable("System.Windows.Controls.Canvas");
local mcml = commonlib.gettable("System.Windows.mcml");
local PageElement = commonlib.gettable("System.Windows.mcml.PageElement");
local Window = commonlib.gettable("System.Windows.Window");

local pe_aries_window2 = commonlib.inherit(commonlib.gettable("System.Windows.mcml.Elements.pe_div"), commonlib.gettable("Mod.CodePku.Common.AriesWindow.pe_aries_window2"));
pe_aries_window2:Property({"class_name", "pe:aries_window2"});

pe_aries_window2:Property({"Background", "codepku/image/textures/common_32bits.png#99 275 1158 588", auto=true});
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
    echo('@54： ')
    echo(css)
    css:Merge(mcml:GetStyleItem(self.class_name));
    css.width = css.width or 1158;
    css.height = css.height or 588;
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
    echo('@ 75')
    echo(css)
    --title
    self.title = Button:new():init(parentElem);
    local title_height = self:GetAttributeWithCode("TitleHeight", self.TitleHeight, true);
    local title_width = self:GetAttributeWithCode("TitleWidth", self.TitleWidth, true);
    self.title:SetBackground(self.TitleBackground);
    self.title:SetText(tostring(self:GetAttributeWithCode("title", nil, true) or ""));
    self.title:setGeometry((1158 - title_width)/2, 0, title_width, title_height);
    self.title["Color"] = '#F46D3D';
    self.title:SetFont("Noto Sans S Chinese Regular;45;bold");
    
    -- css["font-size"] = 45;
    -- css["font-weight"] = "bold";
    -- css["font-family"] = "Noto Sans S Chinese Regular";
    -- css["font"] = 
    -- css["color"] = "#F46D3D";
    -- self.title:ApplyCss(css);

    -- close button
    self.closeBtn = Button:new():init(parentElem);
    local close_btn_width = self:GetAttributeWithCode("CloseBtnWidth", self.CloseBtnWidth, true);
    local close_btn_height = self:GetAttributeWithCode("CloseBtnHeight", self.CloseBtnHeight, true);
    self.closeBtn:setGeometry(1158 - close_btn_width - 33, 5, close_btn_width, close_btn_height);
    self.closeBtn:SetBackground(self.CloseBtnBackground);
    self.closeBtn:Connect("clicked", function (event)
        local page = self:GetPageCtrl();
        page:CloseWindow();
	end);
end

