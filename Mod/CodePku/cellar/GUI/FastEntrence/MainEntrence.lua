local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local MainEntrencePage = commonlib.gettable("Mod.CodePku.MainEntrencePage");

MainEntrencePage.nowPage = nil

function MainEntrencePage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/MainEntrence.html", 
        name = "MainEntrence.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        click_through = false, 
        zorder = 20,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
        MainEntrencePage.nowPage = AdaptWindow:QuickWindow(params)
end

function MainEntrencePage:ClosePage()
    if MainEntrencePage.nowPage ~= nil then
        MainEntrencePage.nowPage:CloseWindow()
    end
end