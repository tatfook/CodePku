local pe_aries_window = commonlib.gettable("MyCompany.Aries.mcml_controls.pe_aries_window");

local codepku_pe_aries_window = NPL.export()
local lite_window_bg = "Texture/Aries/Common/Teen/control/window_none_title_icon_32bits.png;0 0 256 164:80 40 120 20";

local window_bg = "codepku/image/textures/modal/common_32bits.png#11 1105 980 380;"
local window_title_bg = "Texture/Aries/Common/Teen/control/window_none_ribbon_bg_32bits.png;0 0 220 70:113 29 102 32";--220 70
local window_title_highlight_bg = "Texture/Aries/Common/Teen/control/window_title_center_bg_32bits.png;0 0 425 38";--425 38
local window_ribbon_bg = "Texture/Aries/Common/Teen/control/window_title_ribbon_32bits.png;0 0 660 42";--660 42
local window_title_text = "";
local window_icon = "";
local help_btn_bg = "Texture/Aries/Common/Teen/control/help_32bits.png;0 0 20 20";
local close_btn_bg = "Texture/Aries/Common/Teen/control/close_button2_32bits.png;0 0 30 20";
local help_disable_btn_bg = "Texture/Aries/Common/Teen/control/help_disable_32bits.png;0 0 20 20";

local mc_window_bg = "codepku/image/textures/modal/common_32bits.png#11 1105 980 380;" -- thin
local mc_window_bg_866_384 = "codepku/image/textures/modal/bag_box_32bits.png#74 75 1444 640" -- 背包造型背景
local mc_window_bg_854 = "codepku/image/textures/modal/bag_box_32bits.png#66 2735 854 854" -- 箱子背景
local center_mc_window_bg = "codepku/image/textures/modal/common_32bits.png#11 53 1000 624;"
local mc_close_btn_bg = "codepku/image/textures/modal/common_32bits.png#27 906 64 64";
local mc_line = "codepku/image/textures/modal/bag_box_32bits.png#74 1767 962 2;";
-- local mc_line = "Texture/Aries/Creator/Theme/GameCommonIcon_32bits.png;352 66 1 1";


function codepku_pe_aries_window.create_thin_mc(rootName, mcmlNode, bindingContext, _parent, left, top, width, height, parentLayout, css)
	--local isdeepbg = mcmlNode:GetBool("isdeepbg");
	local w = mcmlNode:GetNumber("width") or (width-left);
	local default_height = mcmlNode:GetNumber("height")
	local h = default_height or (height-top);
	local title = mcmlNode:GetAttribute("title_text") or mcmlNode:GetAttributeWithCode("title", nil, true);
	local icon = mcmlNode:GetString("icon") or ""; --32 32
	local background = mcmlNode:GetString("background") or "";
	
	local title_height = mcmlNode:GetNumber("title_height") or 45;
	
	local _this = ParaUI.CreateUIObject("container", "c", "_lt", left, top, w, h);
	if (width > 800 and height < 400) then
		_this.background = mc_window_bg_866_384;
	elseif (width == 512) then
		_this.background = mc_window_bg_854;
	else
		_this.background = mc_window_bg;
	end
	_parent:AddChild(_this);
	_parent = _this;
	local _parent_window = _this;

	
	_this = ParaUI.CreateUIObject("button", "window_title_text", "_lt", 10, 1, w, title_height);
	_this.enabled = false;
	_this.text = title;
	_this.background = "";
	if(title_height >= 32) then
		-- if (mcmlNode:GetNumber("close_height")) then
		-- 	_this.font = "System;14;bold";
		-- else
		-- 	_this.font = "System;20;bold";
		-- end
		_this.font = "System;25.2;bold";
		_this.x = 28;
		_this.y = (title_height - 38) / 2;
	else
		_this.font = "System;14;bold";
		_this.x = 18;
		_this.y = (title_height - 24) / 2;
	end
	_guihelper.SetUIFontFormat(_this, 36)
	_guihelper.SetUIFontFormat(_this, 36)
	_guihelper.SetButtonFontColor(_this, "#262014", "#262014");
	_parent:AddChild(_this);
	
	local onclose = mcmlNode:GetString("onclose");

	if(onclose and onclose ~= "")then
		local btn_size = mcmlNode:GetNumber("close_height") or 26.4
		_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -(btn_size / 2) - btn_size, (title_height-btn_size) * 0.65, btn_size, btn_size)
		-- if (close_height) then
		-- 	local btn_size = mcmlNode:GetNumber("close_height")
		-- 	_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -(btn_size / 2) - btn_size, (title_height-btn_size) * 0.65, btn_size, btn_size)
		-- else
		-- 	local btn_size = title_height - 4 --2
		-- 	if(title_height>=32) then
		-- 		_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -btn_size-10, 8, btn_size, btn_size);	
		-- 	else
		-- 		_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -btn_size-1, 8, btn_size * 0.6, btn_size * 0.6);	
		-- 	end
		-- end
		
		_this.background = mc_close_btn_bg;
		_parent:AddChild(_this);

		if(title_height>=32) then
			_this.enabled = false;
			_guihelper.SetUIColor(_this, "#ffffffff");
			_parent:AddChild(_this);
			-- the actual touchable area is 2 times bigger, to make it easier to click on some touch device. 
			_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -title_height*2, 0, title_height*2, title_height);
			_this.background = "";
			_parent:AddChild(_this);
		end

		_this:SetScript("onclick", function()
			Map3DSystem.mcml_controls.OnPageEvent(mcmlNode, onclose, buttonName, mcmlNode)
		end);
	end

	_this = ParaUI.CreateUIObject("container", "mc_panel_line", "_lt", 1, title_height, w-2, 1);
	_this.background = mc_line;
	_parent:AddChild(_this);
	local parent_width, parent_height = w - 2, h - title_height + 4;
	_this = ParaUI.CreateUIObject("container", "childnode", "_fi", 5, title_height, 7, 7);
	_this.background=background;
	_parent:AddChild(_this);
	_parent = _this;

	local myLayout = parentLayout:new_child();
	myLayout:reset(0, 0, parent_width, parent_height);
	myLayout:ResetUsedSize();
	mcmlNode:DrawChildBlocks_Callback(rootName, bindingContext, _parent, 0, 0, parent_width, parent_height, myLayout, css);

	-- if height is not specified, we will use auto-sizing. 
	if(not default_height) then
		local used_width, used_height = myLayout:GetUsedSize();
		if(used_height < parent_height) then
			_parent_window.height = h - (parent_height-used_height);
		end
	end
