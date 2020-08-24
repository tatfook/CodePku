-- 主界面按钮
--author: Min da
--date: 2020-05-29 10:19:30
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");
FriendUI = NPL.load("(gl)Mod/CodePku/cellar/GUI/Friend/FriendUI.lua");
CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");

-- {"全部","世界","本地","公会","校园","系统","好友"}
--[[
private_chat = 0, -- 私聊
system = 1, -- 系统通知
world = 2,  -- 世界
nearby = 3, -- 附近、本地
guild = 4,  -- 工会
school = 5, -- 学校   
--]]
MainSceneUIButtons.Channels = {
    [1]={name="system",index=1, channel=1,title='系统'},
    [2]={name="world",index=2, channel=2,title='世界'},
    [3]={name="local",index=3, channel=3,title='本地'},
    [4]={name="friend",index=4, channel=0,title='好友'},
    
    ['system']=1,
    ['world']=2,
    ['local']=3,
    ['friend']=4,
}

MainSceneUIButtons.params={
    world_page = {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/dialog/world.html",
        alignment="_lt", left = 0, top = 0, width = 1004, height = 1080,zorder =20
    },
    local_page = {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/dialog/local.html",
        alignment="_lt", left = 0, top = 0, width = 1004, height = 1080,zorder =20
    },
    friend_page = {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/dialog/friend.html",
        alignment="_lt", left = -0, top = 0, width = 1004, height = 1080,zorder =20
    },
        system_page = {
        url="Mod/CodePku/cellar/Common/TouchMiniButtons/dialog/system.html",
        alignment="_lt", left = 0, top = 0, width = 1004, height = 1080,zorder =20
    },
}


MainSceneUIButtons.FriendId = nil
MainSceneUIButtons.Dialog_page = nil


function MainSceneUIButtons.show_dialog_ui(bshow, PopIndex, friendid)
    FriendUI:GetFriend()

    MainSceneUIButtons.ScrollToEnd = 'true'

    if friendid ~= nil then
        FriendID = tonumber(friendid)
        MainSceneUIButtons.FriendId = FriendID
    end

    if(bshow) then
        PopIndex = tonumber(PopIndex)
        MainSceneUIButtons.words = ""
        local window = nil
        if PopIndex == MainSceneUIButtons.Channels['world'] then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["world_page"])
        elseif PopIndex == MainSceneUIButtons.Channels['local'] then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["local_page"])
        elseif PopIndex == MainSceneUIButtons.Channels['friend'] then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["friend_page"])
        elseif PopIndex == MainSceneUIButtons.Channels['system'] then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["system_page"])
        end
        return window
    else
        params = {
            url="Mod/CodePku/cellar/Common/TouchMiniButtons/MainUIButtons_dialog_close.html", 
            alignment="_lb", left = 0, top = -136, width = 139, height = 136,
        }
        local window = AdaptWindow:QuickWindow(params)
        MainSceneUIButtons.Dialog_page = window
        return window
    end
end