
local ChangeAvatarPage = commonlib.gettable("Mod.CodePku.GUI.ChangeAvatarPage")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")

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
    -- local response = request:get("/avatars", nil, {sync=true})
    -- if response.data.code == 200 then
    --     local data = response.data.data
    --     for i=1,#data do
    --         if tonumber(data[i].is_using) == 1 then
    --             ChangeAvatarPage.now_avatar = i
    --         end
    --     end
    --     return data or {}
    -- else
    --     return {}
    -- end
    local avatar = {
        {
            id = 1,
            avatar_name = "初始头像",
            category_id = 0,
            need_unlock = 0,
            unlock_desc = "",
            limit_type = 1, 
            limit_time = 86400,
            user_id = 3,
            has_clicked = 1,
            receive_time = "2020-08-27 00:00:00",
            unlock_avatar = 1,
            file_path = "/game/admin/courseWareZip/d41d8cd98f00b204e9800998ecf8427e.zip",
            is_using = 0,
            avatar_url = "https://shouyou.3dmgame.com/uploadimg/upload/image/20190112/20190112130259_40153.jpg", 
            left_time = "6小时45分" 
        },
        {
            id = 2,
            avatar_name = "红星鸾动",
            category_id = 0,
            need_unlock = 0,
            unlock_desc = "",
            limit_type = 0, 
            limit_time = 0,
            user_id = 3,
            has_clicked = 0,
            receive_time = "2020-08-27 00:00:00",
            unlock_avatar = 1,
            file_path = "/game/admin/courseWareZip/d41d8cd98f00b204e9800998ecf8427e.zip",
            is_using = 1,
            avatar_url = "https://shouyou.3dmgame.com/uploadimg/upload/image/20190112/20190112130259_40153.jpg", 
            left_time = "6小时45分" 
        }
    }
    ChangeAvatarPage.now_avatar = 2
    return avatar
end

function ChangeAvatarPage.GetAvatarFrame()
    local response = request:get("/avatar-frames", nil, {sync=true})
    if response.data.code == 200 then
        local data = response.data.data
        for i=1,#data do
            if tonumber(data[i].is_using) == 1 then
                ChangeAvatarPage.now_avatar = i
            end
        end
        return data or {}
    else
        return {}
    end
end


function ChangeAvatarPage.SetAvatar(id)
    local response = request:put("/avatars/change/"..tostring(id), nil, {sync=true})
    if response.data.code == 200 then
        return "更换头像成功"
    else
        return response.data.message
    end
end

function ChangeAvatarPage.SetAvatarFrame(id)
    local response = request:put("/avatar-frames/change/"..tostring(id), nil, {sync=true})
    if response.data.code == 200 then
        return "更换头像框成功"
    else
        return response.data.message
    end
end

function ChangeAvatarPage.ClickNewAvatar(id)
    local response = request:get("/avatar/click/"..tostring(id), nil, {sync=true})
    if response.data.code == 200 then
        return "ok"
    else
        return response.data.message
    end
end

function ChangeAvatarPage.ClickNewAvatarFrame(id)
    local response = request:get("/avatar-frames/click/"..tostring(id), nil, {sync=true})
    if response.data.code == 200 then
        return "ok"
    else
        return response.data.message
    end
end


function ChangeAvatarPage:ShowPage(Pageindex)
    
    if ChangeAvatarPage.ui ~= nil then
        ChangeAvatarPage.ui:CloseWindow()
    end
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    local Pageindex = tonumber(Pageindex) or 1
    ChangeAvatarPage.navig_index = Pageindex
    if Pageindex == 1 then
        ChangeAvatarPage.avatar = ChangeAvatarPage.GetAvatar()
        ChangeAvatarPage.ui = AdaptWindow:QuickWindow(ChangeAvatarPage.params['avatar'])
    elseif Pageindex == 2 then
        ChangeAvatarPage.avatar_frame = ChangeAvatarPage.GetAvatarFrame()
        ChangeAvatarPage.ui = AdaptWindow:QuickWindow(ChangeAvatarPage.params['avatar_frame'])
    end
    
end