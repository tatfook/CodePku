--[[
Title: EntityOtherPlayer
Author(s): John mai
Date: 2020/7/9
Desc: 非主玩家实体类, 主实现非主玩家相关操作
use the lib:
------------------------------------------------------------
NPL.load("Mod/CodePku/online/client/EntityOtherPlayer.lua");
local EntityOtherPlayer = commonlib.gettable("Mod.CodePku.Online.Client.EntityOtherPlayer");
-------------------------------------------------------
]]
NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityOtherPlayer.lua");
NPL.load("(gl)Mod/CodePku/cellar/Common/CommonFunc/CommonFunc.lua")
NPL.load("Mod/CodePku/online/client/EntityPlayerHelper.lua");

local AppEntityPlayerHelper = commonlib.gettable("Mod.CodePku.Online.Client.EntityPlayerHelper");
local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")
local EntityOtherPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityOtherPlayer"), commonlib.gettable("Mod.CodePku.Online.Client.EntityOtherPlayer"));

local moduleName = "Mod.CodePku.Online.Client.EntityOtherPlayer";

EntityOtherPlayer.isIOSPlatform = CommonFunc.isIOSPlatform()

-- 构造函数
function EntityOtherPlayer:ctor()    
    self.appEntityPlayerHelper = AppEntityPlayerHelper:new():Init(self, false);
    self:SetCheckCollision(false);
end

function EntityOtherPlayer:IsCanClick() 
    return true;
end

-- 玩家被点击
function EntityOtherPlayer:OnClick(x,y,z, mouse_button,entity,side)
    if EntityOtherPlayer.isIOSPlatform then
        -- 因好友搜索问题，暂时屏蔽ios渠道好友功能
        return true;
    else 
        local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
        MainUIButtons.show_interact_ui(self)
        return true;
    end 
end

-- 设置玩家信息
function EntityOtherPlayer:SetPlayerInfo(playerInfo)
    self.appEntityPlayerHelper:SetPlayerInfo(playerInfo);
end

-- 设置父类用户信息
function EntityOtherPlayer:SetSuperPlayerInfo(playerInfo)
    EntityOtherPlayer._super.SetPlayerInfo(self, playerInfo);
end
