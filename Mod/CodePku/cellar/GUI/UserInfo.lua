local UserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfoPage")
local UserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfo")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
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
        UserInfo.name = data.nickname or data.no
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

        wallets = data.user_wallets
        echo(string.format( "wallets: %s,  length:  %d", wallets, #wallets))
        UserInfo.money = {goldcoin=0, wanxuecoin=0}
        for i, v in ipairs(wallets) do 
            if v.currency_id == 1 then
                UserInfo.money.goldcoin = v.amount
            elseif v.currency_id == 2 then
                UserInfo.money.wanxuecoin = v.amount
            end
        end
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