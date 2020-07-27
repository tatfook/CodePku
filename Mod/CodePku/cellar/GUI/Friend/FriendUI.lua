NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local FriendUI = commonlib.gettable("Mod.CodePku.GUI.FriendUI")

FriendUI.ui = nil
FriendUI.popui = nil
FriendUI.params={
    myfriend = {
        url="Mod/CodePku/cellar/GUI/Friend/MyFriend.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    },
    recentplayer = {
        url="Mod/CodePku/cellar/GUI/Friend/RecentPlayer.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    },
    blacklist = {
        url="Mod/CodePku/cellar/GUI/Friend/BlackList.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    },
    privatechat = {
        url="Mod/CodePku/cellar/GUI/Friend/PrivateChat.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    },
}


FriendUI.popparams={
    search = {
        url="Mod/CodePku/cellar/GUI/Friend/popup/search.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    },
    apply = {
        url="Mod/CodePku/cellar/GUI/Friend/popup/apply.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    },
    add = {
        url="Mod/CodePku/cellar/GUI/Friend/popup/add.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    },
    delete = {
        url="Mod/CodePku/cellar/GUI/Friend/popup/delete.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    }
}

FriendUI.vars = {}


function FriendUI:Search(nameorid)
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:get('/users/search?keyword='..nameorid,nil,{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        FriendUI.vars["search"] = {
            friend_id = response.data.data.id,
            nickname = response.data.data.nickname or response.data.data.mobile,
            gender = response.data.data.gender,
            head = response.data.data.avatar_url,
            is_online = true,  -- Todo
            last_time = response.data.data.updated_at,  -- Todo
        }
    else
        FriendUI.vars["search"] = nil;
    end
end


function FriendUI:Add_Friend(fid)
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:post('/contacts',{friend_id=fid},{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        GameLogic.AddBBS("CodeGlobals", format(L"已向%s发送了好友申请", string.sub(FriendUI.vars["search"].nickname,1,7)), 3000, "#00FF00");
    end
end


function FriendUI:GetApply()
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:get('/contacts/new-friends',nil,{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        FriendUI.vars["apply"] = {}
        local aindex = 1
        for index, data in ipairs(response.data.data) do
            if data.status == 0 then
                FriendUI.vars["apply"][aindex] = {
                    index = index,
                    id = data.id,
                    friend_id = data.user.id,
                    nickname = data.user.nickname or string.sub(data.user.mobile,1,7),
                    gender = data.user.gender,
                    head = data.user.avatar_url,
                    is_online = true,  -- Todo
                    last_time = data.user.updated_at,  -- Todo
                    remark = data.remark,
                }
                aindex = aindex + 1;
            end
        end
    else
        FriendUI.vars["apply"] = nil;
    end
end


function FriendUI:HandleApply(aid, hkind)
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:put('/contacts/new-friends/'..aid,{status=hkind},{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        return true
    end
    return false
end

function FriendUI:GetFriend()
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:get('/contacts',nil,{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        FriendUI.vars["friends"] = {}

        for index, data in ipairs(response.data.data) do
            FriendUI.vars["friends"][index] = {
                id = data.id,
                friend_id = data.friend.id,
                nickname = data.friend.nickname or string.sub(data.friend.mobile,1,7),
                gender = data.friend.gender,
                head = data.friend.avatar_url,
                is_online = true,  -- Todo
                last_time = data.friend.updated_at,  -- Todo
                remark = data.remark,
            }
        end
    else
        FriendUI.vars["friends"] = nil;
    end
end


function FriendUI:GetBlackList()
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:get('/contacts',nil,{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        FriendUI.vars["friends"] = {}

        for index, data in ipairs(response.data.data) do
            FriendUI.vars["friends"][index] = {
                id = data.id,
                friend_id = data.friend.id,
                nickname = data.friend.nickname or string.sub(data.friend.mobile,1,7),
                gender = data.friend.gender,
                head = data.friend.avatar_url,
                is_online = true,  -- Todo
                last_time = data.friend.updated_at,  -- Todo
                remark = data.remark,
            }
        end
    else
        FriendUI.vars["friends"] = nil;
    end
end



function FriendUI:DeleteFriend(lid)
    local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
    local response = request:delete('/contacts/delete/'..lid,nil,{sync = true})
    if (response.status == 200 and response.data.code == 200) then
        GameLogic.AddBBS("CodeGlobals", format(L"删除了%s", FriendUI.vars["cur"].nickname), 3000, "#00FF00")
        FriendUI.vars["cur"] = nil
        FriendUI:GetFriend()
        FriendUI:ShowPage(1)
    end
end


function FriendUI:ShowPage(PageIndex)
    
    if FriendUI.ui ~= nil then
        FriendUI.ui:CloseWindow()
    end

    PageIndex = tonumber(PageIndex)
    if PageIndex == 1 then
        FriendUI:GetFriend()
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["myfriend"])
    elseif PageIndex == 2 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["recentplayer"])
    elseif PageIndex == 3 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["blacklist"])
    elseif PageIndex == 4 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["privatechat"])
    end
end


function FriendUI:ShowPopup(PopIndex)
    if FriendUI.popui ~= nil then
        FriendUI.popui:CloseWindow()
    end

    PopIndex = tonumber(PopIndex)

    if PopIndex == 1 then
        FriendUI.popui = AdaptWindow:QuickWindow(FriendUI.popparams["search"])
    elseif PopIndex == 2 then
        FriendUI.popui = AdaptWindow:QuickWindow(FriendUI.popparams["add"])
    elseif PopIndex == 3 then
        FriendUI.popui = AdaptWindow:QuickWindow(FriendUI.popparams["apply"])
    elseif  PopIndex == 4 then
        FriendUI.popui = AdaptWindow:QuickWindow(FriendUI.popparams["delete"])
    end
end