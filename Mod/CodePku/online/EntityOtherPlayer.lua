--[[
Title: EntityOtherPlayer
Author(s): John mai
Date: 2020/7/9
Desc: 非主玩家实体类, 主实现非主玩家相关操作
use the lib:
------------------------------------------------------------
NPL.load("Mod/CodePku/online/EntityOtherPlayer.lua");
local EntityOtherPlayer = commonlib.gettable("Mod.CodePku.Online.EntityOtherPlayer");
-------------------------------------------------------
]]
NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityOtherPlayer.lua");
NPL.load("Mod/CodePku/online/EntityPlayerHelper.lua");
local EntityPlayerHelper = commonlib.gettable("Mod.CodePku.Online.EntityPlayerHelper");
local EntityOtherPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityOtherPlayer"), commonlib.gettable("Mod.CodePku.Online.EntityOtherPlayer"));

local moduleName = "Mod.CodePku.Online.EntityOtherPlayer";

-- 构造函数
function EntityOtherPlayer:ctor()
    self.entityPlayerHelper = EntityPlayerHelper:new():Init(self, false);
end

-- 玩家被点击
function EntityOtherPlayer:OnClick(x,y,z, mouse_button,entity,side)
    -- info = self:GetPlayerInfo()
    -- echo(info.userinfo.id)

    local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
    MainUIButtons.show_interact_ui(self)
    return true;
end

-- 是否可以被点击
function EntityOtherPlayer:IsCanClick() 
    return true;
end

-- 设置玩家信息
function EntityOtherPlayer:SetPlayerInfo(playerInfo)
    self.entityPlayerHelper:SetPlayerInfo(playerInfo);
end

-- 获取用户名
function EntityOtherPlayer:GetUserName()
    return self:GetPlayerInfo().username;
end

-- 设置父类用户信息
function EntityOtherPlayer:SetSuperPlayerInfo(playerInfo)
    EntityOtherPlayer._super.SetPlayerInfo(self, playerInfo);
end

TeamHeadOnTextColor = "0 0 255"
FriendHeadOnTextColor = "0 128 0" 
OtherHeadOnTextColor = "255 255 255"
length_limit = 7
RandomHeadOnTextColors = {TeamHeadOnTextColor, FriendHeadOnTextColor, OtherHeadOnTextColor}

function EntityOtherPlayer:CreateInnerObject(...)
	local obj = EntityOtherPlayer._super.CreateInnerObject(self, self:GetMainAssetPath(), true, 0, 1);

    objColor = RandomHeadOnTextColors[math.random(#RandomHeadOnTextColors)]

    display_name = self:GetDisplayName()
    if(#display_name > 7) then
        display_name = string.sub(display_name,1,length_limit)
    end

	if(self:IsShowHeadOnDisplay() and System.ShowHeadOnDisplay) then
		System.ShowHeadOnDisplay(true, obj, display_name, objColor);	
	end
	return obj;
end