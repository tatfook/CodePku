local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local CompeteEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.CompeteEntrencePage");

function CompeteEntrencePage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/CompeteEntrence.html", 
        name = "CompeteEntrence.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        directPosition = true,
        align = "_ct",
        x = 0,
        y = 0,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end