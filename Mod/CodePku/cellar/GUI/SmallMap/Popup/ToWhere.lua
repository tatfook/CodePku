NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local ToWhere = commonlib.gettable("Mod.CodePku.GUI.Popup.ToWhere")


ToWhere.popui = nil
ToWhere.ToWhereName = nil
ToWhere.ToWhereId = nil

ToWhere.params={
    ToWherePage = {
        url="Mod/CodePku/cellar/GUI/SmallMap/Popup/ToWhere.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    }
}


function ToWhere:ShowPage(name, id)
    
    if ToWhere.popui ~= nil then
        ToWhere.popui:CloseWindow()
    end

    ToWhere.ToWhereName = tostring(name)
    ToWhere.ToWhereId = tonumber(id)

    ToWhere.popui = AdaptWindow:QuickWindow(ToWhere.params["ToWherePage"])
end