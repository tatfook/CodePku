local UserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfoPage")
local UserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfo")
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
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

-- 获取用户信息
function UserInfoPage.GetUserInfo()
    response = request:get('/users/profile',nil,{sync = true})
    if response.status == 200 then
        data = response.data.data
        UserInfo.name = data.nickname or data.mobile
        UserInfo.id = data.id
        UserInfo.gender = data.gender
    end
end

function UserInfoPage:ShowPage(PageIndex,bShow)
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    UserInfoPage.bForceHide = bShow == false;
    UserInfoPage.PageIndex = PageIndex

    UserInfoPage.GetUserInfo()

    NPL.load("(gl)script/ide/System/Scene/Viewports/ViewportManager.lua");
    local ViewportManager = commonlib.gettable("System.Scene.Viewports.ViewportManager");
    local viewport = ViewportManager:GetSceneViewport();

    NPL.load("(gl)script/apps/Aries/Creator/Game/Code/CodeWindow.lua");
    local Window = commonlib.gettable("MyCompany.Aries.Game.Code.CodeWindow")
	local window = Window:new();
	window:Show({
		url="Mod/CodePku/cellar/GUI/UserInfo.html", 
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,
        parent = viewport:GetUIObject(true),
	});
    window:SetMinimumScreenSize(1920,1080);
end