--[[
Title: 联机模块 
Author(s): John Mai
Date: 2020-07-10 16:23:49
Desc: 玩学世界联机模块
Example:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/online/main.lua");
local Online = commonlib.gettable("Mod.CodePku.Online");
Online:init();
-------------------------------------------------------
]]

NPL.load("(gl)Mod/GeneralGameServerMod/main.lua"); 
NPL.load("(gl)Mod/CodePku/online/client/GeneralGameClient.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");
NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasic.lua")
local LiveLessonBasic = commonlib.gettable("Mod.CodePku.Common.LiveLessonBasic")
local LiveLessonSettlement = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Settlement/LiveLessonSettlement.lua");
local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");

local GeneralGameServerMod = commonlib.gettable("Mod.GeneralGameServerMod");
local GeneralGameClient = commonlib.gettable("Mod.CodePku.Online.Client.GeneralGameClient");
local Online = commonlib.gettable("Mod.CodePku.Online");
local Commands = commonlib.gettable("MyCompany.Aries.Game.Commands");
local CmdParser = commonlib.gettable("MyCompany.Aries.Game.CmdParser")
local Packets = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Packets")

function ParseOption(cmd_text)
	local value, cmd_text_remain = cmd_text:match("^%s*%-([%w_]+%S+)%s*(.*)$");
	if(value) then
		return value, cmd_text_remain;
	end
	return nil, cmd_text;
end

function ParseOptions(cmd_text)
	local options = {};
	local option, cmd_text_remain = nil, cmd_text;
	while(cmd_text_remain) do
		option, cmd_text_remain = ParseOption(cmd_text_remain);
		if(option) then
			key, value = option:match("([%w_]+)=?(%S*)");
			if (value == "true" or key == option) then 
				options[key] = true;
			elseif (value == "false") then 
				options[key] = false;
			else
				options[key] = value;
			end
		else
			break;
		end
	end
	return options, cmd_text_remain;
end

function Online:Init()
	GeneralGameServerMod:RegisterClientClass("CodePku", GeneralGameClient);
	self:RegisterCommand();
