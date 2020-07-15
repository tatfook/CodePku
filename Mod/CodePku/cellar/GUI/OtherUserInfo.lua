local OtherUserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.OtherUserInfoPage")
local OtherUserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.OtherUserInfo")
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
local page;


function OtherUserInfoPage.OnInit()
	OtherUserInfoPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function OtherUserInfoPage.OneTimeInit()
	if(OtherUserInfoPage.is_inited) then
		return;
	end
	OtherUserInfoPage.is_inited = true;
end

-- clicked a block
function OtherUserInfoPage.OnClickBlock(block_id)
end

-- 获取用户信息
function  OtherUserInfoPage.GetUserInfo(id)
    response = request:get('/users/profile/' .. id,nil,{sync = true})
    if response.status == 200 then
        data = response.data.data
        OtherUserInfo.name = data.nickname or data.mobile
        OtherUserInfo.id = data.id
        OtherUserInfo.gender = data.gender
    end
end

function OtherUserInfoPage:ShowPage(id,bShow)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    OtherUserInfoPage.bForceHide = bShow == false;

    OtherUserInfoPage.GetUserInfo(id)

    local params = {
        url = "Mod/CodePku/cellar/GUI/OtherUserInfo.html", 
        name = "OtherUserInfoPage.ShowPage", 
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
    ParaUI.SetMinimumScreenSize(1920,1080,true);
end