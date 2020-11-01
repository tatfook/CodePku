RankPage = commonlib.gettable("Mod.CodePku.RankPage");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")

RankPage.ui = nil
RankPage.popui = nil
RankPage.pi = nil
RankPage.params={
    subject = {
        url="Mod/CodePku/cellar/GUI/rank/subject.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21
    },
    game = {
        url="Mod/CodePku/cellar/GUI/rank/game.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21
    },
    activity = {
        url="Mod/CodePku/cellar/GUI/rank/activity.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21
    }
}

RankPage.ShowActivityNavig = 0              -- 活动排行榜：0不显示，1显示

function RankPage.GetSubjectItem(id, range)
    local param = nil
    if range == 2 then
        param = '?friend=1'
    else
        param = ''
    end
    local list = {}
    local mylist = {}
    local response = request:get('/user-exps/ranks/'..id..param, nil,{sync = true})
    local data = response.data.data
    for i = 1, #data do
        if data[i].is_top_n then
            local l = {}
            l['name'] = data[i].user.nickname
            l['score'] = data[i].current_level..'级'
            l['rank'] = i
            table.insert(list, l)
        end
        if data[i].current_user == 1 then
            local l = {}
            l['name'] = data[i].user.nickname
            l['score'] = data[i].current_level..'级'
            if data[i].is_top_n then
                l['rank'] = i
            else
                l['rank'] = "未上榜"
            end
            table.insert(mylist, l)
        end
    end
    if #mylist == 0 or mylist == nil then
        -- local nickname = System.User.nickName
        -- local score = '1级'
        -- if System.User.info.self_level and System.User.info.self_level.current_level then
        --     score = System.User.info.self_level.current_level..'级'
        -- end
        table.insert(mylist, {name = "---", score = "---", rank = '未上榜'})
    end
    if response.data.code == 200 then
        return list, mylist
    end
end

function RankPage.GetGameItem(id, range)
    local param = nil
    if range == 2 then
        param = '&game_limited_time_rank_config_id=0&friend=1'
    else
        param = '&game_limited_time_rank_config_id=0'
    end
    local list = {}
    local mylist = {}
    
    --TODO 临时用game_id 图标暂用星星未换game.html:105
    local url = ''
    if id == "standtoend" then
        url = '/game-scores/ranks?game_id=273'..param
    else
        url = '/game-scores/ranks?game_name='..id..param
    end

    local response = request:get(url,nil,{sync = true})

    local data = response.data.data
    for i = 1, #data do
        if data[i].is_top_n then
            local l = {}
            l['name'] = data[i].user.nickname
            l['score'] = data[i].score
            l['rank'] = i
            l['game_id'] = data[i].game_id
            table.insert(list, l)
        end
        if data[i].current_user == 1 then
            local l = {}
            l['name'] = data[i].user.nickname
            l['score'] = data[i].score
            l['game_id'] = data[i].game_id
            if data[i].is_top_n then
                l['rank'] = i
            else
                l['rank'] = "未上榜"
            end
            table.insert(mylist, l)
        end
    end
    if #mylist == 0 or mylist == nil then
        -- local nickname = System.User.nickName
        -- local score = '1级'
        -- if System.User.info.self_level and System.User.info.self_level.current_level then
        --     score = System.User.info.self_level.current_level..'级'
        -- end
        table.insert(mylist, {name = '---', score = '---', rank = '未上榜'})
    end
    if response.data.code == 200 then
        return list, mylist
    end
end


--[[
-- 初始化活动排行榜列表,处理成如下格式
RankPage.activity_navig = {
    [1] = {title = "单词爱跑酷", name = "parkour", game_id = 22,},
    [2] = {title = "华夏游学记", name = "monopoly", game_id = 7,},
}
--]]
function RankPage.GetActivityLists()
    if not RankPage.activity_navig then
        RankPage.activity_navig = {}
        local path = '/game-scores/limited-time-lists'
        request:get(path):next(function(response)
            if (response.status == 200) then
                local data = response.data.data
                RankPage.ShowActivityNavig = 0
                for i=1,#data do
                    RankPage.activity_navig[i] = {title = data[i].activity_name, id = data[i].id, game_id = data[i].game_id, index = i}
                end
                if next(data) ~= nil then
                    RankPage.ShowActivityNavig = 1
                end
                if RankPage.ui then
                    RankPage.ui:Refresh(0)
                end
            end
        end):catch(function(e)
            echo("ERROR: catched at RankPage.GetActivityLists")
            echo(e)
            GameLogic.AddBBS("CodeGlobals", e.data.message or L"获取活动列表失败", 3000, "#00FF00");
            RankPage.ShowActivityNavig = 0
            if RankPage.ui then
                RankPage.ui:Refresh(0)
            end
        end);
    end
end

-- 获取指定活动排行榜数据
function RankPage.GetActivityItem(id, range, activity_id)
    local param = nil
    if range == 2 then
        param = '&friend=1'
    else
        param = ''
    end
    local game_id = tostring(id)
    local activity_id = tostring(activity_id)
    local path = string.format('/game-scores/ranks?game_id=%s&game_limited_time_rank_config_id=%s', game_id, activity_id)
    local list = {}
    local mylist = {}
    local response = request:get(path..param,nil,{sync = true})
    local data = response.data.data
    echo("game_id:")
    echo(game_id)
    echo("activity_id:")
    echo(activity_id)
    echo('data:')
    echo(data)
    echo('RankPage.activity_navig:')
    echo(RankPage.activity_navig)
    for i = 1, #data do
        if data[i].is_top_n then
            local l = {}
            l['name'] = data[i].user.nickname
            l['score'] = data[i].score
            l['rank'] = i
            table.insert(list, l)
        end
        if data[i].current_user == 1 then
            local l = {}
            l['name'] = data[i].user.nickname
            l['score'] = data[i].score
            if data[i].is_top_n then
                l['rank'] = i
            else
                l['rank'] = "未上榜"
            end
            table.insert(mylist, l)
        end
    end
    if #mylist == 0 or mylist == nil then
        -- local nickname = System.User.nickName
        -- local score = '1级'
        -- if System.User.info.self_level and System.User.info.self_level.current_level then
        --     score = System.User.info.self_level.current_level..'级'
        -- end
        table.insert(mylist, {name = '---', score = '---', rank = '未上榜'})
    end
    if response.data.code == 200 then
        return list, mylist
    end
end

function RankPage:ShowPage(PageIndex, bShow)
    RankPage.GetActivityLists()
    if RankPage.ui ~= nil then
        RankPage.ui:CloseWindow()
    end
    RankPage.bForceHide = bShow == false;
    RankPage.pi = PageIndex
    PageIndex = tonumber(PageIndex)
    if PageIndex == 1 then
        RankPage.userinfo, RankPage.myinfo = RankPage.GetSubjectItem(1, 1)
        RankPage.ui = AdaptWindow:QuickWindow(RankPage.params["subject"])
    elseif PageIndex == 2 then
        RankPage.userinfo, RankPage.myinfo = RankPage.GetGameItem("parkour", 1)
        RankPage.ui = AdaptWindow:QuickWindow(RankPage.params["game"])
    elseif PageIndex == 3 then
        RankPage.userinfo, RankPage.myinfo = RankPage.GetActivityItem(RankPage.activity_navig[1].game_id, 1, RankPage.activity_navig[1].id)
        RankPage.ui = AdaptWindow:QuickWindow(RankPage.params["activity"])
    end
end