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
NPL.load("Mod/GeneralGameServerMod/App/Client/AppEntityPlayerHelper.lua");

local EntityOtherPlayer = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.EntityOtherPlayer"), commonlib.gettable("Mod.CodePku.Online.Client.EntityOtherPlayer"));

local moduleName = "Mod.CodePku.Online.Client.EntityOtherPlayer";

-- 构造函数
function EntityOtherPlayer:ctor()    
    self:SetCheckCollision(false);
end

function EntityOtherPlayer:IsCanClick() 
    return true;
end

-- 玩家被点击
function EntityOtherPlayer:OnClick(x,y,z, mouse_button,entity,side)
    local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
    MainUIButtons.show_interact_ui(self)
    return true;
end