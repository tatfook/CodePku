--[[
Title: keepwork channel for chat
Author(s): leio
Date: 2020/5/6
Desc:  
Use Lib:
-------------------------------------------------------
using  KeepWorkItemManager.IsEnabled() to debug kp chat:
-- test after login keepwork
local CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");
CodepkuChatChannel.StaticInit();
local CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");
local id = 618;
CodepkuChatChannel.Connect(nil,nil,function()
    CodepkuChatChannel.JoinWorld(id);
end);
-- api declaration:
http://yapi.kp-para.cn/project/60/interface/api/1952
-------------------------------------------------------
]]
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
NPL.load("(gl)script/apps/Aries/BBSChat/ChatSystem/ChatChannel.lua");
local TipRoadManager = NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/ChatSystem/ScreenTipRoad/TipRoadManager.lua");
local GameLogic = commonlib.gettable("MyCompany.Aries.Game.GameLogic")
local ChatChannel = commonlib.gettable("MyCompany.Aries.ChatSystem.ChatChannel");
local SocketIOClient = NPL.load("(gl)script/ide/System/os/network/SocketIO/SocketIOClient.lua");
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local KeepWorkItemManager = NPL.load("(gl)script/apps/Aries/Creator/HttpAPI/KeepWorkItemManager.lua");
local WebSocketClient = NPL.load("(gl)Mod/CodePku/chat/WebSocketClient.lua");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local UserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfoPage")
local UserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfo")
local OtherUserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.OtherUserInfoPage")
local OtherUserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.OtherUserInfo")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local MainSceneUIButtons = commonlib.gettable("Mod.CodePku.Common.TouchMiniButtons.MainSceneUIButtons");
local FriendUI = commonlib.gettable("Mod.CodePku.GUI.FriendUI")



local CodepkuConfig = NPL.load("(gl)Mod/CodePku/config/Config.lua")
local CodepkuChatChannel = NPL.export();


local channelsMap = {
    private_chat = 0, -- 私聊
    system = 1, -- 系统通知
    world = 2,  -- 世界
    nearby = 3, -- 附近、本地
    guild = 4,  -- 工会
    school = 5, -- 学校
}
local messageActionsMap = {
    status = 1, --状态
    message = 2, --消息
}

local messageTypeMap = {
    text = 1, -- 文本
    voice = 2, -- 声音
    emoticons = 3 --表情
}

CodepkuChatChannel.worldId_pending = nil;
CodepkuChatChannel.worldId = nil;
CodepkuChatChannel.client = nil;
CodepkuChatChannel.Messages = {}
CodepkuChatChannel.UserOnlineStatus = {}

function CodepkuChatChannel.StaticInit()
    LOG.std("", "info", "CodepkuChatChannel", "StaticInit");

	GameLogic:Connect("WorldLoaded", CodepkuChatChannel, CodepkuChatChannel.OnWorldLoaded, "UniqueConnection");

    GameLogic.GetFilters():remove_filter("OnCodepkuLogin", CodepkuChatChannel.OnCodepkuLogin_Callback);
    GameLogic.GetFilters():remove_filter("OnCodepkuLogout", CodepkuChatChannel.OnCodepkuLogout_Callback);
    GameLogic.GetFilters():add_filter("OnCodepkuLogin", CodepkuChatChannel.OnCodepkuLogin_Callback);
    GameLogic.GetFilters():add_filter("OnCodepkuLogout", CodepkuChatChannel.OnCodepkuLogout_Callback)    
end

