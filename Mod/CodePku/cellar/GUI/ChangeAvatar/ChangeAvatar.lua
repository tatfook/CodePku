
local ChangeAvatarPage = commonlib.gettable("Mod.CodePku.GUI.ChangeAvatarPage")

ChangeAvatarPage.navig = {
    {text=L"头像", name="avatar"},
    {text=L"头像框", name="avatarFrame"},
};


ChangeAvatarPage.ui = nil
ChangeAvatarPage.navig_index = nil
ChangeAvatarPage.select_index = nil
ChangeAvatarPage.avatar = nil
ChangeAvatarPage.avatar_frame = nil
ChangeAvatarPage.now_avatar = nil
ChangeAvatarPage.now_avatar_frame = nil
local ProfilePng = "codepku/image/textures/avatar_ui/avatar_32bits.png"

ChangeAvatarPage.params={
    avatar = {
        url="Mod/CodePku/cellar/GUI/ChangeAvatar/Avatar.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080,zorder =21
    },
    avatar_frame = {
        url="Mod/CodePku/cellar/GUI/ChangeAvatar/AvatarFrame.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080,zorder =21
    },
}

function ChangeAvatarPage.GetAvatar()
    local avatar = {
        {name = 'img1', img = ProfilePng..'#312 455 210 211', state = 1, is_open = true, is_new = false, index = 1},
        {name = 'img2', img = ProfilePng..'#36 261 172 178', state = 0, is_open = true, is_new = false, index = 2},
        {name = 'img3', img = ProfilePng..'#227 261 173 179', state = 0, is_open = true, is_new = false, index = 3},
        {name = 'img4', img = ProfilePng..'#419 263 176 174', state = 0, is_open = true, is_new = true, index = 4},
        {name = 'img5', img = ProfilePng..'#419 263 176 174', state = 0, is_open = false, is_new = false, index =5},
        {name = 'img6', img = ProfilePng..'#419 263 176 174', state = 0, is_open = false, is_new = false, index = 6},
        {name = 'img7', img = ProfilePng..'#419 263 176 174', state = 0, is_open = false, is_new = false, index = 7},
        {name = 'img8', img = ProfilePng..'#419 263 176 174', state = 0, is_open = false, is_new = false, index = 8},
    }
    return avatar;
end
function ChangeAvatarPage.GetAvatarFrame()
    local avatar = {
        {name = 'img1', img = ProfilePng..'#770 69 176 176', state = 1, is_open = true, is_new = false, index = 1},
        {name = 'img2', img = ProfilePng..'#770 69 176 176', state = 0, is_open = true, is_new = false, index = 2},
        {name = 'img3', img = ProfilePng..'#770 69 176 176', state = 0, is_open = true, is_new = false, index = 3},
        {name = 'img4', img = ProfilePng..'#770 69 176 176', state = 0, is_open = true, is_new = true, index = 4},
        {name = 'img5', img = ProfilePng..'#770 69 176 176', state = 0, is_open = false, is_new = false, index =5},
        {name = 'img6', img = ProfilePng..'#770 69 176 176', state = 0, is_open = false, is_new = false, index = 6},
        {name = 'img7', img = ProfilePng..'#770 69 176 176', state = 0, is_open = false, is_new = false, index = 7},
        {name = 'img8', img = ProfilePng..'#770 69 176 176', state = 0, is_open = false, is_new = false, index = 8},
    }
    return avatar;
end

function ChangeAvatarPage:ShowPage(Pageindex)
    
    if ChangeAvatarPage.ui ~= nil then
        ChangeAvatarPage.ui:CloseWindow()
    end
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    local Pageindex = tonumber(Pageindex) or 1
    ChangeAvatarPage.navig_index = Pageindex
    print(ChangeAvatarPage.navig_index)
    if Pageindex == 1 then
        print(ChangeAvatarPage.navig_index)
        ChangeAvatarPage.avatar = ChangeAvatarPage.GetAvatar()
        ChangeAvatarPage.now_avatar = 1
        ChangeAvatarPage.ui = AdaptWindow:QuickWindow(ChangeAvatarPage.params['avatar'])
    elseif Pageindex == 2 then
        ChangeAvatarPage.avatar_frame = ChangeAvatarPage.GetAvatarFrame()
        ChangeAvatarPage.now_avatar_frame = 1
        ChangeAvatarPage.ui = AdaptWindow:QuickWindow(ChangeAvatarPage.params['avatar_frame'])
    end
    
end