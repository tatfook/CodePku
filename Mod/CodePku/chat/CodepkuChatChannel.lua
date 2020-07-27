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

local CodepkuConfig = NPL.load("(gl)Mod/CodePku/config/Config.lua")
local CodepkuChatChannel = NPL.export();


CodepkuChatChannel.channels = {
    system = 1, -- 系统通知
    world = 2,  -- 世界
    nearby = 3, -- 附近、本地
    guild = 4,  -- 工会
    school = 5, -- 学校
}

CodepkuChatChannel.worldId_pending = nil;
CodepkuChatChannel.worldId = nil;
CodepkuChatChannel.client = nil;

function CodepkuChatChannel.StaticInit()
    LOG.std("", "info", "CodepkuChatChannel", "StaticInit");

	GameLogic:Connect("WorldLoaded", CodepkuChatChannel, CodepkuChatChannel.OnWorldLoaded, "UniqueConnection");

    GameLogic.GetFilters():remove_filter("OnCodepkuLogin", CodepkuChatChannel.OnCodepkuLogin_Callback);
    GameLogic.GetFilters():remove_filter("OnCodepkuLogout", CodepkuChatChannel.OnCodepkuLogout_Callback);
    GameLogic.GetFilters():add_filter("OnCodepkuLogin", CodepkuChatChannel.OnCodepkuLogin_Callback);
    GameLogic.GetFilters():add_filter("OnCodepkuLogout", CodepkuChatChannel.OnCodepkuLogout_Callback)    
end

