--[[
Title: 联机客户端
Author(s): John Mai
Date: 2020-07-10 16:23:49
Desc: 玩学世界联机客户端
Example:
------------------------------------------------------------

-------------------------------------------------------
]]

NPL.load("Mod/GeneralGameServerMod/Core/Client/GeneralGameWorld.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Connection.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Common.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Client/NetClientHandler.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityMainPlayer.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityOtherPlayer.lua");
local NetClientHandler = commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.NetClientHandler");
local EntityMainPlayer = commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer");
local EntityOtherPlayer = commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityOtherPlayer");
local EntityMob = commonlib.gettable("MyCompany.Aries.Game.EntityManager.EntityMob")  -- for npc
local Common = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Common");
local Log = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Log");
local Connection = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Connection");

NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")

local Config = NPL.load("(gl)Mod/CodePku/Online/Config.lua");

local GeneralGameWorld = commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.GeneralGameWorld");
local Packets = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Packets");

local OnlineClient = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"), commonlib.gettable("Mod.CodePku.OnlineClient"));

function OnlineClient:ctor()
    self.inited = false;
    self.options = {};
end

function OnlineClient:Init()

    LOG.std(nil, "info", "CodePku", "OnlineClient init")

    if (self.inited) then return self end;

    -- 禁用服务器 指定为客户端
    NPL.StartNetServer("127.0.0.1", "0");

    -- 监听世界加载完成事件
    GameLogic:Connect("WorldLoaded", self, self.OnWorldLoaded, "UniqueConnection");

    -- 禁用点击继续
    GameLogic.options:SetClickToContinue(false);

    self.inited = true;
    return self;
end

function OnlineClient:Exit()
    GameLogic:Disconnect("WorldLoaded", self, self.OnWorldLoaded, "DisconnectOne");
end

-- 获取世界类
function OnlineClient:GetGeneralGameWorldClass()
    return GeneralGameWorld;
end
-- 获取网络处理类
function OnlineClient:GetNetClientHandlerClass()
    return NetClientHandler;
end
-- 获取主玩家类
function OnlineClient:GetEntityMainPlayerClass()
    return EntityMainPlayer;
end
-- 获取其它玩家类
function OnlineClient:GetEntityOtherPlayerClass()
    return EntityOtherPlayer;
end

function OnlineClient:LoadWorld(options)
    -- 初始化
    self:Init();

    -- 保存选项
    self.options = options;

    -- 设定世界ID 优先取当前世界ID  其次用默认世界ID
    local curWorldId = GameLogic.options:GetProjectId();

    -- 确定世界ID
    options.worldId = options.worldId or curWorldId or Config.defaultOnlineServer.defaultWorldId;
    options.username = options.username or self:GetUserInfo().username;
    -- only reload world if world id does not match
    local isReloadWorld = options.worldId ~= curWorldId; 
    local worldId = options.worldId;

    -- 退出旧世界
    if (self.world) then self.world:OnExit(); end

    -- 标识替换, 其它方式loadworld不替换
    self.IsReplaceWorld = true;

    if (isReloadWorld) then
        if (options.url)then
            local InternetLoadWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.InternetLoadWorld")
            local RemoteWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.RemoteWorld")
            local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")

            local world = RemoteWorld.LoadFromHref(options.url, "self")
            local function LoadWorld(world, refreshMode)
                if world then
                    if refreshMode == 'never' then
                        if not LocalService:IsFileExistInZip(world:GetLocalFileName(), ":worldconfig.txt") then
                            refreshMode = 'force'
                        end
                    end

                    local url = world:GetLocalFileName()               
                    DownloadWorld.ShowPage(url)
                    echo("loadworld")
                    echo(world)
                    local mytimer = commonlib.Timer:new(
                        {
                            callbackFunc = function(timer)
                                InternetLoadWorld.LoadWorld(
                                    world,
                                    nil,
                                    refreshMode or "auto",
                                    function(bSucceed, localWorldPath)
                                        DownloadWorld.Close()
                                    end
                                )
                            end
                        }
                    );
                    -- prevent recursive calls.
                    mytimer:Change(1,nil);
                else
                    _guihelper.MessageBox(L"无效的世界文件");
                end
            end

            LoadWorld(world, 'auto');
        else
            GameLogic.RunCommand(string.format("/loadworld %d", worldId));
        end
    else
        self:OnWorldLoaded();
    end
end

