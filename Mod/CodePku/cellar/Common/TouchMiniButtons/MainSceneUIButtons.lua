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

MainSceneUIButtons.Emoticons = {
    [1]={name="sure",title="肯定",url="codepku/image/textures/chat_ui/chat_32bits.png#61 59 86 84",index =1,left=28},
    [2]={name="shock",title="惊吓",url="codepku/image/textures/chat_ui/chat_32bits.png#175 60 86 85",index =2,left=142},
    [3]={name="greet",title="打招呼",url="codepku/image/textures/chat_ui/chat_32bits.png#302 56 79 90",index =3,left=256},
    [4]={name="cry",title="哭",url="codepku/image/textures/chat_ui/chat_32bits.png#422 59 78 84",index =4,left=370},
    [5]={name="angty",title="生气",url="codepku/image/textures/chat_ui/chat_32bits.png#542 57 85 89",index =5,left=484},
    [6]={name="smile",title="微笑",url="codepku/image/textures/chat_ui/chat_32bits.png#65 180 78 84",index =6,left=28,top=143},
    [7]={name="vomit",title="吐",url="codepku/image/textures/chat_ui/chat_32bits.png#178 179 79 86",index =7,left=142,top=143},
    [8]={name="dizzy",title="头晕",url="codepku/image/textures/chat_ui/chat_32bits.png#298 179 87 86)",index =8,left=256,top=143},
    [9]={name="dislike",title="嫌弃",url="codepku/image/textures/chat_ui/chat_32bits.png#424 180 78 85",index =9,left=370,top=143},
    [10]={name="wordless",title="无语",url="codepku/image/textures/chat_ui/chat_32bits.png#541 177 79 90",index =10,left=484,top=143},
}



MainSceneUIButtons.FriendId = nil

function MainSceneUIButtons.show_dialog_ui(bshow, PopIndex, friendid)
    FriendUI:GetFriend()

    MainSceneUIButtons.ScrollToEnd = 'true'

    if friendid ~= nil then
        FriendID = tonumber(friendid)
        MainSceneUIButtons.FriendId = FriendID
    end

    if(bshow) then
        PopIndex = tonumber(PopIndex)
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
        return window
    end
end

function MainSceneUIButtons.show_emoticon_ui(bshow, PopIndex, friendid)
    local param = {
        url = "Mod/CodePku/cellar/Common/TouchMiniButtons/dialog/emoticon.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder = 30,
    }
    echo("-------------------show_emoticon_ui-------------------------")
    return  AdaptWindow:QuickWindow(param)
end