function CodepkuChatChannel.OnWorldLoaded()
    -- local id = WorldCommon.GetWorldTag("kpProjectId");
    -- 课件id
    local id = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
	LOG.std(nil, "info", "CodepkuChatChannel", "OnWorldLoaded: %s",tostring(id));
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
    return CodepkuConfig.defaultSocketServer .. string.format("?token=%s", System.User.codepkuToken);
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
	LOG.std("", "debug", "CodepkuChatChannel OnMsg", msg);
    if(not msg or not msg.data)then
        return
    end
    msg = msg.data;
    echo('receieve message:', msg)
    -- todo codepku change
    -- see: script/apps/GameServer/socketio/packet.lua
    local eio_pkt_name = msg.eio_pkt_name;
    local sio_pkt_name = msg.sio_pkt_name;
    if(eio_pkt_name == "message" and sio_pkt_name =="event")then
        local body = msg.body or {};
        local key = body[1] or {};
        local info = body[2] or {};
        local payload = info.payload;
        local meta = info.meta;
        local action = info.action;
        local userInfo = info.userInfo;

        if(key == "app/msg" or key == "paracraftGlobal" )then
            if(payload and userInfo)then


                local worldId = payload.worldId;
                local type = payload.type;
                local content = payload.content;

                local userId = payload.id;
                local username = payload.username;
                local vip = payload.vip;
                local student = payload.student;
                local orgAdmin = payload.orgAdmin;
                local tLevel = payload.tLevel;

                if(not CodepkuChatChannel.IsInWorld())then
                    return
                end
                if(CodepkuChatChannel.worldId ~= worldId)then
                    return
                end
                

                local timestamp = CodepkuChatChannel.GetTimeStamp(meta.timestamp);
       
                local ChannelIndex;
                if(type == 2)then
                    ChannelIndex = ChatChannel.EnumChannels.KpNearBy;
                elseif(type == 3)then
                    ChannelIndex = ChatChannel.EnumChannels.KpBroadCast;
                end
                local channelname = ChatChannel.channels[ChannelIndex];
                local msgdata = { ChannelIndex = ChannelIndex, words = content, channelname = channelname, 
                vip = vip, student = student, orgAdmin = orgAdmin, tLevel = tLevel, 
                timestamp = timestamp, kp_from_name = username, kp_from_id = userId, kp_id = CodepkuChatChannel.GetUserId(), is_keepwork = true, }
                ChatChannel.AppendChat( msgdata)

                
                if(CodepkuChatChannel.BulletScreenIsOpened() and CodepkuChatChannel.IsInWorld())then
                    local mcmlStr = CodepkuChatChannel.CreateMcmlStrToTipRoad(msgdata);
                    TipRoadManager:PushNode(mcmlStr);
                end

                local profile = KeepWorkItemManager.GetProfile()
                -- 消耗喇叭，在这里同步数据
                if(userId == profile.id and ChannelIndex == ChatChannel.EnumChannels.KpBroadCast)then
                    KeepWorkItemManager.ReLoadItems({10002,10001});
                end
            end
        elseif(key == "broadcast")then
            -- system broadcast
            if(info.data and info.data.msg)then
                local content = info.data.msg.text;
                content = string.gsub(content, "<p>","");
                content = string.gsub(content, "</p>","");
                local username = L"管理员";
                local ChannelIndex = ChatChannel.EnumChannels.KpSystem;
                local channelname = ChatChannel.channels[ChannelIndex];
                local msgdata = { ChannelIndex = ChannelIndex, words = content, channelname = channelname, kp_from_name = username, is_keepwork = true, }
                ChatChannel.AppendChat( msgdata)

                 if(CodepkuChatChannel.BulletScreenIsOpened() and CodepkuChatChannel.IsInWorld())then
                    local mcmlStr = CodepkuChatChannel.CreateMcmlStrToTipRoad(msgdata);
                    TipRoadManager:PushNode(mcmlStr);
                end
            end
        elseif(key == "msg")then
            -- system broadcast to user

            --[[
            {
                  meta={ timestamp="2020-06-11 16:56" },
                  payload={
                    all=0,
                    createdAt="2020-06-11T08:56:11.211Z",
                    extra={  },
                    id=969,
                    msg={ text="<p>666</p>", type=0 },
                    operator="kevinxft",
                    organizationId=0,
                    receivers="zhangleio,zhangleio2",
                    roleId=0,
                    sendSms=0,
                    sender=0,
                    type=0,
                    updatedAt="2020-06-11T08:56:11.211Z" 
                  } 
                }
            ]]
            if(payload and payload.receivers and payload.msg)then
                local receivers = payload.receivers;
                local user_info = KeepWorkItemManager.GetProfile();
                if(not CodepkuChatChannel.HasUserName(receivers, user_info.username))then
                    return
                end
                local timestamp = CodepkuChatChannel.GetTimeStamp(meta.timestamp);
                local content = payload.msg.text;
                content = string.gsub(content, "<p>","");
                content = string.gsub(content, "</p>","");
                local ChannelIndex = ChatChannel.EnumChannels.KpSystem;
                local channelname = ChatChannel.channels[ChannelIndex];
                local msgdata = { ChannelIndex = ChannelIndex, words = content, channelname = channelname, is_keepwork = true, }
                ChatChannel.AppendChat( msgdata)

                if(CodepkuChatChannel.BulletScreenIsOpened() and CodepkuChatChannel.IsInWorld())then
                    local mcmlStr = CodepkuChatChannel.CreateMcmlStrToTipRoad(msgdata);
                    TipRoadManager:PushNode(mcmlStr);
                end
            end
        end
        
    end
    
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
-- create a chat message
-- @param ChannelIndex	频道索引
-- @param to			接受者nid
-- @param toname		接受者名字,可为nil
-- @param words			消息内容
-- http://yapi.kp-para.cn/project/60/interface/api/1952
function CodepkuChatChannel.CreateMessage( ChannelIndex, to, toname, words)
	local msgdata;
    local target = CodepkuChatChannel.GetRoom();
    local worldId = CodepkuChatChannel.worldId;
    if(not worldId)then
		LOG.std(nil, "warn", "CodepkuChatChannel", "world id is required");
        return
    end
    if(ChannelIndex == ChatChannel.EnumChannels.KpNearBy)then
	    msgdata = { ChannelIndex = ChannelIndex, target = target, worldId = worldId, words = words, type = 2, is_keepwork = true, };

    elseif(ChannelIndex == ChatChannel.EnumChannels.KpBroadCast)then
	    msgdata = { ChannelIndex = ChannelIndex, target = "paracraftGlobal", worldId = worldId, words = words, type = 3, is_keepwork = true, };
    else
		LOG.std(nil, "warn", "CodepkuChatChannel", "[%s] unsupported channel index in CodepkuChatChannel.SendMessage", tostring(ChannelIndex));
    end
	return msgdata;
end


--[[---------------------------------------------------------------------------------------------------
根据消息类型分别发送至服务器
--]]---------------------------------------------------------------------------------------------------
function CodepkuChatChannel.SendToServer(msgdata)
    if(not msgdata)then
        return
    end
    if(type(msgdata) ~= "table")then
        return
    end
    local user_info = KeepWorkItemManager.GetProfile();

    local kp_msg = {
        target = msgdata.target,
        payload = {
            content = msgdata.words,
            worldId = msgdata.worldId,
            type = msgdata.type,

            id = user_info.id,
            username = user_info.username,
            vip = user_info.vip,
            student = user_info.student,
            orgAdmin = user_info.orgAdmin,
            tLevel = user_info.tLevel,
        },
    }

    CodepkuChatChannel.client:Send(kp_msg);
   
end