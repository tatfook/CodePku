local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local page;
local UserInfoPage = NPL.export();

UserInfoPage.tab_ds_index = 1;
UserInfoPage.tab_ds_name = "Home";
UserInfoPage.categoryIndex = 1
UserInfoPage.ifItemList = true


-- tabs - 自己
UserInfoPage.tab_ds_self = {
    {text=L"首页", name="Home"},
    {text=L"属性", name="Profile"},
    -- {text=L"角色", name="Model"},
    -- {text=L"外观", name="Skin"},
    {text=L"背包", name="Backpack"},
    -- {text=L"成就", name="Achievement"},
    -- {text=L"动态", name="Activity"},
};

-- tabs - 他人
UserInfoPage.tab_ds_other = {
    {text=L"首页", name="Home"},
    -- {text=L"成就", name="Achievement"},
    -- {text=L"动态", name="Activity"},
};

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

-- 获取用户信息 async
function UserInfoPage.GetUserInfo(id, show)
    local path = '/users/profile';
    if (id and id ~= "") then
        path = path.."/"..id;
    end
    request:get(path):next(function(response)
        if (response.status == 200) then
            local data = response.data.data;
            UserInfoPage.name = data.nickname or data.no
            UserInfoPage.id = data.id
            UserInfoPage.no = data.no
            UserInfoPage.gender = data.gender
            UserInfoPage.avatar = data.avatar_url
            local _, _, y, m, d, _hour, _min, _sec = string.find(data.created_at, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)");
            UserInfoPage.created_at = y..'-'..m..'-'..d
            if data.self_level == nil then
                UserInfoPage.self_level = {}
                UserInfoPage.self_level.current_exp = 0
                UserInfoPage.self_level.current_level = 1
                UserInfoPage.self_level.next_exp = 0
            else
                UserInfoPage.self_level = data.self_level
            end
            UserInfoPage.day = data.career
            wallets = data.user_wallets or {}
            echo(string.format( "wallets: %s,  length:  %d", wallets, #wallets))
            UserInfoPage.money = {goldcoin=0, wanxuecoin=0}
            for i, v in ipairs(wallets) do
                if v.currency_id == 1 then
                    UserInfoPage.money.goldcoin = v.amount
                elseif v.currency_id == 2 then
                    UserInfoPage.money.wanxuecoin = v.amount
                end
            end
            if (show and show ~= "") then
                UserInfoPage:InitWindow()
            end
        end
    end):catch(function(e)
        echo("ERROR: catched at SubjectPage.GetUserInfo")
        echo(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message or L"获取用户信息失败", 3000, "#00FF00");
        if (show and show ~= "") then
            UserInfoPage:InitWindow()
        end
    end);
end

-- 道具分类
function UserInfoPage:Classify(data)
    local classifiedData = {}
    for _,v in pairs(data) do
        if classifiedData[v.prop_category_id] == nil then
            classifiedData[v.prop_category_id] = {v}
        else
            table.insert(classifiedData[v.prop_category_id], v)
        end
    end
    return classifiedData
end

-- 获取道具信息
function UserInfoPage.GetItemInfo(params)
    response = request:get("/user-props/backpack", params, {sync=true})
    if response.data.code == 200 then
        local r_props = response.data.data

        for i, v in ipairs(r_props) do
            v.index = i
        end
        UserInfoPage.propsAll = r_props
        UserInfoPage.props = UserInfoPage:Classify(r_props)
    end

    response = request:get("/user-props/categories", nil, {sync=true})
    UserInfoPage.PropsCategories = {{id=1,category_name='全部'}}
    if response.data.code == 200 then
        local PropsCategories = response.data.data
        table.insert(PropsCategories, 1, {id=1, category_name='全部'})
        UserInfoPage.PropsCategories = PropsCategories
    end
end

--填充背包空格子
function UserInfoPage:FillBlankCells(sourceProps)
    local blankCells = 0
    local newProps = commonlib.copy(sourceProps)
    if #newProps < 16 then
        -- 小于16个补充到16格
        blankCells = 16 - #newProps
    else
        -- 大于16个补充到整行
        blankCells = 4 - #newProps % 4
    end

    for i=1,blankCells do
        table.insert(newProps, {blank=true})
    end
    return newProps
end


function UserInfoPage:ShowPage(PageIndex, bShow, id)
    if (id and id ~= "") then
        UserInfoPage.isSelf = false;
        UserInfoPage.tab_ds_name = UserInfoPage.tab_ds_other[PageIndex or 1].name;
    else
        UserInfoPage.isSelf = true;
        UserInfoPage.tab_ds_name = UserInfoPage.tab_ds_self[PageIndex or 1].name;
    end
    UserInfoPage.bForceHide = bShow == false;
    UserInfoPage.tab_ds_index = PageIndex or 1;
    UserInfoPage.GetUserInfo(id, true);
    UserInfoPage.GetItemInfo();
end

function UserInfoPage:InitWindow()
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/UserInfo.html", 
    alignment="_fi", left = 0, top = 0, width = 0, height = 0,zorder =20
})
end