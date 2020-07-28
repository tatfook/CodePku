RankPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.RankPage");

local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua")
local page;

function RankPage.OnInit()
	RankPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function RankPage.OneTimeInit()
	if(RankPage.is_inited) then
		return;
	end
	RankPage.is_inited = true;
end

-- clicked a block
function RankPage.OnClickBlock(block_id)
end

function RankPage:ShowPage(bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    local countdown = 10;
    RankPage.bForceHide = bShow == false;
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/RankPage.html", 
        name = "RankPage.ShowPage", 
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