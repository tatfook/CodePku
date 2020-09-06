--[[
Title: OnlineClient
Author(s): John Mai
Date: 2020/8/2
Desc: 客户端入口文件
use the lib:
------------------------------------------------------------
NPL.load("Mod/CodePku/online/OnlineClient.lua");
local OnlineClient = commonlib.gettable("Mod.CodePku.Online.OnlineClient");
-------------------------------------------------------
]]
NPL.load("Mod/GeneralGameServerMod/Core/Common/Connection.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Common.lua");
NPL.load("Mod/CodePku/online/EntityOtherPlayer.lua");
NPL.load("Mod/CodePku/online/EntityMainPlayer.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Client/GeneralGameClient.lua");

local OnlineClient = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.GeneralGameClient"), commonlib.gettable("Mod.CodePku.Online.OnlineClient"));
local EntityMainPlayer = commonlib.gettable("Mod.CodePku.Online.EntityMainPlayer");
local EntityOtherPlayer = commonlib.gettable("Mod.CodePku.Online.EntityOtherPlayer");
local Common = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Common");
local Log = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Log");
local Connection = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Connection");

local Config = NPL.load("(gl)Mod/CodePku/online/Config.lua");

local Packets = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Packets");

local moduleName = "Mod.CodePku.Online.OnlineClient";

-- 构造函数
function OnlineClient:ctor()

end

-- 初始化函数
function OnlineClient:Init()
    if (self.inited) then return end

    -- 基类初始化
    OnlineClient._super.Init(self);

    self.GetAssetsWhiteList().AddAsset("codepku/model/HLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/LLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/WLS_AN.x");

    self:GetOptions().serverIp = Config.defaultOnlineServer.host;
    self:GetOptions().serverPort = Config.defaultOnlineServer.port;

    -- self:GetOptions().ip = Config.defaultOnlineServer.host;
    -- self:GetOptions().port = Config.defaultOnlineServer.port;
    self.inited = true;
end

-- 获取世界类
function OnlineClient:GetGeneralGameWorldClass()
    return OnlineClient._super.GetGeneralGameWorldClass(self);  -- 不定制
end
-- 获取网络处理类
function OnlineClient:GetNetClientHandlerClass()
    return OnlineClient._super.GetNetClientHandlerClass(self);  -- 不定制
end

-- 获取主玩家类
function OnlineClient:GetEntityMainPlayerClass()
    return EntityMainPlayer;
end
-- 获取其它玩家类
function OnlineClient:GetEntityOtherPlayerClass()
    return EntityOtherPlayer;
end

-- 获取当前认证用户信息
function OnlineClient:GetUserInfo()
    return System.User;
end

-- 是否是匿名用户 移除匿名功能
function OnlineClient:IsAnonymousUser()    
    return false;
end

function OnlineClient:LoadWorld(opts)
    -- 初始化
    self:Init();
    local worldUrl = opts.worldUrl;
    -- 保存选项
    local options = self:SetOptions(opts);

    -- 设定世界ID 优先取当前世界ID  其次用默认世界ID
    local curWorldId = GameLogic.options:GetProjectId();

    -- 确定世界ID
    options.worldId = tostring(options.worldId or curWorldId or Config.defaultOnlineServer.defaultWorldId);
    options.username = options.username or self:GetUserInfo().username;

    -- 打印选项值
    Log:Info(options);

    -- only reload world if world id does not match
    local isReloadWorld = tostring(options.worldId) ~= tostring(curWorldId); 

    -- 退出旧世界
    if (self:GetWorld()) then 
        -- 相同世界且已登录直接跳出
        if (not IsDevEnv and self:GetWorld():IsLogin() and self:GetWorld():GetWorldId() == options.worldId) then return end
        -- 退出旧世界
        self:GetWorld():OnExit(); 
    end


    -- 标识替换, 其它方式loadworld不替换
    self.IsReplaceWorld = true;

    if (isReloadWorld) then
        if (worldUrl)then
            local InternetLoadWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.InternetLoadWorld")
            local RemoteWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.RemoteWorld")
            local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")

            local world = RemoteWorld.LoadFromHref(worldUrl, "self")
            local function LoadWorld(world, refreshMode)
                if world then
                    if refreshMode == 'never' then
                        if not LocalService:IsFileExistInZip(world:GetLocalFileName(), ":worldconfig.txt") then
                            refreshMode = 'force'
                        end
                    end

                    local url = world:GetLocalFileName()               
                    DownloadWorld.ShowPage(url)                    
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
            GameLogic.RunCommand(string.format("/loadworld %d", options.worldId));
        end
    else
        self:OnWorldLoaded();
    end
end

-- 初始化成单列模式
OnlineClient:InitSingleton();