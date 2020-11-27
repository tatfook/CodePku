--[[
Title: EntityPlayerHelper
Author(s): wxa
Date: 2020/6/30
Desc: 实体玩家辅助类, 此类实现本应做为基类(EntityPlayer),  为了不更改基础类引入新类, 通过类组合实现相关需求
use the lib:
------------------------------------------------------------
NPL.load("Mod/CodePku/online/client/EntityPlayerHelper.lua");
local AppEntityPlayerHelper = commonlib.gettable("Mod.CodePku.Online.Client.EntityPlayerHelper");
-------------------------------------------------------
]]
NPL.load("(gl)script/ide/headon_speech.lua");
local UniString = commonlib.gettable("System.Core.UniString");

local EntityPlayerHelper = commonlib.inherit(nil, commonlib.gettable("Mod.CodePku.Online.Client.EntityPlayerHelper"));

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
    if (isSetHeadOnDisplay) then 
        self:SetHeadOnDisplay(); 
    end
end

local function GetUserName(text)
    if type(text) ~= 'string' then
        return ''
    end

    local utf8Text = UniString:new(text)

    if _guihelper.GetTextWidth(text) > 112 then
        return utf8Text:sub(1, 8).text .. '...'
    else
        return text
    end
end

-- 设置头顶信息
function EntityPlayerHelper:SetHeadOnDisplay()
    local player = self:GetEntityPlayer();
    local playerInfo = self:GetPlayerInfo();
    local userinfo = self:GetUserInfo();
    local username = userinfo.nickname or playerInfo.username;
    local state = playerInfo.state;
    local usertag = state == "online" and userinfo.usertag or "";
    -- local color = state == "online" and (self.isMainPlayer and "#ffffff" or "#0cff05") or "#b1b1b1";
    local color = self.isMainPlayer and "#ffffff" or "#0cff05";
    local playerUsernameStyle = state == "online" and "" or "shadow-quality:8; shadow-color:#2b2b2b;text-shadow:true;";
    local tagColor = userinfo.is_employee and "#ff0000" or "#3CAAF0"
    local tagName = ""

    local LiveLessonBasic = NPL.load("(gl)Mod/CodePku/cellar/GUI/LiveLesson/Basic/LiveLessonBasic.lua")
    if LiveLessonBasic.windowLeft then
        tagName = userinfo.is_employee and "教师" or "学生"
    end
    local schoolName = userinfo.schoolName or "";
    if (schoolName ~= "") then schoolName = "&lt;" .. schoolName .. "&gt;" end
    local mcml = string.format([[
        <pe:mcml>
            <div style="width:200px; margin-left: -100px; margin-top: -30px; color: %s;">
                <div align="center" style="">
                    %s
                    <span style="float:left; margin-left: 2px; font-weight:bold; font-size: 14px; base-font-size:14px; color: #ffffff; background-color:%s">%s</span>
                    <div style="float:left; margin-left: 2px; font-weight:bold; font-size: 14px; base-font-size:14px; %s">%s</div>
                </div>
                <div style="text-align: center; font-weight: bold; font-size: 12px; base-font-size:12px; margin-top: 0px;">%s</div>
            </div>
        </pe:mcml>
            ]], color, usertag, tagColor, tagName, playerUsernameStyle, GetUserName(username), schoolName)
    player:SetHeadOnDisplay({url = ParaXML.LuaXML_ParseString(mcml)});
end