function CodepkuChatChannel.SetMessage(message)
    if #CodepkuChatChannel.Messages > 50 then
        table.remove(CodepkuChatChannel.Messages,#CodepkuChatChannel.Messages)
    end

    table.insert( CodepkuChatChannel.Messages, message)
end

function CodepkuChatChannel.OnWorldLoaded()
    -- local id = WorldCommon.GetWorldTag("kpProjectId");
    -- 课件id
    local id = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
    LOG.std(nil, "info", "CodepkuChatChannel", "OnWorldLoaded: %s",tostring(id));
    UserInfoPage.GetUserInfo()
    TipRoadManager:Clear(); -- todo ? 
    if (id) then
        id = tonumber(id);
        CodepkuChatChannel.worldId_pending = id;
        -- connect chat channel
        CodepkuChatChannel.OnCodepkuLogin_Callback();
    else
        CodepkuChatChannel.Clear();
    end
end
function CodepkuChatChannel.OnCodepkuLogin_Callback()
    if(CodepkuChatChannel.worldId_pending)then
        CodepkuChatChannel.Connect(nil,nil,function()
            CodepkuChatChannel.JoinWorld(CodepkuChatChannel.worldId_pending);
        end);
    end        
end
function CodepkuChatChannel.OnCodepkuLogout_Callback()
    CodepkuChatChannel.LeaveWorld(CodepkuChatChannel.worldId_pending);
end
function CodepkuChatChannel.GetUrl()
    local coursewareId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
    return CodepkuConfig.defaultSocketServer .. string.format("?token=%s&world_id=%s", System.User.codepkuToken, tostring(coursewareId));
end
function CodepkuChatChannel.GetUserId()
    return System.User.id;  
end
function CodepkuChatChannel.GetRoom()
    if(CodepkuChatChannel.worldId)then
        local room = string.format("__world_%s__",tostring(CodepkuChatChannel.worldId));
        return room
    end
end
function CodepkuChatChannel.Connect(url,options,onopen_callback)    
    if(not System.User.codepkuToken)then
        return
    end

    url  = url or CodepkuChatChannel.GetUrl();
    if(not CodepkuChatChannel.client)then
        CodepkuChatChannel.client = WebSocketClient:new();
        CodepkuChatChannel.client:AddEventListener("OnOpen",CodepkuChatChannel.OnOpen,CodepkuChatChannel);
        CodepkuChatChannel.client:AddEventListener("OnMsg",CodepkuChatChannel.OnMsg,CodepkuChatChannel);
        CodepkuChatChannel.client:AddEventListener("OnClose",CodepkuChatChannel.OnClose,CodepkuChatChannel);
    end
    options = options or {};
    CodepkuChatChannel.onopen_callback = onopen_callback;
    if(CodepkuChatChannel.client.state == "OPEN")then
        CodepkuChatChannel.OnOpen();
        return
    end
    CodepkuChatChannel.client:Connect(url);
end
function CodepkuChatChannel.OnOpen(self)
	LOG.std("", "info", "CodepkuChatChannel", "OnOpen");
    if(CodepkuChatChannel.onopen_callback)then
        CodepkuChatChannel.onopen_callback();
    end
    CodepkuChatChannel.RefreshChatWindow();

    TipRoadManager:CreateRoads();
    
end
function CodepkuChatChannel.OnClose(self)
	LOG.std("", "info", "CodepkuChatChannel", "OnClose");
    CodepkuChatChannel.Clear();
end
-- erase date if timestamp is in same day
function CodepkuChatChannel.GetTimeStamp(timestamp)
    if(not timestamp)then
        return
    end
    local date,time = string.match(timestamp, "(.+)%s(.+)");
    local local_date = ParaGlobal.GetDateFormat("yyyy-MM-dd");
    if(date and date == local_date)then
        timestamp = time;
    end
    -- erase date if timestamp is in same day
    timestamp = string.gsub(timestamp, date, "");
    return timestamp;
end
-- check if include a name in usernames_str
-- @param usernames_str: "name_1,name_2"
-- @param name: which is be searched
-- @return true if found
function CodepkuChatChannel.HasUserName(usernames_str, name)
    if(not usernames_str or not name)then
        return
    end
    local v;
	for v in string.gmatch(usernames_str, "([^,]+)") do
        if(v == name)then
            return true;
        end
	end
end
function CodepkuChatChannel.OnMsg(self, msg)
    if(not msg or not msg.data)then
        return
    end
    msg = msg.data;
    local speakerIsMe = if_else(msg.from_user_id == UserInfo.id, 1, 0)
    local avatar = msg.from_user_avatar or 'codepku/image/textures/chat/default_avatar.png'
    local action = tonumber(msg.action);
    if (action == messageActionsMap.status) then
        -- 上线通知 下线通知
        local status = if_else(msg.status == 'ONLINE', true, false)
        CodepkuChatChannel.UserOnlineStatus[msg.user_id] = status

        for i ,v in ipairs(FriendUI.vars["friends"]) do
            if v.friend_id == msg.user_id then
                status = if_else(msg.status == 'ONLINE', true, false)
                v.is_online = status
            end
        end
    else 
        local channel = tonumber(msg.channel);   
        -- system = 1, -- 系统通知
        -- world = 2,  -- 世界
        -- nearby = 3, -- 附近、本地
        -- guild = 4,  -- 工会
        -- school = 5, -- 学校
        if (channel == channelsMap.system) then
            -- todo 系统通知
        elseif (channel == channelsMap.world) then 
            msg_data = {speakerIsMe=speakerIsMe, dialog=msg.content, avatar=avatar, nickname=msg.from_user_nickname, level=msg.from_user_level or 1, channel=msg.channel}
            -- table.insert( CodepkuChatChannel.Messages, msg_data)
            CodepkuChatChannel.SetMessage(msg_data);
            -- todo 频道:世界
        elseif (channel == channelsMap.nearby) then
            msg_data = {speakerIsMe=speakerIsMe, dialog=msg.content, avatar=avatar, nickname=msg.from_user_nickname, level=msg.from_user_level or 1, channel=msg.channel}
            -- table.insert( CodepkuChatChannel.Messages, msg_data)
            CodepkuChatChannel.SetMessage(msg_data);
        elseif (channel == channelsMap.guild) then
            -- todo 频道:工会
        elseif (channel == channelsMap.school) then
            -- todo 频道: 学校
        elseif (channel == channelsMap.private_chat) then
            -- 私聊
            msg_data = {speakerIsMe=speakerIsMe, dialog=msg.content, avatar=avatar, nickname=msg.from_user_nickname, level=msg.from_user_level or 1, channel=msg.channel, from=msg.from_user_id, to=msg.to_user_id}
            -- table.insert( CodepkuChatChannel.Messages, msg_data)
            CodepkuChatChannel.SetMessage(msg_data);
        end
    end
    if MainSceneUIButtons.page then
        MainSceneUIButtons.page:Refresh(0)
    end
    -- if FriendUI.page then
    --     FriendUI.page:Refresh(0)
    -- end
end

function CodepkuChatChannel.CreateMcmlStrToTipRoad(chatdata)
    if(not chatdata)then
        return
    end
    local mcmlStr = "";
    local words = chatdata.words or "";
    local color = chatdata.color or "ffffff";
    local kp_from_name = chatdata.kp_from_name or "";
    local vip = chatdata.vip;
    local student = chatdata.student;
    local orgAdmin = chatdata.orgAdmin;
    local tLevel = chatdata.tLevel;
    local timestamp = chatdata.timestamp or "";

    local channel_tag = "";
    local name_tag_start = [[<div style="float:left">[</div>]]
    local user_tag = KeepWorkItemManager.GetUserTag(chatdata);
    if(user_tag)then
        if(user_tag == "VT")then
            user_tag = string.format([[<kp:usertag tag="%s" style="float:left;width:34px;height:18px;" />]],user_tag);
        else
            user_tag = string.format([[<kp:usertag tag="%s" style="float:left;width:18px;height:18px;" />]],user_tag);
        end
    else
        user_tag = "";
    end
    local name_tag_end = [[<div style="float:left">]:</div>]]

    kp_from_name = string.format([[<div style="float:left">%s</div>]],kp_from_name);
    local timestamp_tag = "";

    if(chatdata.ChannelIndex == ChatChannel.EnumChannels.KpSystem)then
        mcmlStr = string.format([[<div style="color:#%s;font-size:15px;base-font-size:15;font-weight:bold;shadow-quality:8;shadow-color:#8000468e;text-shadow:true;">
%s%s%s%s%s%s%s%s</div>
        ]],color,channel_tag,"","","","",":",words,timestamp_tag);
    else
        mcmlStr = string.format([[<div style="color:#%s;font-size:15px;base-font-size:15;font-weight:bold;shadow-quality:8;shadow-color:#8000468e;text-shadow:true;">
%s%s%s%s%s%s%s</div>
        ]],color,channel_tag,name_tag_start,user_tag,kp_from_name,name_tag_end,words,timestamp_tag);
    end
    return mcmlStr;
end
function CodepkuChatChannel.CreateMcmlStrToChatWindow(chatdata)
    if(not chatdata)then
        return
    end
    local mcmlStr = "";
    local words = chatdata.words or "";
    local color = chatdata.color or "ffffff";
    local kp_from_name = chatdata.kp_from_name or "";
    local vip = chatdata.vip;
    local student = chatdata.student;
    local orgAdmin = chatdata.orgAdmin;
    local tLevel = chatdata.tLevel;
    local timestamp = chatdata.timestamp or "";

    local channel_tag = string.format([[<div style="float:left">[%s]</div>]],chatdata.channelname);
    local name_tag_start = [[<div style="float:left">[</div>]]
    local user_tag = KeepWorkItemManager.GetUserTag(chatdata);
    if(user_tag)then
        if(user_tag == "VT")then
            user_tag = string.format([[<kp:usertag tag="%s" style="float:left;width:34px;height:18px;" />]],user_tag);
        else
            user_tag = string.format([[<kp:usertag tag="%s" style="float:left;width:18px;height:18px;" />]],user_tag);
        end
    else
        user_tag = "";
    end
    local name_tag_end = [[<div style="float:left">]:</div>]]

    kp_from_name = string.format([[<div style="float:left">%s</div>]],kp_from_name);
    local timestamp_tag = string.format([[<input type="button" value="%s" style="float:left;margin-left:10px;color:#8b8b8b;background:url();" />]],tostring(timestamp));
    if(chatdata.ChannelIndex == ChatChannel.EnumChannels.KpSystem)then
        mcmlStr = string.format([[<div style="color:#%s">%s%s%s%s%s%s%s%s</div>]],color,channel_tag,"","","","",":",words,timestamp_tag);
    else
        mcmlStr = string.format([[<div style="color:#%s">%s%s%s%s%s%s%s</div>]],color,channel_tag,name_tag_start,user_tag,kp_from_name,name_tag_end,words,timestamp_tag);
    end
    return mcmlStr;
end
function CodepkuChatChannel.SetBulletScreen(v)
    if(GameLogic)then
        local key = string.format("is_opened_bullet_screen_%s",tostring(CodepkuChatChannel.GetUserId()));
	    GameLogic.GetPlayerController():SaveLocalData(key, v, true);
        TipRoadManager:OnShow(v)
    end
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/ChatSystem/ChatEdit.lua");
    local ChatEdit = commonlib.gettable("MyCompany.Aries.ChatSystem.ChatEdit");
    if(ChatEdit.page)then
        ChatEdit.page:Refresh(0);
    end
end
function CodepkuChatChannel.BulletScreenIsOpened()
    if(GameLogic)then
		local userId = CodepkuChatChannel.GetUserId();
		if (userId) then
			local key = string.format("is_opened_bullet_screen_%s",tostring(userId));
			return GameLogic.GetPlayerController():LoadLocalData(key,true,true);
		end
    end
    return true;
end
function CodepkuChatChannel.JoinWorld(worldId)
    if(not worldId)then
        return
    end
    if(not CodepkuChatChannel.IsConnected())then
        return
    end
    CodepkuChatChannel.worldId = worldId;
    local room = CodepkuChatChannel.GetRoom();
	LOG.std(nil, "info", "CodepkuChatChannel", "try to join world %s", room);
    CodepkuChatChannel.client:SendMsg({ type="join", rooms = { room }, });
end
function CodepkuChatChannel.LeaveWorld(worldId)
    if(not worldId)then
        return
    end
    local room = CodepkuChatChannel.GetRoom();
	LOG.std(nil, "info", "CodepkuChatChannel", "try to join world %s", room);
    CodepkuChatChannel.client:SendMsg({ type = "leave", rooms = { room }, });
    CodepkuChatChannel.Clear();
end
function CodepkuChatChannel.IsConnected()
    return CodepkuChatChannel.client and CodepkuChatChannel.client:IsConnected()
end
function CodepkuChatChannel.IsInWorld()
    if(CodepkuChatChannel.worldId and CodepkuChatChannel.IsConnected())then
        return true;
    end
end
function CodepkuChatChannel.Clear()
    CodepkuChatChannel.worldId = nil
    CodepkuChatChannel.RefreshChatWindow()
end
-- refresh for showing or hiding chat channel
function CodepkuChatChannel.RefreshChatWindow()
    -- todo
end

function CodepkuChatChannel.SendWorldMsg(words)
    if(not words)then
        return
    end
    local worldMsg = {

        from_user_id = UserInfo.id,
        from_user_nickname = UserInfo.name,
        from_user_avatar = UserInfo.avatar,
        from_user_level = UserInfo.self_level.current_level,
        channel = channelsMap.world,
        courseware_id=1, --todo
        type=messageTypeMap.text,
        content= words,
        action=2,
    };

    CodepkuChatChannel.client:SendMsg(worldMsg);   
end

-- 发给附近
function CodepkuChatChannel.SendNearByMsg(words)
    if(not words)then
        return
    end
    pos_x, pos_y, pos_z = EntityManager.GetPlayer():GetPosition()
    local nearByMsg = {
        from_user_id = UserInfo.id,
        from_user_nickname = UserInfo.name,
        from_user_avatar = UserInfo.avatar,
        from_user_position = {x=pos_x, y=pos_y, z=pos_z},
        from_user_level = UserInfo.self_level.current_level,
        channel = channelsMap.nearby,
        courseware_id=1, --todo
        type=messageTypeMap.text,
        content= words,
        action=2,
    };

    CodepkuChatChannel.client:SendMsg(nearByMsg); 
end

-- 发给工会 暂时不做
function CodepkuChatChannel.SendGuildMsg(words)
    --todo
end

-- 发给好友
function CodepkuChatChannel.SendToFriend(friend, words)
    if (not words) then
        return
    end
    local to_user_id = friend.friend_id
    if to_user_id then
        OtherUserInfoPage.GetUserInfo(to_user_id)
        local worldMsg = {
            to_user_id = to_user_id,
            to_user_nickname = friend.name,
            to_user_avatar = friend.head,
            from_user_id = UserInfo.id,
            from_user_nickname = UserInfo.name,
            from_user_avatar = UserInfo.avatar,
            from_user_level = UserInfo.self_level.current_level,
            channel = channelsMap.private_chat,
            courseware_id=1, --todo
            type=messageTypeMap.text,
            content= words,
            action=2,
        };
        echo(string.format( "CodepkuChatChannel.SendToFriend from :  %s  to:  %s", UserInfo.id, to_user_id))
        msg_data = {speakerIsMe=1, dialog=worldMsg.content, avatar=worldMsg.from_user_avatar, nickname=worldMsg.from_user_nickname, level=worldMsg.level or 1, channel=worldMsg.channel, from=worldMsg.from_user_id, to=worldMsg.to_user_id}
        -- table.insert( CodepkuChatChannel.Messages, msg_data)
        CodepkuChatChannel.SetMessage(msg_data);
        CodepkuChatChannel.client:SendMsg(worldMsg); 
    end
end