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

-- 获取道具信息
function UserInfoPage.GetItemInfo(params)
    params = params or ''
    response = request:get(string.format( "/user-props/backpack%s", params), nil, {sync=true})
    if response.data.code == 200 then
        r_data = response.data.data
        for i, v in ipairs(r_data) do
            -- echo(string.format( "user_prop_id: %d  data : %s, category: %d", v.user_prop_id, v.prop_name, v.prop_id))
            v.index = i
        end
        UserInfo.props = r_data
        return r_data
    end
    
    -- data = {}
    -- -- 拆分堆叠道具
    -- for i, v in ipairs(response) do
    --     if v.num ~= v.max_stacked then -- 拆分堆叠数，1表示不拆分
    --         stack = math.floor(v.num/ v.max_stacked) + 1
    --     else
    --         stack = 1
    --     end
    --     l = commonlib.deepcopy(response[i])
    --     s = 1
    --     while s < stack do
    --         l.num = v.max_stacked
    --         table.insert(data, l)
    --         s = s + 1
    --     end
    --     if stack > 1 and v.num % v.max_stacked ~= 0 then
    --         v.num = v.num % v.max_stacked
    --         table.insert(data, v)
    --     elseif stack == 1 then
    --         table.insert(data, v)
    --     end
        
    -- end
    -- return data
end

function UserInfoPage:ShowPage(PageIndex,bShow)
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    UserInfoPage.bForceHide = bShow == false;
    UserInfoPage.PageIndex = PageIndex
    UserInfoPage.GetUserInfo()
    UserInfoPage.GetItemInfo()
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/UserInfo.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20})
end