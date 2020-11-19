--[[usage:
local InviteCode = NPL.load("(gl)Mod/CodePku/cellar/GUI/InviteCode/InviteCode.lua")
--]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

local InviteCode = NPL.export();

InviteCode.activity_id = 1  --活动ID

function InviteCode.GetIconUrl(iconName)
    if iconName == 'main_icon_coin_1.png' or iconName == 'main_icon_coin_2.png' or iconName == 'main_friends_call.png' then
        return mainFrameImageData:GetIconUrl(iconName)
    else
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

function InviteCode.Init()
    --标记,为了只刷新一次
    local dataFlag1 = nil -- 活动时间/邀请码
    local dataFlag2 = nil -- 邀请奖励
    local dataFlag3 = nil --绑定者奖励
    request:get(string.format('/invite/show?activity_id=%d&user_id=%d', InviteCode.activity_id, System.User.info.id)):next(function(response)
        local data = response.data.data
        InviteCode.invite_code = data.invite_code
        InviteCode.start_time = data.start_time
        InviteCode.end_time = data.end_time
        dataFlag1 = true
        if dataFlag2 and dataFlag3 then
            InviteCode.window:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)

    request:get(string.format('/invite-reward/list?activity_id=%d', InviteCode.activity_id)):next(function(response)
        InviteCode.rewardData = response.data.data
        dataFlag2 = true
        if dataFlag1 and dataFlag3 then
            InviteCode.window:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)

    request:get(string.format('/invite-reward/bind?activity_id=%d', InviteCode.activity_id)):next(function(response)
        InviteCode.bindData = response.data.data
        --todo ifBanded/ifBandAwardReceived状态获取
        dataFlag3 = true
        if dataFlag1 and dataFlag2 then
            InviteCode.window:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.GetRecord()
    request:get(string.format('/invite/list?invite_code=%s&activity_id=%d', InviteCode.activityData.invite_code, InviteCode.activity_id)):next(function(response)
        --todo 
        InviteCode.inviteRecords = {}
        for _,v in response.data.data do
            InviteCode.inviteRecords[v.id] = v.u_nickname
        end
        
        InviteCode.window:Refresh(0)
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.Band(code)
    request:post(string.format('/invite/bind?invite_code=%s&activity_id=%d', code, InviteCode.activity_id)):next(function(response)
        --todo ifBanded状态刷新
        InviteCode.window:Refresh(0)
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.GetAward(id)
    request:post(string.format('/invite-reward/store?reward_id=%d&activity_id=%d', id, InviteCode.activity_id)):next(function(response)
        --todo 获取奖励
        InviteCode.window:Refresh(0)
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.InviteCopy(text)
    GameLogic.AddBBS(nil, L"邀请码复制成功", 3000, "0 255 0")
    ParaMisc.CopyTextToClipboard(text)
end

function InviteCode.InviteShare()
    local Share = NPL.load("(gl)Mod/CodePkuCommon/util/Share.lua");
    local platform = System.os.GetPlatform();
    local isAndroid = platform == "android";
    local isIOS = platform == "ios";

    local paras_ios = {
        url = "https://www.wanxueshijie.com/",
        title = "玩学世界",
        des = "邀请码活动",
        thumb = "https://scratch-works-staging-1253386414.file.myqcloud.com/game/admin/posters/a3b546dfab2d174b4a2ca4ae1454d484.jpg"
    }
    local paras_android = {
        url = "https://www.wanxueshijie.com/",
        title = "邀请码活动",
        des = "https://scratch-works-staging-1253386414.file.myqcloud.com/game/admin/posters/a3b546dfab2d174b4a2ca4ae1454d484.jpg",
        thumb = "玩学世界"
    }

    local paras = nil
    if isIOS then
        paras = paras_ios
    elseif isAndroid then
        paras = paras_android
    end

    Share:fire("url", paras, {
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
