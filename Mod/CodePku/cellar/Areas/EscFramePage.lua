local EscFramePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.EscFramePage");

local CodePkuEscFramePage = NPL.export()

function CodePkuEscFramePage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
            
    local bActivateMenu = true;
    if(bShow ~= false) then
        if(page and page:IsVisible()) then
            bActivateMenu = false;
        end
        DesktopMenuPage.ActivateMenu(bActivateMenu);
    end
    EscFramePage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/Areas/EscFramePage.html", 
        name = "EscFramePage.ShowPage", 
        isShowTitleBar = false,
        DestroyOnClose = true,
        bToggleShowHide=true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = -1,
        app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
        directPosition = true,
            align = "_ct",
            x = -600/2,
            y = -374/2,
            width = 600,
            height = 374,
        };
    System.App.Commands.Call("File.MCMLWindowFrame", params);
    if(bShow ~= false) then
        params._page.OnClose = function()
            if(not EscFramePage.bForceHide) then
                DesktopMenuPage.ActivateMenu(false);
            end
        end;
    end
end