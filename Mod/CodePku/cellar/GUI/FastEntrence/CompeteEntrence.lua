NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local CompeteEntrencePage = commonlib.gettable("Mod.CodePku.CompeteEntrencePage");

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
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end