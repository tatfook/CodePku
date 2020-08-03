NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local MainPopup = commonlib.gettable("Mod.CodePku.GUI.MainPopup")


MainPopup.popui = nil

MainPopup.TP_Location = nil

MainPopup.params={
    TPpopup = {
        url="Mod/CodePku/cellar/GUI/MainPopup/TPpopup.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    }
}


function MainPopup:ShowPage(toWhere)
    
    if MainPopup.popui ~= nil then
        MainPopup.popui:CloseWindow()
    end

    MyLocation = tostring(toWhere)

    MainPopup.TP_Location = MyLocation
    MainPopup.popui = AdaptWindow:QuickWindow(MainPopup.params["TPpopup"])

end