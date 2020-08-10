local codepku_pe_aries_window = NPL.export()

local mc_window_bg = "codepku/image/textures/modal/common_32bits.png#11 1105 980 380"; -- thin
local mc_window_bg_866_384 = "codepku/image/textures/modal/bag_box_32bits.png#74 75 1444 640"; -- 背包造型背景
local mc_window_bg_854 = "codepku/image/textures/modal/bag_box_32bits.png#66 2735 854 854"; -- 箱子背景
local center_mc_window_bg = "codepku/image/textures/modal/setting_v2_32bits.png;383 226 158 116: 53 82 44 30";
local mc_close_btn_bg = "codepku/image/textures/modal/common_32bits.png#27 906 64 64";
local mc_line = "codepku/image/textures/modal/bag_box_32bits.png#74 1767 962 2";
-- local mc_line = "Texture/Aries/Creator/Theme/GameCommonIcon_32bits.png;352 66 1 1";

-- Common small modal
local modal_bg = "codepku/image/textures/common_32bits.png#99 275 1158 588";
local modal_close_btn_bg = "codepku/image/textures/common_32bits.png#110 73 68 78";
local modal_title_bg = "codepku/image/textures/common_32bits.png#1265 363 434 115";

function codepku_pe_aries_window.create_modal(rootName, mcmlNode, bindingContext, _parent, left, top, width, height, parentLayout, css)
    --local isdeepbg = mcmlNode:GetBool("isdeepbg");
	local w = mcmlNode:GetNumber("width") or 1158 / 2;
	local default_height = mcmlNode:GetNumber("height") or 588 / 2;
	local h = default_height;
	local title = mcmlNode:GetAttribute("title_text") or mcmlNode:GetAttributeWithCode("title", nil, true);
	local icon = mcmlNode:GetString("icon") or modal_close_btn_bg; --32 32
	local background = mcmlNode:GetString("background") or modal_bg;
	
	local title_height = mcmlNode:GetNumber("title_height") or 87 / 2;
	
	local _this = ParaUI.CreateUIObject("container", "c", "_lt", left, top, w, h);
	_this.background = background;
	_parent:AddChild(_this);
	_parent = _this;
	local _parent_window = _this;

	
	_this = ParaUI.CreateUIObject("text", "window_title_text", "_lt", 0, 2, 400, title_height);
	_this.enabled = false;
	_this.text = title;
	_this.background = modal_title_bg;
	-- if(title_height >= 32) then
	-- 	if (mcmlNode:GetNumber("close_height")) then
	-- 		_this.font = "System;14;bold";
	-- 	else
	-- 		_this.font = "System;20;bold";
	-- 	end
	-- else
	-- 	_this.font = "System;14;bold";
	-- end
	_this.font = "Noto Sans S Chinese Regular;27;bold";
	-- _this.font = "Noto Sans S Chinese Regular;45;bold";
	_guihelper.SetUIFontFormat(_this, 36)
	_guihelper.SetButtonFontColor(_this, "#F46D3D", "#F46D3D");
	local x = _this:GetTextLineSize();
	_this.x = (w - x) / 2;
	_this.y = (title_height - 48) / 2;

	_parent:AddChild(_this);
	
	local onclose = mcmlNode:GetString("onclose");
	if(onclose and onclose ~= "")then
		local btn_size = mcmlNode:GetNumber("close_height") or 74 / 2
		_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -(btn_size / 2) - btn_size, (title_height-btn_size) / 2, btn_size, btn_size);
		_this.background = modal_close_btn_bg;
		_parent:AddChild(_this);

		-- if(title_height>=32) then
		-- 	_this.enabled = false;
		-- 	_guihelper.SetUIColor(_this, "#ffffffff");
		-- 	_parent:AddChild(_this);
		-- 	-- the actual touchable area is 2 times bigger, to make it easier to click on some touch device. 
		-- 	_this = ParaUI.CreateUIObject("button", "close_btn", "_rt", -title_height*2, 0, title_height*2, title_height);
		-- 	_this.background = "";
		-- 	_parent:AddChild(_this);
		-- end

		_this:SetScript("onclick", function()
			Map3DSystem.mcml_controls.OnPageEvent(mcmlNode, onclose, buttonName, mcmlNode)
		end);
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