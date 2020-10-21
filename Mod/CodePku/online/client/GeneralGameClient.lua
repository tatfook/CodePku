NPL.load("Mod/GeneralGameServerMod/Core/Client/GeneralGameClient.lua");
NPL.load("Mod/CodePku/online/client/EntityOtherPlayer.lua");
NPL.load("Mod/CodePku/online/client/EntityMainPlayer.lua");

local EntityMainPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityMainPlayer");
local EntityOtherPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityOtherPlayer");
local GeneralGameClient = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.GeneralGameClient"), commonlib.gettable("Mod.CodePku.Online.Client.GeneralGameClient"));
local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");

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
end

-- 获取主玩家类
function GeneralGameClient:GetEntityMainPlayerClass()
    return EntityMainPlayer;
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