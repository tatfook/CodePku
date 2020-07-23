NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local PropsInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.PropsInfo");
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");

-- 获取道具 prop_id 道具id prop_num 道具数量
function PropsInfo:GetProp(prop_id, prop_num)
    data = {
        prop_id=prop_id,
        prop_num=prop_num,
    }
    response = request:post('/user-props/pick', data, {sync=true})
    return response.data.message
end

-- 使用道具 user_prop_id 背包道具id user_num 道具数量
function PropsInfo:UseProp(user_prop_id, user_num)
    data = {
        user_prop_id=user_prop_id,
        user_num=user_num,
    }
    response = request:put('/user-props/use', data, {sync=true})
    return response.data.message
end

-- 丢弃道具 user_prop_id 背包道具id drop_num 道具数量
function PropsInfo:DropProp(user_prop_id, drop_num)
    data = {
        user_prop_id=user_prop_id,
        drop_num=drop_num,
    }
    response = request:put('/user-props/drop', data, {sync=true})
    return response.data.message
end

function PropsInfo:ShowPage(props, bShow)
    PropsInfo.props = props
    local params = {
        url = "Mod/CodePku/cellar/GUI/Props/PropsInfo.html", 
        name = "PropsInfo.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 30,
        directPosition = true,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end