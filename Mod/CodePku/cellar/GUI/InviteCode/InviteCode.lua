--[[usage:
local InviteCode = NPL.load("(gl)Mod/CodePku/cellar/GUI/InviteCode/InviteCode.lua")
--]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")

local InviteCode = NPL.export();

InviteCode.activity_id = 1  --活动ID

function InviteCode.GetIconUrl(iconName)
    if iconName == 'main_icon_coin_1.png' or iconName == 'main_icon_coin_2.png' or iconName == 'main_friends_call.png' then
        return mainFrameImageData:GetIconUrl(iconName)
    else
        echo(string.format("InviteCode.GetIconUrl: %s",inviteImageData:GetIconUrl(iconName)))
        return inviteImageData:GetIconUrl(iconName)
    end
end

function InviteCode:ShowPage()
    local params = {
        url = "Mod/CodePku/cellar/GUI/InviteCode/InviteCodePage.html",
        alignment = "_ct",
        x = -960,
        y = -540,
        width = 1920,
        height = 1080,
        zorder = 31,
        }

    AdaptWindow:QuickWindow(params)
end

function InviteCode.InviteCopy(text)
    ParaMisc.CopyTextToClipboard(text)
end

function InviteCode.InviteShare()
    local Share = NPL.load("(gl)Mod/CodePkuCommon/util/Share.lua");
    Share:fire("url", {
        url = "https://www.wanxueshijie.com/",
        title = "玩学世界",
        desc = "https://scratch-works-staging-1253386414.file.myqcloud.com/game/admin/posters/a3b546dfab2d174b4a2ca4ae1454d484.jpg",
        thumb = "邀请码活动"
    }, {
        onStart = function(e)
        -- 开始分享
        end,
        onResult = function(e)
        -- 分享结果
        end,
        onError = function(e)
        -- 分享失败
        end,
        onCancel = function(e)
        -- 取消分享
        end
    });
end
