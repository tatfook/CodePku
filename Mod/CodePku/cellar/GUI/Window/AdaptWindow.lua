NPL.load("(gl)script/ide/System/Scene/Viewports/ViewportManager.lua");
local ViewportManager = commonlib.gettable("System.Scene.Viewports.ViewportManager");
local viewport = ViewportManager:GetSceneViewport();

NPL.load("(gl)script/apps/Aries/Creator/Game/Code/CodeWindow.lua");
local AdaptWindow = commonlib.inherit(commonlib.gettable("MyCompany.Aries.Game.Code.CodeWindow"), commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow"));

-- params example
-- params = {
--      url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog.html", 
--      alignment="_lb", left = 0, top = -350, width = 400, height = 350,
-- }

function AdaptWindow:OnViewportSizeChange()
	if(self.minScreenWidth and self.minScreenHeight) then
		local nativeWnd = self:GetNativeWindow();
		if(nativeWnd) then
			local parent = nativeWnd.parent
			if(not parent:IsValid()) then
				parent = ParaUI.GetUIObject("root");
			end
			local x, y, width, height = parent:GetAbsPosition();
			local scalingWidth, scalingHeight = 1, 1;
			if(width < self.minScreenWidth) then
				scalingWidth = width / self.minScreenWidth;
			end
			if(height < self.minScreenHeight) then
				scalingHeight = height / self.minScreenHeight;
			end
			-- local scaling = math.min(scalingWidth, scalingHeight);
			self:SetUIScaling(scalingWidth, scalingHeight);

			if(self.showParams) then
				local params = self.showParams;
				local left, top, width, height, alignment = params.left, params.top, params.width, params.height, params.alignment or "_lt";
				echo(string.format('width:  %s  height:  %s', width, height))
				self:SetAlignment(alignment);
				nativeWnd:Reposition(alignment, math.floor(left * scalingWidth+0.5), math.floor(top * scalingHeight + 0.5), math.floor(width * scalingWidth + 0.5), math.floor(height * scalingHeight+0.5));

				local x, y, width, height = nativeWnd:GetAbsPosition();
				width, height = math.floor(width/scalingWidth + 0.5), math.floor(height/scalingHeight + 0.5)
				self:setGeometry(self.screen_x, self.screen_y, width, height);
			end
		end
	end
end

-- function AdaptWindow:SetUIScaling(widthScale, heightScale)
-- 	scale = widthScale or 1;
-- 	self.uiScaling = scale;
-- 	if(scale == 1) then
-- 		self.transform = nil
-- 	else
-- 		self.transform = self.transform or {};
-- 		self.transform.scale = {widthScale, heightScale};
-- 	end
-- end

function AdaptWindow:QuickWindow(params)
    local window = AdaptWindow:new();
    window:Show({
        url=params.url, 
        alignment=params.alignment, 
        left = params.x or params.left, 
        top =  params.y or params.top, 
        width = params.width, 
        height = params.height, 
        parent = viewport:GetUIObject(true),

        zorder=params.zorder or 1, 
        allowDrag=params.allowDrag or false, 

        click_through=params.click_through or false,
        -- can add more
    });
    window:SetMinimumScreenSize(1920,1080);


    return window
end


-- for quick load
-- NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
-- local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")