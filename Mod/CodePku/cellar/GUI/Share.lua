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
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    SharePage.bForceHide = bShow == false;
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url = "Mod/CodePku/cellar/GUI/Share.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30})
end
        
