local RankPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.RankPage");

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

    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/FastEntrence/RankPage.html", 
    alignment="_ct", left = -848, top = -451, width = 1696, height = 903,zorder =20})
end