local UserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfoPage")

local page;

function UserInfoPage.OnInit()
	UserInfoPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function UserInfoPage.OneTimeInit()
	if(UserInfoPage.is_inited) then
		return;
	end
	UserInfoPage.is_inited = true;
end

-- clicked a block
function UserInfoPage.OnClickBlock(block_id)
end

function UserInfoPage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    UserInfoPage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/GUI/UserInfo.html", 
        name = "UserInfo.ShowPage", 
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