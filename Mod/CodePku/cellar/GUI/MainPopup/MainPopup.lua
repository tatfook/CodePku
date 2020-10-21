local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local MainPopup = commonlib.gettable("Mod.CodePku.GUI.MainPopup")


MainPopup.popui = nil

MainPopup.TP_Location = nil
MainPopup.LocationId = nil

MainPopup.params={
    TPpopup = {
        url="Mod/CodePku/cellar/GUI/MainPopup/TPpopup.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =31
    },
    AntiJam = {
        url="Mod/CodePku/cellar/GUI/MainPopup/AntiJam.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    }
}


function MainPopup:ShowPage(pageName, name, id)
    
    if MainPopup.popui ~= nil then
        MainPopup.popui:CloseWindow()
    end

    if name ~= nil then
        MyLocation = tostring(name)
        MainPopup.TP_Location = MyLocation
    else
        MainPopup.TP_Location = nil
    end

    if id ~= nil then
        Locationid = tonumber(id)
        MainPopup.LocationId = Locationid
    else
        MainPopup.LocationId = nil
    end

    ToPage = tostring(pageName)

    MainPopup.popui = AdaptWindow:QuickWindow(MainPopup.params[ToPage])
end