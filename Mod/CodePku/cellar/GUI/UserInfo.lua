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

--字符串切割
function split(str, split_char)      
    local sub_str_tab = {}
    while true do          
        local pos = string.find(str, split_char) 
        if not pos then              
            table.insert(sub_str_tab,str)
            break
        end  
        local sub_str = string.sub(str, 1, pos - 1)              
        table.insert(sub_str_tab,sub_str)
        str = string.sub(str, pos + 1, string.len(str))
    end      
 
    return sub_str_tab
end

-- 获取用户信息
function UserInfoPage.GetUserInfo()
    response = request:get('/users/profile',nil,{sync = true})
    if response.status == 200 then
        data = response.data.data
        UserInfo.name = data.nickname or data.mobile
        UserInfo.id = data.id
        UserInfo.gender = data.gender
        local _, _, y, m, d, _hour, _min, _sec = string.find(data.created_at, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)");
        UserInfo.created_at = y..'-'..m..'-'..d
        if data.self_level == nil then
            UserInfo.self_level = {}
            UserInfo.self_level.current_exp = 0
            UserInfo.self_level.current_level = 0
            UserInfo.self_level.next_exp = 0
        else
            UserInfo.self_level = data.self_level
        end
        UserInfo.avatar = data.avatar_url
        UserInfo.day = data.career
        echo(UserInfo.avatar)
    end
end

function UserInfoPage:ShowPage(PageIndex,bShow)
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    UserInfoPage.bForceHide = bShow == false;
    UserInfoPage.PageIndex = PageIndex
    UserInfoPage.GetUserInfo()
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/UserInfo.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20})
end