--[[
Title: login
Author(s):  junming
Date: 2020/05/27
Desc: 
use the lib:
------------------------------------------------------------
local UserConsole = NPL.load("(gl)Mod/CodePku/cellar/UserConsole/Main.lua")
------------------------------------------------------------
]]

local InternetLoadWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.InternetLoadWorld")
local RemoteWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.RemoteWorld")
local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")
local SaveWorldHandler = commonlib.gettable("MyCompany.Aries.Game.SaveWorldHandler")
local GameMainLogin = commonlib.gettable("MyCompany.Aries.Game.MainLogin")

local WorldShare = commonlib.gettable("Mod.CodePku")
local Encoding = commonlib.gettable("commonlib.Encoding")

local UserInfo = NPL.load("./UserInfo.lua")
local CodePkuServiceSession = NPL.load("(gl)/Mod/CodePku/service/CodePkuService/session.lua")
local CodePkuService = NPL.load("(gl)/Mod/CodePku/service/CodePkuService.lua")

local UserConsole = NPL.export()

function UserConsole:courseEntry()

    if not self.notFirstTimeShown then
        -- check is signin
        if not CodePkuService:IsSignedIn() and CodePkuServiceSession:GetCurrentUserToken() then
            UserInfo:LoginWithToken()
            return false
        end

        -- for protocol
        if not CodePkuService:IsSignedIn() and CodePkuServiceSession:GetUserTokenFromUrlProtocol() then
            UserInfo:LoginWithToken()
            return false
        end

        if not CodePkuService:IsSignedIn() then 
            UserInfo:CheckDoAutoSignin()
        end
    end

    
    local world = RemoteWorld.LoadFromHref(url, "self")
end