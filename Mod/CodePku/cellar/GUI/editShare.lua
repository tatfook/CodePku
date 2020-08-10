local EditPage = commonlib.gettable("Mod.CodePku.EditPage")
local myWord = commonlib.gettable("Mod.CodePku.myWord")

local page;

function EditPage.OnInit()
	EditPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function EditPage.OneTimeInit()
	if(EditPage.is_inited) then
		return;
	end
	EditPage.is_inited = true;
end

-- clicked a block
function EditPage.OnClickBlock(block_id)
end

function EditPage.GetWord()
    myWord.jiyu = "小鸟伏特加整这高"
end

function EditPage:ShowPage(bShow)
    EditPage.GetWord();

    -- EditPage.bForceHide = bShow == false;
    -- NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    -- local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    -- AdaptWindow:QuickWindow({url = "Mod/CodePku/cellar/GUI/editShare.html", 
    -- alignment="_ct", left = -511.5, top = -274.5, width = 1023, height = 549,zorder =30})
    
    NPL.load("(gl)script/ide/System/Windows/Window.lua");
	local Window = commonlib.gettable("System.Windows.Window");
    local window = Window:new();
    window:Show({
		url="Mod/CodePku/cellar/GUI/editShare.html", 
		alignment="_ct", left = -1158/2, top = -588/2, width = 1158 , height = 588, zorder = 30
    });
    window:SetMinimumScreenSize(1920, 1080);
end