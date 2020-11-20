--[[usage:
local InviteCode = NPL.load("(gl)Mod/CodePku/cellar/GUI/InviteCode/InviteCode.lua")
--]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local Config = NPL.load("(gl)Mod/CodePkuCommon/config/Config.lua")

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
        zorder = 30,
        }

    AdaptWindow:QuickWindow(params)
end

function InviteCode.Init()
    InviteCode.ifBanded = InviteCode.ifBanded or false
    InviteCode.bandName = InviteCode.bandName ~= '' and InviteCode.bandName or ''
    InviteCode.ifBandAwardReceived = InviteCode.ifBandAwardReceived or false

    InviteCode.ifInviteRecord = InviteCode.ifInviteRecord or false
    InviteCode.invite_code = InviteCode.invite_code ~= '' and InviteCode.invite_code or ''
    InviteCode.inviteRewards = InviteCode.inviteRewards and  next(InviteCode.inviteRewards) and InviteCode.inviteRewards or {}
    InviteCode.inviteRecords = InviteCode.inviteRecords and next(InviteCode.inviteRecords) and InviteCode.inviteRecords or {}
    --reward_status/status:1未完成2已领取3未领取

    --标记,为了只刷新一次
    InviteCode.dataFlag1 = InviteCode.dataFlag1 or nil -- 活动时间/邀请码
    InviteCode.dataFlag2 = nil -- 邀请奖励
    InviteCode.dataFlag3 = nil --绑定者奖励
    if not InviteCode.dataFlag1 then -- 活动时间/邀请码不用刷新
        request:get(string.format('/invite/show?activity_id=%d&user_id=%d', InviteCode.activity_id, System.User.info.id)):next(function(response)
            local data = response.data.data
            InviteCode.invite_code = data.invite_code
            InviteCode.start_time = data.start_time
            InviteCode.end_time = data.end_time
            InviteCode.dataFlag1 = true
            if InviteCode.dataFlag2 and InviteCode.dataFlag3 then
                InviteCode.window:Refresh(0)
            end
        end):catch(function(e)
            GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        end)
    end

    request:get(string.format('/invite-reward/list?activity_id=%d', InviteCode.activity_id)):next(function(response)
        local rewardData = response.data.data
        table.sort(rewardData, function (a, b)
            return if_else(a.id<b.id, true, false)
        end)
        local index = 1
        InviteCode.inviteRewards = {}
        for _,v in pairs(rewardData) do
            if v.type=="2" then
                v.reward_json = commonlib.Json.Decode(v.reward_json)
                InviteCode.inviteRewards[index] = v
                index = index + 1
            end
        end
        InviteCode.dataFlag2 = true
        if InviteCode.dataFlag1 and InviteCode.dataFlag3 then
            InviteCode.window:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)

    request:get(string.format('/invite-reward/bind?activity_id=%d', InviteCode.activity_id)):next(function(response)
        local bindData = response.data.data
        InviteCode.ifBanded = bindData.status ~= 1
        InviteCode.bandName = bindData.inviter_nick_name
        InviteCode.bandRewards =  commonlib.Json.Decode(bindData.reward_json)
        InviteCode.ifBandAwardReceived = bindData.status == 2

        InviteCode.dataFlag3 = true
        if InviteCode.dataFlag1 and InviteCode.dataFlag2 then
            InviteCode.window:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.GetRecord()
    request:get(string.format('/invite/list?activity_id=%d', InviteCode.activity_id)):next(function(response)
        InviteCode.inviteRecords = {}

        local inviteData = response.data.data
        table.sort(inviteData, function (a, b)
            return if_else(a.id<b.id, true, false)
        end)

        local index = 1
        for _,v in pairs(inviteData) do
            InviteCode.inviteRecords[index] = {id=index, name=v.u_nickname}
            index = index + 1
        end
        InviteCode.window:Refresh(0)
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.CheckVisitor()
    local VisitorLimit = NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/VisitorLimit.lua");
    local params = {
        title = "提示",
        content = "您需要升级为正式账号才能参与活动",
    }
    return VisitorLimit:CheckStatus(params)
end

function InviteCode.Band(code)
    if InviteCode.CheckVisitor() then
        return
    end

    local userCreateTime =  System.User.info.created_at
    local start_time = InviteCode.start_time
    start_time = string.gsub(start_time,'%.','-')
    local activityTime = string.format("%s 00:00:00", start_time)
    local ifCreateAfterActivity = (commonlib.GetMillisecond_Date(userCreateTime) - commonlib.GetMillisecond_Date(activityTime)) >= 0

    if ifCreateAfterActivity then
        local data = {
            invite_code = code,
            activity_id = InviteCode.activity_id
        }
        request:post('/invite/bind', data):next(function(response)
            InviteCode.ifBanded = true
            GameLogic.AddBBS("CodeGlobals", L"恭喜您绑定成功", 3000, "#00FF00");
            InviteCode.Init()
        end):catch(function(e)
            GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        end)
    else
        GameLogic.AddBBS("CodeGlobals", L"您的注册时间早于活动开始时间，无法参与活动", 3000, "#FF0000");
    end
end

function InviteCode.GetAward(btnName)
    local reward_id = tonumber(btnName)
    local data = {
        reward_id = reward_id,
        activity_id = InviteCode.activity_id,
    }
    request:post('/invite-reward/store', data):next(function(response)
        local wanxuebi, wanxuequan = 0, 0
        if reward_id == 1 then
            wanxuebi = tonumber(InviteCode.bandRewards["1"]["prop_count"])
            wanxuequan = tonumber(InviteCode.bandRewards["2"]["prop_count"])
        else
            for _,v in pairs(InviteCode.inviteRewards) do
                if v.id == reward_id then
                    wanxuebi = tonumber(v["reward_json"]["1"]["prop_count"])
                    wanxuequan = tonumber(v["reward_json"]["2"]["prop_count"])
                end
            end
        end
        if (wanxuebi and wanxuebi > 0) or (wanxuequan and wanxuequan > 0) then
            CommonFunc.RefreshLocalMoney({{amount=wanxuebi,currency_id=1,},{amount=wanxuequan,currency_id=2,},}, nil ,true)
        end
        GameLogic.AddBBS("CodeGlobals", L"恭喜您领取成功", 3000, "#00FF00");
        InviteCode.Init()
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

function InviteCode.InviteCopy()
    GameLogic.AddBBS("CodeGlobals", L"邀请码复制成功", 3000, "#00FF00");
    ParaMisc.CopyTextToClipboard(InviteCode.invite_code)
end

function InviteCode.InviteShare()
    local Share = NPL.load("(gl)Mod/CodePkuCommon/util/Share.lua");
    local platform = System.os.GetPlatform();
    local isAndroid = platform == "android";
    local isIOS = platform == "ios";

    local url = string.format('%s/h5/event/invitecode/%d?user_id=%d', Config.defaultCodepkuHost, InviteCode.activity_id, System.User.info.id)
    local paras_ios = {
        url = url,
        title = "邀请好友领取奖励",
        des = "《玩学世界》呼朋唤友一起边玩边学，获取海量玩学券！",
        thumb = "https://www.wanxueshijie.com/images/common/share_img.png"
    }
    local paras_android = {
        url = url,
        title = "《玩学世界》呼朋唤友一起边玩边学，获取海量玩学券！",
        des = "https://www.wanxueshijie.com/images/common/share_img.png",
        thumb = "邀请好友领取奖励"
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

