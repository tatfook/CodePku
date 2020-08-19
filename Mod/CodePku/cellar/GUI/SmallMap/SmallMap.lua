local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local SmallMap = commonlib.gettable("Mod.CodePku.GUI.SmallMap")


SmallMap.page = nil


SmallMap.home = {
    system = {name = "教学区", id = 15855},
    topic = {name = "专题区", id = 15857},
    building = {name = "家园区", id = 14293},
    compete = {name = "竞技区", id = 14312},
    main = {name = "玩学大厅-大门", id = 1}
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