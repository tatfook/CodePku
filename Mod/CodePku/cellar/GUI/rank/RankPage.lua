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
    }
}

function RankPage.GetSubjectItem(id, range)
    if range == 2 then
        param = '?friend=1'
    else
        param = ''
    end
    list = {}
    mylist = {}
    response = request:get('/user-exps/ranks/'..id..param, nil,{sync = true})
    data = response.data.data
    for i, d in ipairs(data) do
        l = {}
        l['name'] = d.user.nickname
        l['score'] = d.current_level..'级'
        l['rank'] = i
        table.insert(list, l)
        if d.current_user == 1 then
            table.insert(mylist, l)
        end
    end
    if #mylist == 0 or mylist == nil then
        table.insert(mylist, {name = '---', score = '---', rank = '---'})
    end
    if response.data.code == 200 then
        return list, mylist
    end
end

function RankPage.GetGameItem(id, range)
    if range == 2 then
        param = '&friend=1'
    else
        param = ''
    end
    list = {}
    mylist = {}
    response = request:get('/game-scores/ranks?game_name='..id..param,nil,{sync = true})
    data = response.data.data
    for i, d in ipairs(data) do
        l = {}
        l['name'] = d.user.nickname
        l['score'] = d.score
        l['rank'] = i
        table.insert(list, l)
        if d.current_user == 1 then
            table.insert(mylist, l)
        end
    end
    if #mylist == 0 or mylist == nil then
        table.insert(mylist, {name = '---', score = '---', rank = '---'})
    end
    if response.data.code == 200 then
        return list, mylist
    end
end


function RankPage:ShowPage(PageIndex, bShow)
    
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
        RankPage.userinfo, RankPage.myinfo = RankPage.GetGameItem('parkour', 1)
        RankPage.ui = AdaptWindow:QuickWindow(RankPage.params["game"])
    end
end