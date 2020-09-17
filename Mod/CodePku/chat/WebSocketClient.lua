--[[
Title: WebSocketClient
Author: leio
Date: 2020/4/27
Desc: this is a client to connect websocket server by websocket protocol http://tools.ietf.org/html/rfc6455
the implementation of frame is based on https://github.com/lipp/lua-websockets
-----------------------------------------------
test example: https://github.com/websockets/ws/blob/master/examples/express-session-parse/index.js#L58
local WebSocketClient = NPL.load("(gl)Mod/CodePku/chat/WebSocketClient.lua");
WebSocketClient.Connect("ws://localhost:3000");
-----------------------------------------------
]]
NPL.load("(gl)script/ide/EventDispatcher.lua");
NPL.load("(gl)script/ide/commonlib.lua");
NPL.load("(gl)script/ide/socket/url.lua");
NPL.load("(gl)script/ide/timer.lua");
local handshake = NPL.load("(gl)script/ide/System/os/network/WebSocket/handshake.lua");
local frame = NPL.load("(gl)script/ide/System/os/network/WebSocket/frame.lua");
local tools = NPL.load("(gl)script/ide/System/os/network/WebSocket/tools.lua");
local WebSocketClient = commonlib.inherit(commonlib.gettable("commonlib.EventSystem"), NPL.export());

local WebSocketClientMaps = {};
local ack_id_counter = -1;

function WebSocketClient:ctor()
    self.keepalive_interval = 10000;
    self.address_id = "id_" .. ParaGlobal.GenerateUniqueID();
    self.state = 'CLOSED';

    WebSocketClientMaps[self.address_id] = self;
end

function WebSocketClient:GetAddressID()
    return self.address_id;
end
function WebSocketClient:GetServerAddr()
	local server_addr = string.format("%s:tcp", self:GetAddressID());
    return server_addr;
end
function WebSocketClient:Connect(url)   
    if self.state == "OPEN" then
        return
    end
    local protocol,host,port,uri = tools.parse_url(url);

    local ws_protocols_tbl = {""}
    if type(ws_protocol) == "string" then
        ws_protocols_tbl = {ws_protocol}
    elseif type(ws_protocol) == "table" then
        ws_protocols_tbl = ws_protocol
    end

    local key = tools.generate_key();
    local req = handshake.upgrade_request({
            key = key,
            host = host,
            port = port,
            protocols = ws_protocols_tbl,
            origin = "",
            uri = uri
    })
    self.key = key;
    self.state = "CONNECTING";
    NPL.AddPublicFile("Mod/CodePku/chat/WebSocketClient.lua", -30);
	NPL.StartNetServer("0.0.0.0", "0");
	NPL.AddNPLRuntimeAddress({host = host, port = tostring(port), nid = self:GetAddressID()})
	
    if(NPL.activate_with_timeout(2, self:GetServerAddr(), req) == 0) then
    end
end

function WebSocketClient:HandleOpen()
    self.state = "OPEN";
    self:KeepAlive();

    self:DispatchEvent({type = "OnOpen" });
end
function WebSocketClient:KeepAlive()
    if(not self.timer)then
        self.timer = commonlib.Timer:new({callbackFunc = function(timer)
           
	        if(self.state == "OPEN")then
                self:Ping();
            end
        end})
        self.timer:Change(0, self.keepalive_interval);
    end
end
function WebSocketClient:HandleClose(nid, decoded)
    self.state = "CLOSED";
    self:DispatchEvent({type = "OnClose" });
end
function WebSocketClient:HandleMsg(nid, msg)
    self:DispatchEvent({type = "OnMsg", data = msg });
end

function WebSocketClient:IsConnected()
    return self.state == "OPEN";
end

function WebSocketClient:Ping()
    local result = self:SendPacket("ping",frame.PING);
    if(result ~= 0)then
        self.state = "CLOSED";
    end
end
-- send a msg to server
-- @param message: a lua table which is valid on json format
function WebSocketClient:SendMsg(message)
    message = NPL.ToJson(message);
    self:SendPacket(message)
end
-- send a packet to server
function WebSocketClient:SendPacket(message,opcode)
    local encoded = frame.encode(message,opcode or frame.TEXT,true)
    return NPL.activate(self:GetServerAddr(),encoded);
end

function WebSocketClient:HandlePong(nid,decoded)

end

function WebSocketClient:HandlePacket(nid,decoded,fin,opcode)    
    if(opcode == frame.CLOSE)then
        self:HandleClose(nid,decoded)
    elseif (opcode == frame.PONG)then
        self:HandlePong(nid,decoded)
    elseif (opcode == frame.TEXT)then
        local out = {};
        if(NPL.FromJson(decoded, out)) then
            self:HandleMsg(nid,out);
        end
    else
		LOG.std("", "warn", "WebSocketClient", "%s received an unknown msg with opcode:%s", tostring(nid), tostring(opcode));
    end
end
local function activate()
    --LOG.std("", "debug", "WebSocketClient OnMsg", msg);
    local nid = msg.nid;
    if(not nid)then
		LOG.std("", "error", "WebSocketClient", "activate nid is nil");
        return
    end
    local client = WebSocketClientMaps[nid];
    if(not client)then
        return
    end
    local response = msg[1];
    
    -- waitting for handshake
    if(client.state == "CONNECTING")then
        local headers = handshake.http_headers(response)
		LOG.std("", "info", "WebSocketClient", "waitting for handshake:%s", client.key);
        local expected_accept = handshake.sec_websocket_accept(client.key)
        if (headers["sec-websocket-accept"] ~= expected_accept) then
            -- handshake failed
	        LOG.std("", "error", "WebSocketClient", "handshake failed");
	        LOG.std("", "info", "WebSocketClient response", response);
            client:HandleClose(nid)
            return
        end
        client:HandleOpen();
    else        
        local nid = msg.nid;
        local decoded,fin,opcode = frame.decode(response);        
        client:HandlePacket(nid,decoded,fin,opcode)
    end
    
end
NPL.this(activate)