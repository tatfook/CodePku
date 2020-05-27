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

function UserConsole:ShowPage()

end

function UserConsole:CourseEntry()

    LOG.std(nil, "info", "codepku", "course entry world")
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

    CodePkuServiceSession:courseEntryWorld(function (response, err) 
        LOG.std(nil, "info", "codepku", "course entry world")
        echo(response)    
        if (err ~= 200) then
            GameLogic.AddBBS(nil, L"获取入口世界失败", 3000, "255 0 0")
            return false
        end
        local url = response["data"]["world"]
        local world = RemoteWorld.LoadFromHref(url, "self")        

        local function LoadWorld(world, refreshMode)
            if world then
                if refreshMode == 'never' then
                    if not LocalService:IsFileExistInZip(world:GetLocalFileName(), ":worldconfig.txt") then
                        refreshMode = 'force'
                    end
                end

                local url = world:GetLocalFileName()
                DownloadWorld.ShowPage(url)
                local mytimer = commonlib.Timer:new(
                    {
                        callbackFunc = function(timer)
                            InternetLoadWorld.LoadWorld(
                                world,
                                nil,
                                refreshMode or "auto",
                                function(bSucceed, localWorldPath)
                                    DownloadWorld.Close()
                                end
                            )
                        end
                    }
                );

                -- prevent recursive calls.
                mytimer:Change(1,nil);
            else
                _guihelper.MessageBox(L"无效的世界文件");
            end
        end

        LoadWorld(world, 'auto')
    end)
    
end