-- 世界加载
function OnlineClient:OnWorldLoaded() 
    -- 是否需要替换世界
    if (not self.IsReplaceWorld) then return end
    self.IsReplaceWorld = false;

    -- 更新当前世界ID
    local GeneralGameWorldClass = self:GetGeneralGameWorldClass() or GeneralGameWorld;
    self.world = GeneralGameWorldClass:new():Init(self);
    GameLogic.ReplaceWorld(self.world);

    -- 登录世界
    if (self.options.ip and self.options.port) then
        self.world:Login(self.options);
    else
        self:ConnectControlServer(self.options); -- 连接控制器服务, 获取世界服务
    end
end
--  正确流程: 登录成功 => 加载打开世界 => 替换世界


-- 连接控制服务器
function OnlineClient:ConnectControlServer(options)
    Log:Debug("ServerIp: %s, ServerPort: %s", Config.defaultOnlineServer.host, Config.defaultOnlineServer.port);
    self.controlServerConnection = Connection:new():InitByIpPort(Config.defaultOnlineServer.host, Config.defaultOnlineServer.port, self);
    self.controlServerConnection:SetDefaultNeuronFile("Mod/GeneralGameServerMod/Core/Server/ControlServer.lua");
    self.controlServerConnection:Connect(5, function(success)
        if (not success) then
            return Log:Info("无法连接控制器服务器");
        end

        self.controlServerConnection:AddPacketToSendQueue(Packets.PacketWorldServer:new():Init({
            worldId = worldId,
            parallelWorldName = options.parallelWorldName,
        }));
    end);
end

-- 发送获取世界服务器
function OnlineClient:handleWorldServer(packetWorldServer)
    local options = self.options;
    options.ip = packetWorldServer.ip or Config.defaultOnlineServer.host;
    options.port = packetWorldServer.port or Config.defaultOnlineServer.port;
    if (not options.ip or not options.port) then
        Log:Info("服务器繁忙, 暂无合适的世界服务器提供");
        return;
    end

    -- 登录世界
    self.world:Login(options);

    -- 关闭控制服务器的链接
    self.controlServerConnection:CloseConnection();
end

-- 获取当前认证用户信息
function OnlineClient:GetUserInfo()
    return System.User;
end

-- 获取当前系统世界信息
function OnlineClient:GetWorldInfo()
    -- return {};
end


-- 名称颜色： 队友 (蓝色), 好友 (绿色), 其他角色(白色), NPC(橙色)		
MyHeadOnTextColor = "255 255 255"			
TeamHeadOnTextColor = "0 0 255"
FriendHeadOnTextColor = "0 128 0" 
OtherHeadOnTextColor = "255 255 255"
NPCHeadOnTextColor = "255 165 0"

RandomHeadOnTextColors = {TeamHeadOnTextColor, FriendHeadOnTextColor, OtherHeadOnTextColor}

-- 设置联机情况下不同玩家颜色 -- 该方法暂未生效，预留给后面切换颜色使用
function EntityMainPlayer:ShowHeadOnDisplay(bShow)
    local obj = self:GetInnerObject();
	System.ShowHeadOnDisplay(true, obj, self:GetDisplayName(), MyHeadOnTextColor);	
    return obj;
end


function EntityOtherPlayer:ShowHeadOnDisplay(bShow)
    local obj = self:GetInnerObject();
    objColor = RandomHeadOnTextColors[math.random(#RandomHeadOnTextColors)]
	System.ShowHeadOnDisplay(true, obj, self:GetDisplayName(), objColor);	
    return obj;
end


function EntityMob:ShowHeadOnDisplay(bShow)
    local obj = self:GetInnerObject();
	System.ShowHeadOnDisplay(true, obj, self:GetDisplayName(), NPCHeadOnTextColor);	
    return obj;
end


-- 设置联机情况下不同玩家颜色 -- 进入界面时生效
function EntityMainPlayer:CreateInnerObject(...)
	local obj = EntityMainPlayer._super.CreateInnerObject(self, self:GetMainAssetPath(), true, 0, 1);

	if(self:IsShowHeadOnDisplay() and System.ShowHeadOnDisplay) then
		System.ShowHeadOnDisplay(true, obj, self:GetDisplayName(), MyHeadOnTextColor);	
	end
	return obj;
end


function EntityOtherPlayer:CreateInnerObject(...)
	local obj = EntityOtherPlayer._super.CreateInnerObject(self, self:GetMainAssetPath(), true, 0, 1);

    objColor = RandomHeadOnTextColors[math.random(#RandomHeadOnTextColors)]

	if(self:IsShowHeadOnDisplay() and System.ShowHeadOnDisplay) then
		System.ShowHeadOnDisplay(true, obj, self:GetDisplayName(), objColor);	
	end
	return obj;
end

function EntityOtherPlayer:OnClick(x, y, z, mouse_button)
    local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
    MainUIButtons.show_interact_ui(self)
    
end


-- 初始化成单列模式
OnlineClient:InitSingleton();