--[[
Title: inventory
Author(s): LiPeng, LiXizhi
Date: 2013/10/15
Desc: 
Use Lib:
-------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/InventoryPage.lua");
local InventoryPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.InventoryPage");
InventoryPage.ShowPage(true)
-------------------------------------------------------
]]

local GameLogic = commonlib.gettable("MyCompany.Aries.Game.GameLogic")
local InventoryPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.InventoryPage");

local CodePkuInventoryPage = NPL.export()

function CodePkuInventoryPage.PageParams()
    return {
        url = "Mod/CodePku/cellar/Areas/InventoryPage.html", 
        name = "InventoryPage.ShowPage", 
        app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
        isShowTitleBar = false,
        DestroyOnClose = false,
        enable_esc_key = true,
        bToggleShowHide=true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        zorder = -3,
        allowDrag = true,
        click_through = true,
        directPosition = true,
            align = "_ct",
            x = -866/2,
            y = -384/2,
            width = 866,
            height = 384,
    };
end

