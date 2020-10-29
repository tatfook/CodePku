--[[
Title: EntityOtherPlayer
Author(s): huang junming 
Date: 2020/09/22
Desc: 主玩家实体类, 主实现主玩家相关操作
use the lib:
------------------------------------------------------------
NPL.load("Mod/CodePku/online/client/EntityMainPlayer.lua");
local EntityMainPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityMainPlayer");
-------------------------------------------------------
]]

NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityMainPlayer.lua");
NPL.load("Mod/GeneralGameServerMod/App/Client/AppEntityPlayerHelper.lua");
local EntityPlayerHelper = commonlib.gettable("Mod.GeneralGameServerMod.App.Client.AppEntityPlayerHelper");
local EntityMainPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer"), commonlib.gettable('Mod.CodePku.Online.Client.EntityMainPlayer'))

-- 获取玩家同步信息的频率  33 = 1s   tick = 30fps
function EntityMainPlayer:GetMotionSyncTickCount()
    local count = tonumber(Mod.CodePku.BasicConfigTable.ggs_motion_sync_tick_count or 10);
    -- LOG.std("CodePku", "info", "EntityMainPlayer:GetMotionSyncTickCount", count)
    return count;
end


-- 构造函数
function EntityMainPlayer:ctor()
    self.EntityPlayerHelper = EntityPlayerHelper:new():Init(self, true);

    GameLogic.GetFilters():add_filter("ggs", function(msg)
        if (type(msg) == "table" and msg.action == "UpdateUserInfo") then
            local userinfo = msg.userinfo;
            self:SetSuperPlayerInfo({userinfo = userinfo});
            self.EntityPlayerHelper:SetHeadOnDisplay();
        end
        return msg;
    end);
end

-- 设置玩家信息
function EntityMainPlayer:SetPlayerInfo(playerInfo)
    self.EntityPlayerHelper:SetPlayerInfo(playerInfo);
end

-- 设置父类玩家信息
function EntityMainPlayer:SetSuperPlayerInfo(playerInfo)
    EntityMainPlayer._super.SetPlayerInfo(self, playerInfo);
end
