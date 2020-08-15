--[[
Title: aries window for mcml2 element
Author(s): Maggie
Date: 
Desc: it create parent child relationship
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/MainStore/MainStore.lua");
------------------------------------------------------------
]]

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local MainStorePage = NPL.export()


function MainStorePage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/GUI/MainStore/MainStore.html", 
        name = "MainStore.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = -1,
        directPosition = true,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end