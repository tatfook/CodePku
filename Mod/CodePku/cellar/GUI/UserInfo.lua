--[[
local UserInfoPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/UserInfo.lua");
--]]

local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local page;
local UserInfoPage = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")
local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")

UserInfoPage.tab_ds_index = 1;
UserInfoPage.tab_ds_name = "Home";
UserInfoPage.mainasset = nil;


function UserInfoPage.getHuaweiNav()
    local huaweiApprovalStatus = Mod.CodePku.BasicConfigTable.huawei_approval_status == 'on'  
    local isHuawei = ParaEngine.GetAppCommandLineByParam("app_market", "") == 'huawei';
    local flymeApprovalStatus = Mod.CodePku.BasicConfigTable.flyme_approval_status == 'on'  
    local isFlyMe = ParaEngine.GetAppCommandLineByParam("app_market", "") == 'flyme';
    local sogouApprovalStatus = Mod.CodePku.BasicConfigTable.sogou_approval_status == 'on'  
    local isSoGou = ParaEngine.GetAppCommandLineByParam("app_market", "") == 'sogou';

    if (huaweiApprovalStatus and isHuawei) or (flymeApprovalStatus and isFlyMe) or (sogouApprovalStatus and isSoGou) then
        --华为渠道
        return {
            {text=L"首页", name="Home"},
        }
    else 
        -- 正常渠道
        return {
            {text=L"首页", name="Home"},
            {text=L"属性", name="Profile"},
            -- {text=L"角色", name="Model"},
            -- {text=L"外观", name="Skin"},
            -- {text=L"背包", name="Backpack"},
            -- {text=L"成就", name="Achievement"},
            -- {text=L"动态", name="Activity"},
        }
    end
    
end

-- tabs - 自己
UserInfoPage.tab_ds_self = UserInfoPage.getHuaweiNav()

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
        UserInfoPage.props = r_data
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

function UserInfoPage:ShowPage(PageIndex, bShow, id, mainasset)
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
    -- UserInfoPage.GetItemInfo(); -- 获取背包内容，目前没用到，同步需改异步
    UserInfoPage.mainasset = mainasset; -- 获取他人角色asset path
end

function UserInfoPage:InitWindow()
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/UserInfo.html", 
    alignment="_fi", left = 0, top = 0, width = 0, height = 0,zorder =20
})
end


-- 获取图片
-- @params:type|int 1代表通用,2代表修改昵称
function UserInfoPage:GetIcon(type, index)
    if type == 1 then
        return common1ImageData:GetIconUrl(index)
    elseif type == 2 then
        return escFrameImageData:GetIconUrl(index)
    end
end

-- 用户设置弹窗
function UserInfoPage:ShowSettingPopup()
    local params = {
        url="Mod/CodePku/cellar/GUI/Profile/UserSetting.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    };
    UserInfoPage.ShowSettingPopupUI = AdaptWindow:QuickWindow(params)
end