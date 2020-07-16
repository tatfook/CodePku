NPL.load("(gl)script/ide/System/Scene/Viewports/ViewportManager.lua");
local ViewportManager = commonlib.gettable("System.Scene.Viewports.ViewportManager");
local viewport = ViewportManager:GetSceneViewport();

NPL.load("(gl)script/apps/Aries/Creator/Game/Code/CodeWindow.lua");
local AdaptWindow = commonlib.inherit(commonlib.gettable("MyCompany.Aries.Game.Code.CodeWindow"), commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow"));


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
    });
    window:SetMinimumScreenSize(1920,1080);

    return window
end


-- for quick load
-- NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
-- local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")