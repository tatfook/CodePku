NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local MainEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.MainEntrencePage");

function MainEntrencePage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/MainEntrence.html", 
        name = "MainEntrence.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        click_through = false, 
        zorder = 20,
        align = "_ct",
        x = 0,
        y = 0,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end