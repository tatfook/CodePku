local MainEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.MainEntrencePage");

local page;

function MainEntrencePage.OnInit()
	MainEntrencePage.OneTimeInit();
	page = document:GetPageCtrl();
end

function MainEntrencePage.OneTimeInit()
	if(MainEntrencePage.is_inited) then
		return;
	end
	MainEntrencePage.is_inited = true;
end

-- clicked a block
function MainEntrencePage.OnClickBlock(block_id)
end

function MainEntrencePage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    local countdown = 10;
    MainEntrencePage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/MainEntrence.html", 
        name = "MainEntrence.ShowPage", 
        isShowTitleBar = false,
        DestroyOnClose = true,
        bToggleShowHide=true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
        directPosition = true,
            align = "_ct",
            x = -1920/2,
            y = -1080/2,
            width = 1920,
            height = 1080,
        };
    System.App.Commands.Call("File.MCMLWindowFrame", params);
    ParaUI.SetMinimumScreenSize(1920,1080,true);
end