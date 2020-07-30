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
NPL.load("Mod/GeneralGameServerMod/App/Client/AppEntityPlayerHelper.lua");
local EntityPlayerHelper = commonlib.gettable("Mod.GeneralGameServerMod.App.Client.AppEntityPlayerHelper");
local EntityMainPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityMainPlayer"), commonlib.gettable("Mod.CodePku.Online.EntityMainPlayer"));

local moduleName = "Mod.CodePku.Online.EntityMainPlayer";


MyHeadOnTextColor = "255 255 255"	
-- 设置联机情况下不同玩家颜色
function EntityMainPlayer:CreateInnerObject(...)
    local obj = EntityMainPlayer._super.CreateInnerObject(self, self:GetMainAssetPath(), true, 0, 1);

	userid = System.User.id
	self:SetPlayerInfo(info)

	local UserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfoPage")
	local UserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.UserInfo")
	UserInfoPage:GetUserInfo()

	local name = UserInfo.name or self:GetDisplayName()

	if(self:IsShowHeadOnDisplay() and System.ShowHeadOnDisplay) then
		System.ShowHeadOnDisplay(true, obj, name, MyHeadOnTextColor);	
	end
	return obj;
end
