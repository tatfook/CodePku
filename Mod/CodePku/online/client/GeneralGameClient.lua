NPL.load("Mod/GeneralGameServerMod/Core/Client/GeneralGameClient.lua");
NPL.load("Mod/CodePku/online/client/EntityOtherPlayer.lua");
NPL.load("Mod/CodePku/online/client/EntityMainPlayer.lua");
NPL.load("Mod/CodePku/online/client/NetClientHandler.lua");

local NetClientHandler = commonlib.gettable("Mod.CodePku.Online.Client.NetClientHandler");
local Packets = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Packets");
local EntityMainPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityMainPlayer");
local EntityOtherPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityOtherPlayer");
local GeneralGameClient = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.GeneralGameClient"), commonlib.gettable("Mod.CodePku.Online.Client.GeneralGameClient"));
local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");

function GeneralGameClient:ctor()
    self.userinfo = System.User;

    GameLogic.GetFilters():add_filter("ggs", function(msg)
        if (type(msg) == "table" and msg.action == "UpdateNickName") then
            self.userinfo.username = msg.nickname;
            self.userinfo.nickname = msg.nickname;
        end
        return msg;
    end);
end

function GeneralGameClient:Init()
    if (self.inited) then return end

    GeneralGameClient._super.Init(self);

    self:GetOptions().serverIp = Config.defaultOnlineServer.host;
    self:GetOptions().serverPort = Config.defaultOnlineServer.port;

    self.inited = true;
end

function GeneralGameClient:AddAssetsWhiteList()
    self.GetAssetsWhiteList().AddAsset("codepku/model/HLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/LLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/WLS_AN.x");
    self.GetAssetsWhiteList().AddAsset("character/CC/02human/paperman/Female_teachers.x");
    self.GetAssetsWhiteList().AddAsset("character/CC/02human/paperman/Male_teacher.x");
    self.GetAssetsWhiteList().AddAsset("character/CC/02human/paperman/xiaolong.x");
    self.GetAssetsWhiteList().AddAsset("character/CC/02human/paperman/zaizai.x");
    self.GetAssetsWhiteList().AddAsset("character/CC/02human/paperman/nuannuan.x");
    self.GetAssetsWhiteList().AddAsset("character/v3/Npc/Hashiqi/Hashiqi.x");
    self.GetAssetsWhiteList().AddAsset("character/CC/03animals/frog/frog.x");
    self.GetAssetsWhiteList().AddAsset("character/v5/10mobs/HaqiTown/Alexander/Alexander.x");
    self.GetAssetsWhiteList().AddAsset("character/v5/02animals/Panda/Panda.x");
    self.GetAssetsWhiteList().AddAsset("character/v6/02animals/Yangtuo/Yangtuo.x");
        
    self.GetAssetsWhiteList().AddAsset("character/v3/GameNpc/FCSQ2/FCSQ.x");
    self.GetAssetsWhiteList().AddAsset("character/v3/GameNpc/ZZYH/ZZYH.x");
    self.GetAssetsWhiteList().AddAsset("character/v3/GameNpc/GTCK/GTCK.x");
    self.GetAssetsWhiteList().AddAsset("character/v5/02animals/FireBon/FireBon.x");

    self.GetAssetsWhiteList().AddAsset("character/v5/02animals/BlueDragon/BlueDragon.x");
    self.GetAssetsWhiteList().AddAsset("character/v3/Item/ObjectComponents/GemBuffEffect/12883_teen_gem_buff_effect_level3.anim.x");

    -- 课件军事基地白名单
    self.GetAssetsWhiteList().AddAsset("codepku/model/blue-1-GM.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/blue-2-GM.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/red-1-GM.x");
    self.GetAssetsWhiteList().AddAsset("codepku/model/red-2-GM.x");
    
end

-- 加载世界
function GeneralGameClient:LoadWorld(opts, loadworld)
    -- 初始化
    self:Init();
    
    local worldName = opts and opts.worldName
    local oldWorldName = self:GetOptions().worldName
    -- opts.worldKey =(opts.worldId or "1").."_"..(opts.worldName or "1").."_"..(opts.no or "1")

    -- 覆盖默认选项
    local options = self:SetOptions(opts);
    -- 设定世界ID 优先取当前世界ID  其次用默认世界ID
    local curWorldId = System and System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.keepwork_project_id

    -- 确定世界ID
    options.worldId = tostring(opts.worldId or curWorldId or options.defaultWorldId);
    options.worldName = tostring(opts.worleName ~= "" and opts.worldName or 1)
    options.no = tostring(opts.no ~= "" and opts.no or 1)

    options.username = options.username or self:GetUserInfo().username;
    options.ip = opts.ip;            -- ip port 每次重写
    options.port = opts.port;     -- 以便动态获取
    -- 每次登陆世界如果没有输入serverip或serverport就重置两者为默认设置，防止上一次的缓存干扰登陆服务器的选择
    options.serverIp = (opts.serverIp and opts.serverIp ~= "") and opts.serverIp or Config.defaultOnlineServer.host;
    options.serverPort = (opts.serverPort and opts.serverPort ~= "") and opts.serverPort or Config.defaultOnlineServer.port;

    -- todo 临时处理，重置同步设置
    options.isSyncBlock = opts.isSyncBlock
    options.isSyncCmd = opts.isSyncCmd

    options.reload = opts.reload    -- 每次刷新是否重新加载世界
    options.manual = opts.manual    -- 每次刷新是否主动切换世界数据(是否是在分线界面跳转的世界连接)

    --当跳转分线的时候才强制初始化options.worldkey,其余的时候不用
    if tonumber(options.manual) == 1 then
        options.worldKey = opts.worldKey or ((options.worldId or "1").."_"..(options.worldName or "1").."_"..(options.no or "1")) -- worldKey每次重写
    else
        options.worldKey = opts.worldKey
    end

  
    -- 打印选项值
    -- GGS.INFO(options);
    -- only reload world if world id does not match
    local isReloadWorld = tostring(options.worldId) ~= tostring(curWorldId) or options.reload
    -- 退出旧世界
    if (self:GetWorld()) then 
        -- 不同世界或者未登录则重新进入世界
        if (self:GetWorld():GetWorldId() == options.worldId and (worldName == oldWorldName or (not worldname))) or (not self:GetWorld():IsLogin()) then
            -- 退出旧世界
            echo("exitworld")
            self:GetWorld():OnExit()
        end
    end

    -- 标识替换, 其它方式loadworld不替换
    self.IsReplaceWorld = true
    
    if isReloadWorld then
        self:ReplaceWorld(opts)
    else
        self:OnWorldLoaded()
    end

    -- 分线链接结束之后将manual置位空
    options.manual = nil
    --ggs链接结束之后将链接中变量置位false
    commonlib.setfield("System.Codepku.isGGSConnecting",false)
end

-- 获取主玩家类
function GeneralGameClient:GetEntityMainPlayerClass()
    return EntityMainPlayer;
end

-- 获取其它玩家类
function GeneralGameClient:GetEntityOtherPlayerClass()
    return EntityOtherPlayer;
end

-- 是否可以飞行
function GeneralGameClient:IsCanFly()
    return false;
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

-- 获取网络处理类
function GeneralGameClient:GetNetClientHandlerClass()
    return NetClientHandler;
end

-- 初始化成单列模式
GeneralGameClient:InitSingleton();