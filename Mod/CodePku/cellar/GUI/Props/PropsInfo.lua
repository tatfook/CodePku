local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

local PropsInfoPage = NPL.export();

-- 获取道具 prop_id 道具id prop_num 道具数量
function PropsInfoPage:GetProp(prop_id, prop_num)
    data = {
        prop_id=prop_id,
        prop_num=prop_num,
    }
    response = request:post('/user-props/pick', data, {sync=true})
    return response.data.message
end

-- 处理道具效果
function PropsInfoPage:DealPropEffect(prop, closeWindows)
    -- todoWanglj effectTable接口
    local effectTable = {
        [1]={effect=1, effectType=101, value=15855},
        [2]={effect=2, effectType=101, value=15857},
        [3]={effect=3, effectType=101, value=14312},
        [4]={effect=4, effectType=101, value=14293},
    }

    if closeWindows then
        for _,v in pairs(closeWindows) do
            if v then v:CloseWindow() end
        end
    end

    for _,v in pairs(prop.effects) do 
        -- todoWanglj 不同类型处理方式不同
        if effectTable[v.effect_id]['effectType'] == 101 then
            local cmdLine = format('/loadworld %d', effectTable[v.effect_id]['value'])
            GameLogic.RunCommand(cmdLine)
            break
        end
    end
end

-- 使用道具 prop 道具table user_num 道具数量
function PropsInfoPage:UseProp(user_num, closeWindows)
    data = {
        user_prop_id=PropsInfoPage.props.user_prop_id,
        user_num=user_num,
    }
    -- todo 提交使用
    -- response = request:put('/user-props/use', data, {sync=true})
    PropsInfoPage:DealPropEffect(PropsInfoPage.props, closeWindows)
end

-- 丢弃道具 user_prop_id 背包道具id drop_num 道具数量
function PropsInfoPage:DropProp(user_prop_id, drop_num)
    data = {
        user_prop_id=user_prop_id,
        drop_num=drop_num,
    }
    response = request:put('/user-props/drop', data, {sync=true})
    return response.data.message
end

function PropsInfoPage:ShowPage(props, bShow)
    PropsInfoPage.props = props
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