-- 主界面按钮
--author: Min da
--date: 2020-05-29 10:19:30
NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");
FriendUI = NPL.load("(gl)Mod/CodePku/cellar/GUI/Friend/FriendUI.lua");
CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");


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
        if PopIndex == 1 then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["world_page"])
        elseif PopIndex == 2 then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["local_page"])
        elseif PopIndex == 3 then
            window = AdaptWindow:QuickWindow(MainSceneUIButtons.params["friend_page"])
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