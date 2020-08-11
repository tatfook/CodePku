--[[
Title: AppEntityOtherPlayer
Author(s): wxa
Date: 2020/7/9
Desc: 主玩家实体类, 主实现主玩家相关操作
use the lib:
------------------------------------------------------------
NPL.load("Mod/GeneralGameServerMod/App/Client/AppEntityMainPlayer.lua");
local AppEntityMainPlayer = commonlib.gettable("Mod.GeneralGameServerMod.App.Client.AppEntityMainPlayer");
-------------------------------------------------------
]]
NPL.load("Mod/GeneralGameServerMod/Core/Client/EntityMainPlayer.lua");
NPL.load("Mod/CodePku/online/EntityPlayerHelper.lua");
local EntityPlayerHelper = commonlib.gettable("Mod.CodePku.Online.EntityPlayerHelper");
local EntityMainPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer"), commonlib.gettable("Mod.CodePku.Online.EntityMainPlayer"));

local moduleName = "Mod.CodePku.Online.EntityMainPlayer";


-- 构造函数
function EntityMainPlayer:ctor()
    self.entityPlayerHelper = EntityPlayerHelper:new():Init(self, true);
end

-- 禁用默认用户名显示
function EntityMainPlayer:IsShowHeadOnDisplay()
    return true;
end

-- 玩家被点击
function EntityMainPlayer:OnClick()
end

-- 是否可以被点击
function EntityMainPlayer:IsCanClick() 
    return false;
end

-- 设置玩家信息
function EntityMainPlayer:SetPlayerInfo(playerInfo)
    self.entityPlayerHelper:SetPlayerInfo(playerInfo);
end

-- 设置父类玩家信息
function EntityMainPlayer:SetSuperPlayerInfo(playerInfo)
    EntityMainPlayer._super.SetPlayerInfo(self, playerInfo);
end



MyHeadOnTextColor = "255 255 255"	
-- 设置联机情况下不同玩家颜色
function EntityMainPlayer:CreateInnerObject(...)
    local obj = EntityMainPlayer._super.CreateInnerObject(self, self:GetMainAssetPath(), true, 0, 1);

	-- userid = System.User.id
	-- self:SetPlayerInfo(info)

	local name = System.User and System.User.nickName or self:GetDisplayName()

	if(self:IsShowHeadOnDisplay() and System.ShowHeadOnDisplay) then
		System.ShowHeadOnDisplay(true, obj, name, MyHeadOnTextColor);	
	end
	return obj;
end
