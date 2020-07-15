local SharePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SharePage")

local page;

function SharePage.OnInit()
	SharePage.OneTimeInit();
	page = document:GetPageCtrl();
end

function SharePage.OneTimeInit()
	if(SharePage.is_inited) then
		return;
	end
	SharePage.is_inited = true;
end

-- clicked a block
function SharePage.OnClickBlock(block_id)
end

function SharePage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    SharePage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/GUI/Share.html", 
        name = "SharePage.ShowPage", 
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
    -- ParaUI.SetMinimumScreenSize(1920,1080,true);
end