--[[
Title: UserInfo
Author(s):  big
Date: 2018.06.21
place: Foshan
Desc: 
use the lib:
------------------------------------------------------------
local UserInfo = NPL.load("(gl)Mod/CodePku/cellar/UserConsole/UserInfo.lua")
------------------------------------------------------------
]]
local GameLogic = commonlib.gettable("MyCompany.Aries.Game.GameLogic")
local UserConsole = NPL.load("(gl)Mod/CodePku/cellar/UserConsole/Main.lua")
local CodePkuService = NPL.load("(gl)Mod/CodePku/service/CodePkuService.lua")
local Store = NPL.load("(gl)Mod/CodePku/store/Store.lua")

local UserInfo = NPL.export()

local default_avatars = {
    "boy01",
}

local DefaultBoyAvatars = {
    "boy01",
};

local DefaultGirlAvatars = {
    "girl01",
}

local cur_index = 1

function UserInfo.IsSignedIn()
    return CodePkuService:IsSignedIn()
end


function UserInfo.GetValidAvatarFilename(playerName)
    if (playerName) then
        NPL.load("(gl)script/apps/Aries/Creator/Game/Entity/PlayerAssetFile.lua")
        local PlayerAssetFile = commonlib.gettable("MyCompany.Aries.Game.EntityManager.PlayerAssetFile")
        PlayerAssetFile:Init()
        return PlayerAssetFile:GetValidAssetByString(playerName)
    end
end


local curIndex = 1
-- cycle through
-- @param btnName: if nil, we will load the default one if scene is not started.
function UserInfo:OnChangeAvatar(btnName)
    local UserConsolePage = Store:Get("page/UserConsole")

    local avatars = default_avatars;

    if System.User.info.gender == 1 then
        avatars = DefaultBoyAvatars;
    elseif System.User.info.gender == 2 then
        avatars = DefaultGirlAvatars;
    end
    
    if System.User.info.special_type == 1 then
        GameLogic.options:SetMainPlayerAssetName('codepku/model/LLS_AN.x')
    elseif System.User.info.special_type == 2 then
        GameLogic.options:SetMainPlayerAssetName('codepku/model/HLS_AN.x')
    elseif System.User.info.special_type == 3 then
        GameLogic.options:SetMainPlayerAssetName('codepku/model/WLS_AN.x')
    else
        filename = UserInfo.GetValidAvatarFilename(avatars[1])
        GameLogic.options:SetMainPlayerAssetName(filename)
    end

end