end

function codepku_pe_aries_window.create_center(rootName, mcmlNode, bindingContext, _parent, left, top, width, height, parentLayout, css)
    --local isdeepbg = mcmlNode:GetBool("isdeepbg");
	local w = mcmlNode:GetNumber("width") or (width-left);
	local default_height = mcmlNode:GetNumber("height")
	local h = default_height or (height-top);
	local title = mcmlNode:GetAttribute("title_text") or mcmlNode:GetAttributeWithCode("title", nil, true);
	local icon = mcmlNode:GetString("icon") or ""; --32 32
	local background = mcmlNode:GetString("background") or "";
	
	local title_height = mcmlNode:GetNumber("title_height") or 45;
	
	local _this = ParaUI.CreateUIObject("container", "c", "_lt", left, top, w, h);
	_this.background = center_mc_window_bg;
	_parent:AddChild(_this);
	_parent = _this;
	local _parent_window = _this;

	
	_this = ParaUI.CreateUIObject("text", "window_title_text", "_lt", 0, 2, w, title_height);
	_this.enabled = false;
	_this.text = title;
	_this.background = "";
	-- if(title_height >= 32) then
	-- 	if (mcmlNode:GetNumber("close_height")) then
	-- 		_this.font = "System;14;bold";
	-- 	else
	-- 		_this.font = "System;20;bold";
	-- 	end
	-- else
	-- 	_this.font = "System;14;bold";
	-- end
	_this.font = "System;33.6;bold";
	_guihelper.SetUIFontFormat(_this, 36)
	_guihelper.SetButtonFontColor(_this, "#262014", "#262014");
	local x = _this:GetTextLineSize();
	_this.x = (w - x) / 2;
	_this.y = (title_height - 48) / 2;
	_parent:AddChild(_this);
	
	local onclose = mcmlNode:GetString("onclose");
	if(onclose and onclose ~= "")then
		local btn_size = mcmlNode:GetNumber("close_height") or 26.4
			_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -(btn_size / 2) - btn_size, (title_height-btn_size) / 2, btn_size, btn_size)
		-- if (mcmlNode:GetNumber("close_height")) then
		-- 	local btn_size = mcmlNode:GetNumber("close_height")
		-- 	_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -(btn_size / 2) - btn_size, (title_height-btn_size) / 2, btn_size, btn_size)
		-- else
		-- 	--local btn_size = title_height - 2
		-- 	local btn_size = 26
		-- 	if(title_height>=32) then
		-- 		_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -btn_size-8, (title_height - btn_size) / 2, btn_size, btn_size);	
		-- 	else
		-- 		_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -btn_size-1, 1, btn_size, btn_size);	
		-- 	end
		-- end
		
		_this.background = mc_close_btn_bg;
		_parent:AddChild(_this);

		if(title_height>=32) then
			_this.enabled = false;
			_guihelper.SetUIColor(_this, "#ffffffff");
			_parent:AddChild(_this);
			-- the actual touchable area is 2 times bigger, to make it easier to click on some touch device. 
			_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -title_height*2, 0, title_height*2, title_height);
			_this.background = "";
			_parent:AddChild(_this);
		end

		_this:SetScript("onclick", function()
			Map3DSystem.mcml_controls.OnPageEvent(mcmlNode, onclose, buttonName, mcmlNode)
		end);
	end

	if (not(css['showline'])) then
		_this = ParaUI.CreateUIObject("container", "mc_panel_line", "_lt", 1, title_height, w-2, 1);
		_this.background = mc_line;
		_parent:AddChild(_this);
	end

	local parent_width, parent_height = w - 2, h - title_height + 4;
	_this = ParaUI.CreateUIObject("container", "childnode", "_fi", 5, title_height, 7, 7);
	_this.background="";
	_parent:AddChild(_this);
	_parent = _this;

	local myLayout = parentLayout:new_child();
	myLayout:reset(0, 0, parent_width, parent_height);
	myLayout:ResetUsedSize();
	mcmlNode:DrawChildBlocks_Callback(rootName, bindingContext, _parent, 0, 0, parent_width, parent_height, myLayout, css);

	-- if height is not specified, we will use auto-sizing. 
	if(not default_height) then
		local used_width, used_height = myLayout:GetUsedSize();
		if(used_height < parent_height) then
			_parent_window.height = h - (parent_height-used_height);
		end
	end
end