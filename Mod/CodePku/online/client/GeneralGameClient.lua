NPL.load("Mod/GeneralGameServerMod/Core/Client/GeneralGameClient.lua");
NPL.load("Mod/CodePku/online/client/EntityOtherPlayer.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");

local EntityOtherPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityOtherPlayer");
local GeneralGameClient = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.GeneralGameClient"), commonlib.gettable("Mod.CodePku.Online.Client.GeneralGameClient"));
local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");
local Log = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Log");

function GeneralGameClient:ctor()
    self.userinfo = System.User;

    GameLogic.GetFilters():add_filter("ggs", function(msg)
        if (type(msg) == "table" and msg.action == "UpdateNickName") then
            self.userinfo.nickname = msg.nickname;
        end
        return msg;
    end);
end

function GeneralGameClient:Init()
    if (self.inited) then return end

    GeneralGameClient._super.Init(self);

    self.GetAssetsWhiteList().AddAsset("codepku/model/HLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/LLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/WLS_AN.x");

    self:GetOptions().serverIp = Config.defaultOnlineServer.host;
    self:GetOptions().serverPort = Config.defaultOnlineServer.port;

    self.inited = true;
end

function GeneralGameClient:LoadWorld(opts)
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

    local options = self:GetOptions();
    self.userinfo.nickname = options.nickname or self.userinfo.nickname;
end

-- 获取其它玩家类
function GeneralGameClient:GetEntityOtherPlayerClass()
    return EntityOtherPlayer;
end

-- 获取当前认证用户信息
-- 此函函数返回用户信息会在各玩家间同步, 所以尽量精简
function GeneralGameClient:GetUserInfo()
    return self.userinfo;
end

-- 是否是匿名用户
function GeneralGameClient:IsAnonymousUser()
    return false;
end

-- 获取当前世界类型
function GeneralGameClient:GetWorldType()
    return "World";
end

-- 初始化成单列模式
GeneralGameClient:InitSingleton();