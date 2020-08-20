
local SignInPage = commonlib.gettable("Mod.CodePku.GUI.SignInPage")

function SignInPage:ShowPage(bShow)
    
    if SignInPage.ui ~= nil then
        SignInPage.ui:CloseWindow()
    end
    SignInPage.bForceHide = bShow == false;
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/SignIn/SignInPage.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21})
    
end