end
function Online:RegisterCommand()
    Commands["connectCodePku"] = {
		mode_deny = "",  
		name="connectCodePku",
		quick_ref="/connectCodePku [worldId] [parallelWorldName]", 
		desc=[[进入联机玩学世界 
worldId 为世界ID(未指定或为0则联机当前世界或默认世界)
parallelWorldName 平行世界名, 可选. 指定世界的副本世界
示例:
connectCodePku                        # 联机进入当前世界或默认世界
connectCodePku 145                    # 联机进入世界ID为145的世界
connectCodePku 145 parallel           # 联机进入世界ID为145的平行世界 parallel
]], 
		handler = function(cmd_name, cmd_text, cmd_params, fromEntity)		
			local ggsCmd = string.format("/ggs connect -app=CodePku %s", cmd_text)
			commonlib.setfield("System.Codepku.isGGSConnecting",true)
            GameLogic.RunCommand(string.format("/ggs connect -app=CodePku %s", cmd_text))
		end,
	}

	Commands["wanxueshijie"] = {
		mode_deny = "",
		name = "wanxueshijie",
		quick_ref = "/wanxueshijie subcmd",
		desc = [[
subcmd: 
worldInfo 获取玩学世界当前所有世界分线数据
    /wanxueshijie worldInfo 获取玩学世界当前所有世界分线数据
worldKey 获取玩学世界当前世界信息
	/wanxueshijie worldKey 获取玩学世界当前世界信息
		]],
		handler = function(cmd_name, cmd_text, cmd_params, fromEntity)
			GGS.INFO.Format(cmd_name .. " " .. cmd_text)
            local cmd, cmd_text = CmdParser.ParseString(cmd_text)
			local netHandler = GeneralGameServerMod:GetClientClass("CodePku"):GetWorldNetHandler()
			if not netHandler then
				return
			end
			if (cmd == "worldInfo") then
				netHandler:AddToSendQueue(Packets.PacketGeneral:new():Init({action = "WanXueShiJie", data = { cmd = "WorldInfo"}}))
			elseif (cmd == "worldKey") then
				netHandler:AddToSendQueue(Packets.PacketGeneral:new():Init({action = "WanXueShiJie", data = { cmd = "WorldKey"}}))
			end
		end
	}

	Commands["liveLesson"] = {
		mode_deny = "",
		name = "liveLesson",
		quick_ref = "/liveLesson subcmd",
		desc = [[
subcmd: 
redflower 奖励/扣除小红花
entrance 用户进入直播课世界广播
behavior 学生举手/举牌√/举牌x
toteacher 发起学生移动到老师位置的请求需要配合movestudent
movestudent 配合toteacher移动学生到老师位置
movegroup 移动一个小组的学生到指定位置
call 老师集合学生
kickout 老师踢出学生到主世界
forceplaymode 老师设置某个学生为播放模式
settlement 老师结算广播
classover 老师下课广播
	]],
	handler = function(cmd_name, cmd_text, cmd_params, fromEntity)
		GGS.INFO.Format(cmd_name .. " " .. cmd_text)
		local cmd, cmd_text = CmdParser.ParseString(cmd_text)
		local options = ParseOptions(cmd_text)

		if (cmd == "redflower") then
			local _type = options.type --1=增加,2=减少
			local num = options.num or 1
			local username = options.username
			local userid = options.userid

			local text = string.format("恭喜 %s 获得了老师奖励的小红花", username, num)
			if _type == "1" then
				LiveLessonBasic:RunGGSCommand("broadcast", {text=text})
			end

		elseif (cmd == "entrance") then
			local username = options.username
			local isteacher = options.isteacher
			local userid = options.userid

			local text = nil
			if isteacher then
				text = string.format("教师 %s 进来了", username)
			else
				text = string.format("学生 %s 进来了", username)
			end
			if username and username ~= "" and text then
				LiveLessonBasic:RunGGSCommand("broadcast", {text=text})
			end

			--todo 刷新学员列表的本地缓存/重新请求一次

		elseif (cmd == "behavior") then
			local _type = options.type and tonumber(options.type) --1=举手,2=举牌√,3=举牌x
			local username = options.username
			local userid = options.userid and tonumber(options.userid)
			local entityid = options.entityid and tonumber(options.entityid)

			if _type then
				local text = string.format("%s%s", username, LiveLessonBasic.behaviorTable[_type])
				LiveLessonBasic:RunGGSCommand("broadcast", {text=text})

				LiveLessonBasic:SetHeadOnDisplay(entityid,_type,userid)
			end

		elseif (cmd == "toteacher") then
			local userid = options.userid
			local EM = GameLogic.EntityManager
			local player = EM.GetPlayer()
			if player and LiveLessonBasic:GetIentity() then
				local x, y, z = player:GetBlockPos()
				local position = string.format("%s,%s,%s",x,y,z)
				--todo LiveLessonBasic:GetIentity() 额外加一个判定是房间创建者老师
				GameLogic.RunCommand(string.format("/ggs cmd liveLesson movestudent -userid=%s -position=%s", userid, position))
			end

		elseif (cmd == "movestudent") then
			local userid = options.userid
			local position = options.position
			if userid == tostring(System.User.info.id) then
				GameLogic.RunCommand(string.format("/goto %s", position))
			end

		elseif (cmd == "movegroup") then
			local group = options.group
			local position = options.position
			--todo 分组System.Codepku.liveLessonGroup
			--教研用
			if group and group == System.Codepku.liveLessonGroup then
				-- test
				local text = string.format("%s%s", group, L"组移动请求")
				LiveLessonBasic:RunGGSCommand("broadcast", {text=text})
				GameLogic.RunCommand(string.format("/goto %s", position))
			end

		elseif (cmd == "call") then
			local position = options.position
			local r = options.r
			local x, y, z = string.match(position, "(%d+),(%d+),(%d+)")
			local userid = System.User.info.id
			local index = LiveLessonBasic:GetStudentIndexByUserId(userid)
			if index then
				local studentsCount = #LiveLessonBasic:GetStudents()
				local a = (index-1)*(360/studentsCount)
				local x1 = math.floor(x + r * math.cos(a * math.pi / 180))
				local z1 = math.floor(z + r * math.sin(a * math.pi / 180))
				local position_new = string.format("%s,%s,%s", x1, y, z1)
				GameLogic.RunCommand(string.format("/goto %s", position_new))
				GameLogic.RunCommand(string.format("/lookat %s", position))
			end

		elseif (cmd == "kickout") then
			local userid = options.userid
			if userid == tostring(System.User.info.id) then
				GameLogic.RunCommand(string.format("/connectCodePku %s", 1))
			end

		elseif (cmd == "forceplaymode") then
			local userid = options.userid
			if userid == tostring(System.User.info.id) then
				GameLogic.RunCommand(string.format("/mode %s", "game"))
			end

		elseif (cmd == "settlement") then
			LiveLessonSettlement:StudentSettlement()

		elseif (cmd == "classover") then
			LiveLessonSettlement:ClassOverTimer()
		end
	end
}

end
