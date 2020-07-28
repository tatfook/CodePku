RankPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.RankPage");

local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua")
local page;

function create_userinfo()
    userinfo  = {}
    for i = 1,100 do
        table.insert(userinfo, {rank = i, name = i, sorce = 100-i})
    end
    return userinfo
end

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

function RankPage:GetRankItem(id)
    response = request:get('/game-scores/ranks/'..id, nil,{sync = true})
    data = response.data.data
    echo(data)
    list = {}
    for i, d in ipairs(data) do
        l = {}
        l['id'] = d.user_id
        if d.user.nickname == nil then
            l['name'] = '---'
        else
            l['name'] = d.user.nickname
        end
        l['score'] = d.score
        l['rank'] = i
        table.insert(list, l)
    end
    if response.data.code == 200 then
        return list
    end
end

function RankPage:ShowPage(bShow)
    RankPage.userinfo = create_userinfo()
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    RankPage.bForceHide = bShow == false;
    --RankPage.PageIndex = PageIndex
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/FastEntrence/RankPage.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20})
end
