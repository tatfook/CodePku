local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local AntiStuckPage = commonlib.gettable("Mod.CodePku.AntiStuckPage");


function AntiStuckPage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/GUI/AntiStuck.html", 
        name = "AntiStuck.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = -1,
        directPosition = true,
        alignment = "_ct",
        x = -500,
        y = -300,
        width = 1000,
        height = 600,
        };
    local window = AdaptWindow:QuickWindow(params)
end