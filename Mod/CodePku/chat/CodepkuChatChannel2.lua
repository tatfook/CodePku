--[[
Title: codepku channel for chat
Author(s): huangjunming
Date: 2020/11/24
Desc:  
Use Lib:
-------------------------------------------------------
-- test after login codepku
local CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");
CodepkuChatChannel.StaticInit();
local CodepkuChatChannel = NPL.load("(gl)Mod/CodePku/chat/CodepkuChatChannel.lua");
local id = 618;
CodepkuChatChannel.Connect(nil,nil,function()
    CodepkuChatChannel.JoinWorld(id);
end);
-------------------------------------------------------
]]

local GameLogic = commonlib.gettable("MyCompany.Aries.Game.GameLogic")
local WebSocketClient = NPL.load("(gl)Mod/CodePku/chat/WebSocketClient.lua");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

local CodepkuConfig = NPL.load("(gl)Mod/CodePku/config/Config.lua")
local CodepkuChatChannel = NPL.export();

function CodepkuChatChannel.StaticInit()
    LOG.std("", "info", "CodepkuChatChannel", "StaticInit");

	GameLogic:Connect("WorldLoaded", CodepkuChatChannel, CodepkuChatChannel.OnWorldLoaded, "UniqueConnection");

    GameLogic.GetFilters():remove_filter("OnCodepkuLogin", CodepkuChatChannel.OnCodepkuLogin_Callback);
    GameLogic.GetFilters():remove_filter("OnCodepkuLogout", CodepkuChatChannel.OnCodepkuLogout_Callback);
    GameLogic.GetFilters():add_filter("OnCodepkuLogin", CodepkuChatChannel.OnCodepkuLogin_Callback);
    GameLogic.GetFilters():add_filter("OnCodepkuLogout", CodepkuChatChannel.OnCodepkuLogout_Callback)    
    GameLogic.GetFilters():add_filter("codepkuAwardUser", CodepkuChatChannel.OnCodepkuUserAward)
end

function CodepkuChatChannel.SetMessage(_table, message, index)
    -- todo
end

function CodepkuChatChannel.OnCodepkuUserAward(data)
    -- msg1 = {msgContent=sysMsg,heightPx=math.ceil(commonlib.utf8.len(sysMsg)/28)*46,msgType='sys'}
    props = data['props']
    data_array = {}
    if (props) then
        for _i=1,#props do
            if (props[_i]['prop_num']>0) then
                table.insert(data_array,{msgType='get',heightPx=46,itemType=1,dataLen=165+commonlib.utf8.len(props[_i]['prop_name'])*26,itemName=props[_i]['prop_name'],itemNum=props[_i]['prop_num']})
            end
        end 
    end

    total_exp = data['total_exp']
    if (total_exp>0) then
        table.insert(data_array,{msgType='get',heightPx=46,itemType=2,dataLen=165+commonlib.utf8.len(data['total_exp_name'])*26,itemName=data['total_exp_name'],itemNum=total_exp})
    end
    subject_exp = data['subject_exp']
    if (subject_exp>0) then
        table.insert(data_array,{msgType='get',heightPx=46,itemType=2,dataLen=165+commonlib.utf8.len(data['subject_name'])*26,itemName=data['subject_name'],itemNum=subject_exp})
    end
    
    for _i=1,#data_array do 
        CodepkuChatChannel.SetMessage(channelsMap.system, data_array[_i], 1)
    end    
end

function CodepkuChatChannel.OnWorldLoaded()
    local id = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
    
    if (id) then
        id = tonumber(id);
        CodepkuChatChannel.worldId_pending = id;
        -- connect chat channel
        CodepkuChatChannel.OnCodepkuLogin_Callback();    
    end    
end

function CodepkuChatChannel.OnCodepkuLogin_Callback()
    CodepkuChatChannel.Connect(nil,nil,function()
        CodepkuChatChannel.JoinWorld(CodepkuChatChannel.worldId_pending);
    end);    
end


function CodepkuChatChannel.OnCodepkuLogout_Callback()
    CodepkuChatChannel.LeaveWorld(CodepkuChatChannel.worldId_pending);
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
end

function CodepkuChatChannel.GetUrl()
    local coursewareId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
    return CodepkuConfig.defaultSocketServer .. string.format("?world_id=%s", tostring(coursewareId));
end

function CodepkuChatChannel.GetUserId()
    return System.User.id;  
end

function CodepkuChatChannel.GetRoom()
    if(CodepkuChatChannel.worldId) then
        local room = string.format("__world_%s__",tostring(CodepkuChatChannel.worldId));
        return room
    end
end

function CodepkuChatChannel.Connect(onopen_callback)    
    if(not System.User.codepkuToken) then
        return
    end
    
    url = CodepkuChatChannel.GetUrl();
    if(not CodepkuChatChannel.client) then        
        CodepkuChatChannel.client = WebSocketClient:new():Init(url, System.User.codepkuToken);
        CodepkuChatChannel.client:AddEventListener("OnOpen",CodepkuChatChannel.OnOpen,CodepkuChatChannel);
        CodepkuChatChannel.client:AddEventListener("OnMsg",CodepkuChatChannel.OnMsg,CodepkuChatChannel);
        CodepkuChatChannel.client:AddEventListener("OnClose",CodepkuChatChannel.OnClose,CodepkuChatChannel);        
    end
    
    options = options or {};
    CodepkuChatChannel.onopen_callback = onopen_callback;
    if (CodepkuChatChannel.client.state == "OPEN") then
        CodepkuChatChannel.OnOpen();
        return
    end
    CodepkuChatChannel.client:Connect();
end

function CodepkuChatChannel.OnOpen(self)
	LOG.std("", "info", "CodepkuChatChannel", "OnOpen");
    if(CodepkuChatChannel.onopen_callback)then
        CodepkuChatChannel.onopen_callback();
    end
    CodepkuChatChannel.RefreshChatWindow();
end

function CodepkuChatChannel.OnClose(self)
	LOG.std("", "info", "CodepkuChatChannel", "OnClose");   
end

function CodepkuChatChannel.OnMsg(self, msg)
    if(not msg or not msg.data)then
        return
    end
    msg = msg.data;
    -- todo on message
end

function CodepkuChatChannel.IsConnected()
    return CodepkuChatChannel.client and CodepkuChatChannel.client:IsConnected()
end

function CodepkuChatChannel.IsInWorld()
    if(CodepkuChatChannel.worldId and CodepkuChatChannel.IsConnected())then
        return true;
    end
end

-- refresh for showing or hiding chat channel
function CodepkuChatChannel.RefreshChatWindow()
    -- todo
end