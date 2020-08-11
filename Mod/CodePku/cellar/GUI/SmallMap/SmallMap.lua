NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local SmallMap = commonlib.gettable("Mod.CodePku.GUI.SmallMap")


SmallMap.page = nil


SmallMap.home = {
    topic = {name = "专题教学", id = 15857},
    system = {name = "体系教学", id = 15855},
    building = {name = "我的家园", id = 14293},
    compete = {name = "竞技乐园", id = 14312},
    main = {name = "入口世界", id = 1}
}

SmallMap.tieiei = "112121"

SmallMap.aaaa = "324353"

SmallMap.params={
    SmallMapPage = {
        url="Mod/CodePku/cellar/GUI/SmallMap/SmallMap.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    }
}


function SmallMap:ShowPage()

    if SmallMap.page ~= nil then
        SmallMap.page:CloseWindow()
    end
    SmallMap.page = AdaptWindow:QuickWindow(SmallMap.params["SmallMapPage"])
end

function SmallMap:ClosePage()
    if SmallMap.page ~= nil then
        SmallMap.page:CloseWindow()
    end
end