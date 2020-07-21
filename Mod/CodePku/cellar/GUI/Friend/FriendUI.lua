NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local FriendUI = commonlib.gettable("Mod.CodePku.GUI.FriendUI")

FriendUI.ui = nil
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

function FriendUI:ShowPage(PageIndex)
    
    if FriendUI.ui ~= nil then
        FriendUI.ui:CloseWindow()
    end

    PageIndex = tonumber(PageIndex)
    if PageIndex == 1 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["myfriend"])
    elseif PageIndex == 2 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["recentplayer"])
    elseif PageIndex == 3 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["blacklist"])
    elseif PageIndex == 4 then
        FriendUI.ui = AdaptWindow:QuickWindow(FriendUI.params["privatechat"])
    end
end