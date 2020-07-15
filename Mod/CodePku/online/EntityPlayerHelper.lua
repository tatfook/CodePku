--[[
Title: EntityPlayerHelper
Author(s): wxa
Date: 2020/6/30
Desc: 实体玩家辅助类, 此类实现本应做为基类(EntityPlayer),  为了不更改基础类引入新类, 通过类组合实现相关需求
use the lib:
------------------------------------------------------------
NPL.load("Mod/CodePku/online/EntityPlayerHelper.lua");
local AppEntityPlayerHelper = commonlib.gettable("Mod.CodePku.Online.EntityPlayerHelper");
-------------------------------------------------------
]]
NPL.load("Mod/GeneralGameServerMod/Core/Common/Log.lua");
NPL.load("Mod/GeneralGameServerMod/Core/Common/Config.lua");
local Config = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Config");
local Log = commonlib.gettable("Mod.GeneralGameServerMod.Core.Common.Log");
local EntityPlayerHelper = commonlib.inherit(nil, commonlib.gettable("Mod.CodePku.Online.EntityPlayerHelper"));
local EntityMob = commonlib.gettable("MyCompany.Aries.Game.EntityManager.EntityMob")  -- for npc


function EntityPlayerHelper:Init(entityPlayer, isMainPlayer)
    self.entityPlayer = entityPlayer;
    self.isMainPlayer = isMainPlayer;
    return self;
end

function EntityPlayerHelper:GetEntityPlayer()
    return self.entityPlayer;
end

function EntityPlayerHelper:GetPlayerInfo()
    return self:GetEntityPlayer():GetPlayerInfo();
end

function EntityPlayerHelper:GetUserInfo() 
    return self:GetPlayerInfo().userinfo or {};
end

function EntityPlayerHelper:SetPlayerInfo(playerInfo)
    local oldPlayerInfo = self:GetPlayerInfo();
    -- 显示信息是否更改
    local isSetHeadOnDisplay = playerInfo.state and playerInfo.username and (oldPlayerInfo.state ~= playerInfo.state or oldPlayerInfo.username ~= playerInfo.username);
    
    -- 设置玩家信息
    self:GetEntityPlayer():SetSuperPlayerInfo(playerInfo);

    -- 设置显示
    if (isSetHeadOnDisplay) then self:SetHeadOnDisplay(); end
end


-- 名称颜色： 队友 (蓝色), 好友 (绿色), 其他角色(白色), NPC(橙色)		
MyHeadOnTextColor = "255 255 255"			
TeamHeadOnTextColor = "0 0 255"
FriendHeadOnTextColor = "0 128 0" 
OtherHeadOnTextColor = "255 255 255"
NPCHeadOnTextColor = "255 165 0"

RandomHeadOnTextColors = {TeamHeadOnTextColor, FriendHeadOnTextColor, NPCHeadOnTextColor}


-- 设置头顶信息
function EntityPlayerHelper:SetHeadOnDisplay()
    local player = self:GetEntityPlayer();
    local playerInfo = self:GetPlayerInfo();
    local userinfo = self:GetUserInfo();
    local username = playerInfo.username;
    local state = playerInfo.state;
    local isVip = userinfo.isVip;
    Log:Info("username: %s, state: %s, vip: %s", username, state, isVip);

    objColor = RandomHeadOnTextColors[math.random(#RandomHeadOnTextColors)]
    local color = state == "online" and (self.isMainPlayer and MyHeadOnTextColor or objColor) or MyHeadOnTextColor;
    local textWidth = _guihelper.GetTextWidth(username, System.DefaultLargeFontString);
    local vipIconUrl = "Texture/Aries/Creator/keepwork/chat/vip_32bits.png#0 0 18 18";
    local mcml = string.format([[
<pe:mcml>
    <div style="margin-left:-%spx;margin-top:-30px">
        <pe:if condition="%s"><div style="float:left;width:16px;height:16px;background:url(%s);"></div></pe:if>
        <div style="float:left; margin-left: 2px; margin-top: -3px; color: %s; font-size: 16px;">%s</div>
    </div>
</pe:mcml>
    ]], (textWidth + 2) / 2 + (isVip and 8 or 0), isVip and "true" or "false", vipIconUrl, color, username);
    player:SetHeadOnDisplay({url=ParaXML.LuaXML_ParseString(mcml)});
end


function EntityMob:ShowHeadOnDisplay(bShow)
    local obj = self:GetInnerObject();
	System.ShowHeadOnDisplay(true, obj, self:GetDisplayName(), NPCHeadOnTextColor);	
    return obj;
end