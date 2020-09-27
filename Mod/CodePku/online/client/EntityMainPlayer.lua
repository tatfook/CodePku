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
local EntityMainPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer"), commonlib.gettable('Mod.CodePku.Online.Client.EntityMainPlayer'))

-- 获取玩家同步信息的频率  33 = 1s   tick = 30fps
function EntityMainPlayer:GetMotionSyncTickCount()
    local count = tonumber(Mod.CodePku.BasicConfigTable.ggs_motion_sync_tick_count or 10);
    -- LOG.std("CodePku", "info", "EntityMainPlayer:GetMotionSyncTickCount", count)
    return count;
end