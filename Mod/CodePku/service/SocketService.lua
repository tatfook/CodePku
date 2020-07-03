--[[
Title: SocketService
Author(s):  big
Date:  2019.10.30
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/WorldShare/service/SocketService.lua")
local SocketService = commonlib.gettable("Mod.WorldShare.service.SocketService")
------------------------------------------------------------
]]
local NetworkMain = commonlib.gettable("MyCompany.Aries.Game.Network.NetworkMain")

local SocketService = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"), commonlib.gettable("Mod.CodePku.service.SocketService"))

SocketService:Property({"onlineMsgInterval", 5000, "GetOnlineMsgInterval", "SetOnlineMsgInterval", auto = true})
SocketService:Property({"isStartedUDPService", false, "IsUDPStarted", "SetUDPStarted", auto = true})
SocketService:Signal("SocketServiceStarted")

SocketService.externalIPList = nil
SocketService.uuid = ''

-- start socket service
function SocketService:StartUDPService()
	if self:IsUDPStarted() then
		return false
	end

	NPL.AddPublicFile("Mod/CodePku/service/SocketService.lua", 302)

	local att = NPL.GetAttributeObject()

	-- start udp server
	local port = 8099
	local i = 0

	while not att:GetField("IsUDPServerStarted") and i <= 20 do
		att:SetField("EnableUDPServer", port + i)
		i = i + 1
	end

	local ipList = att:GetField("ExternalIPList")
	ipList = commonlib.split(ipList, ",")
	self.externalIPList = ipList

	self.uuid = System.Encoding.guid.uuid()

	self:SetUDPStarted(true)
	self:SocketServiceStarted()
end

-- send who online msg request
function SocketService:SendUDPWhoOnlineMsg()
	Mod.CodePku.Store:Remove('user/udpServerList')

	local att = NPL.GetAttributeObject()
	local broadcastAddressList = att:GetField("BroadcastAddressList")
	broadcastAddressList = commonlib.split(broadcastAddressList, ",")

	local defaultPort = 8099

	for i = 0, 20 do
		local port = defaultPort + i

		-- broadcast all host
		local serverAddrList = { "(gl)*" .. port .. ":Mod/CodePku/service/SocketService.lua" }

		for key, value in pairs(broadcastAddressList) do
			table.insert(serverAddrList, string.format("(gl)\\\\%s %d:Mod/CodePku/service/SocketService.lua", value, port))
		end

		for key, value in pairs(serverAddrList) do
			-- send udp msg
			NPL.activate(value, { isWorldShareMsg = true, type = "ONLINE", result = "WHO" }, 1, 2, 0)
		end
	end
end

function SocketService:SendUDPIamOnlineMsg(ip, port)
	if not NetworkMain:IsServerStarted() or NetworkMain.tunnelClient then
		return false
	end

	self:SendUDPMsg(
		{
			type = "ONLINE",
			result = "IAM",
			username = "nil",
			serverName = "nil",
			uuid = self.uuid,
			worldHost = NetworkMain.server_manager.curHost,
			worldPort = NetworkMain.server_manager.curPort
		},
		ip,
		port
	)
end

-- send udp msg
function SocketService:SendUDPMsg(params, ip, port)
	if type(params) ~= 'table' then
		return false
	end

	params.isWorldShareMsg = true

	NPL.activate("(gl)\\\\" .. ip .. " " .. port .. ":Mod/CodePku/service/SocketService.lua", params , 1, 2, 0)
end

-- receive udp msg
function SocketService:ReceiveUDPMsg(msg)
	if type(msg) ~= 'table' or not msg.isUDP or not msg.isWorldShareMsg then
		return false
	end

	if msg.type == 'ONLINE' then
		if msg.result == "WHO" then
			local ip, port = string.match(msg.nid, "~udp(.+)_(%d+)")

			if not ip or not port then
				return false
			end

			self:SendUDPIamOnlineMsg(ip, port)
		end

		if msg.result == "IAM" then
			local udpIp, udpPort = string.match(msg.nid, "~udp(.+)_(%d+)")
			
			if not udpIp or not udpPort then
				return false
			end

			if not msg.uuid or not msg.worldHost or not msg.worldPort then
				return false
			end

			-- exclude self
			if msg.uuid == self.uuid then
				return false
			end

			local udpServerList = Mod.CodePku.Store:Get('user/udpServerList') or {}

			for key, item in ipairs(udpServerList) do
				if item.uuid == msg.uuid then
					return false
				end
			end

			udpServerList[#udpServerList + 1] = { ip = udpIp, port = msg.worldPort, username = msg.username, serverName = msg.serverName, uuid = msg.uuid }

			Mod.CodePku.Store:Set('user/udpServerList', udpServerList)
		end
	end
end

NPL.this(function()
	SocketService:ReceiveUDPMsg(msg)
end)