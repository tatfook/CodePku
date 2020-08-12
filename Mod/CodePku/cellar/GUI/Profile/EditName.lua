local EditNamePage = commonlib.gettable("Mod.CodePku.EditNamePage")

local page;

function EditNamePage.OnInit()
	EditNamePage.OneTimeInit();
	page = document:GetPageCtrl();
end

function EditNamePage.OneTimeInit()
	if(EditNamePage.is_inited) then
		return;
	end
	EditNamePage.is_inited = true;
end

-- clicked a block
function EditNamePage.OnClickBlock(block_id)
end

function EditNamePage:ShowPage(bShow)
    echo("@@@@@@")
    -- EditNamePage.bForceHide = bShow == false;
    -- NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    -- local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    -- AdaptWindow:QuickWindow({url = "Mod/CodePku/cellar/GUI/EditName.html", 
    -- alignment="_ct", left = -511.5, top = -274.5, width = 1023, height = 549,zorder =30})
    
    NPL.load("(gl)script/ide/System/Windows/Window.lua");
	  local Window = commonlib.gettable("System.Windows.Window");
    local window = Window:new();
    window:Show({
		url="Mod/CodePku/cellar/GUI/Profile/EditName.html", 
		alignment="_ct", left = -1158/2, top = -588/2, width = 1158 , height = 588, zorder = 30
    });
    window:SetMinimumScreenSize(1920, 1080);
end