local TopicEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.TopicEntrencePage");

local page;

function TopicEntrencePage.OnInit()
	TopicEntrencePage.OneTimeInit();
	page = document:GetPageCtrl();
end

function TopicEntrencePage.OneTimeInit()
	if(TopicEntrencePage.is_inited) then
		return;
	end
	TopicEntrencePage.is_inited = true;
end

-- clicked a block
function TopicEntrencePage.OnClickBlock(block_id)
end

function TopicEntrencePage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    local countdown = 10;
    TopicEntrencePage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/TopicEntrence.html", 
        name = "TopicEntrence.ShowPage", 
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
            x = -1920/2,
            y = -1080/2,
            width = 1920,
            height = 1080,
        };
    System.App.Commands.Call("File.MCMLWindowFrame", params);
end