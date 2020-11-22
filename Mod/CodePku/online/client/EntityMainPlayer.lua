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

NPL.load("Mod/CodePku/online/client/EntityPlayerHelper.lua");
local AppEntityPlayerHelper = commonlib.gettable("Mod.CodePku.Online.Client.EntityPlayerHelper");

NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityMainPlayer.lua");
local EntityMainPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer"), commonlib.gettable('Mod.CodePku.Online.Client.EntityMainPlayer'))

-- 获取玩家同步信息的频率  33 = 1s   tick = 30fps
-- 该值决定同步包的间隔时长
function EntityMainPlayer:GetMotionSyncTickCount()
    local count = tonumber(Mod.CodePku.BasicConfigTable.ggs_motion_sync_tick_count or 10);
    -- LOG.std("CodePku", "info", "EntityMainPlayer:GetMotionSyncTickCount", count)
    return count;
end

-- 获取玩家位置同步的帧距离, 移动多长距离记为1帧, 或理解为小于该值没有移动
-- 该值决定单次同步帧的数量, 若为0, 不丢帧, 若为无穷大则丢弃两次同步间的中间帧, 若指定值, 则同步指定间隔的关键帧
function EntityMainPlayer:GetMotionMinDistance()
    -- 为零玩家一直处于运动状态  若此是频率为1, 则帧同步同本地完全一致
    local distance = tonumber(Mod.CodePku.BasicConfigTable.ggs_motion_min_distance or 0.01);
    -- LOG.std("CodePku", "info", "EntityMainPlayer:GetMotionMinDistance", distance)
    return distance;
end


-- 构造函数
function EntityMainPlayer:ctor()    
    self.appEntityPlayerHelper = AppEntityPlayerHelper:new():Init(self, true);

    GameLogic.GetFilters():add_filter("ggs", function(msg)
        if (type(msg) == "table" and msg.action == "UpdateUserInfo") then
            local userinfo = msg.userinfo;
            self:SetSuperPlayerInfo({userinfo = userinfo});      
            self.appEntityPlayerHelper:SetHeadOnDisplay();      
        end
        return msg;
    end);
end

-- 设置玩家信息
function EntityMainPlayer:SetPlayerInfo(playerInfo)
    self.appEntityPlayerHelper:SetPlayerInfo(playerInfo);
end

-- 设置父类玩家信息
function EntityMainPlayer:SetSuperPlayerInfo(playerInfo)
    EntityMainPlayer._super.SetPlayerInfo(self, playerInfo);
end
