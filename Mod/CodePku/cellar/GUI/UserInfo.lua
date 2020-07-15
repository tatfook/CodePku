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
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    UserInfoPage.bForceHide = bShow == false;
    UserInfoPage.PageIndex = PageIndex
    

    UserInfoPage.GetUserInfo()

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
    -- ParaUI.SetMinimumScreenSize(1920,1080,true);
end