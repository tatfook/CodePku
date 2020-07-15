local AntiStuckPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.AntiStuckPage");

local page;

function AntiStuckPage.OnInit()
	AntiStuckPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function AntiStuckPage.OneTimeInit()
	if(AntiStuckPage.is_inited) then
		return;
	end
	AntiStuckPage.is_inited = true;
end

-- clicked a block
function AntiStuckPage.OnClickBlock(block_id)
end

function AntiStuckPage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    local countdown = 10;
    AntiStuckPage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/GUI/AntiStuck.html", 
        name = "AntiStuck.ShowPage", 
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
            x = -1000/2,
            y = -600/2,
            width = 1000,
            height = 600,
        };
    System.App.Commands.Call("File.MCMLWindowFrame", params);
end