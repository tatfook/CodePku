RankPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.RankPage");

local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local page;

-- function create_userinfo()
--     userinfo  = {}
--     for i = 1,100 do
--         table.insert(userinfo, {rank = i, name = i, sorce = 100-i})
--     end
--     return userinfo
-- end

function RankPage.OnInit()
	RankPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function RankPage.OneTimeInit()
	if(RankPage.is_inited) then
		return;
	end
	RankPage.is_inited = true;
end

function RankPage.GetRankItem(type, id, range)
    if range == 2 then
        param = 'friend=1'
    else
        param = ''
    end
    list = {}
    mylist = {}
    if type == 0 then
        response = request:get('/user-exps/ranks/'..id..'?'..param, nil,{sync = true})
        data = response.data.data
        for i, d in ipairs(data) do
            l = {}
            l['name'] = d.user.nickname
            l['score'] = d.total_exp
            l['rank'] = i
            table.insert(list, l)
            if d.current_user == 1 then
                table.insert(mylist, l)
            end
        end
    else
        response = request:get('/game-scores/ranks?game_name='..id..'&'..param,nil,{sync = true})
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
    end
    if #mylist == 0 or mylist == nil then
        table.insert(mylist, {name = '---', score = '---', rank = '---'})
    end
    if response.data.code == 200 then
        return list, mylist
    end
end

function RankPage:ShowPage(bShow)   
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    RankPage.bForceHide = bShow == false;
    --RankPage.PageIndex = PageIndex
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/FastEntrence/RankPage.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21})
end

