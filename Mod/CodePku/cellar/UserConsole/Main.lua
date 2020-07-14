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
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local InternetLoadWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.InternetLoadWorld")
local RemoteWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.RemoteWorld")
local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")
local SaveWorldHandler = commonlib.gettable("MyCompany.Aries.Game.SaveWorldHandler")
local GameMainLogin = commonlib.gettable("MyCompany.Aries.Game.MainLogin")

local WorldShare = commonlib.gettable("Mod.CodePku")
local Encoding = commonlib.gettable("commonlib.Encoding")

local UserInfo = NPL.load("@Mod/CodePku/celler/UserConsole/UserInfo.lua")
local CodePkuServiceSession = NPL.load("(gl)Mod/CodePku/service/CodePkuService/Session.lua")
local CodePkuService = NPL.load("(gl)Mod/CodePku/service/CodePkuService.lua")

local UserConsole = NPL.export()

function UserConsole:ShowPage()
    local url = "Mod/CodePku/cellar/UserConsole/StartLearning.html"
    -- Mod.CodePku.Utils.ShowWindow(850, 470, url, "StartLearning", nil, nil, nil, false, 10)
    
    System.App.Commands.Call("File.MCMLWindowFrame", {
        url = url, 
        name = "StartLearning", 
        isShowTitleBar = false,
        DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        zorder = -1,
        bShow = bShow,
        directPosition = true,
            align = "_fi",
            x = 0,
            y = 0,
            width = 0,
            height = 0,
        cancelShowAnimation = true,
    });	
end

function UserConsole:ClosePage()
    local UserConsolePage = Mod.CodePku.Store:Get('page/StartLearning')

    if UserConsolePage then        
        UserConsolePage:CloseWindow()
    end
end

function UserConsole:CourseEntry()    
    CodePkuServiceSession:CourseEntryWorld(function (response, err)         
        if (err == 401) then
            GameLogic.AddBBS(nil, L"请先登录", 3000, "255 0 0", 21)
            -- todo 看下怎么回到登录页面
            return false
        end   
        if (err ~= 200) then
            GameLogic.AddBBS(nil, L"获取入口世界失败", 3000, "255 0 0", 21)
            return false
        end

        local GeneralGameServerMod = commonlib.gettable("Mod.GeneralGameServerMod");
        local GeneralGameClientClass = GeneralGameServerMod:GetClientClass("CodePku");
        commonlib.setfield("System.Codepku.Coursewares", response.data);
        GeneralGameClientClass:LoadWorld({
            worldId = response.data.keepwork_project_id,
            url = response.data.world
        });
        -- local url = response and response.data and response.data.world
        -- echo(url)
        -- local world = RemoteWorld.LoadFromHref(url, "self")

        -- local function LoadWorld(world, refreshMode)
        --     if world then
        --         if refreshMode == 'never' then
        --             if not LocalService:IsFileExistInZip(world:GetLocalFileName(), ":worldconfig.txt") then
        --                 refreshMode = 'force'
        --             end
        --         end

        --         local url = world:GetLocalFileName()               
        --         DownloadWorld.ShowPage(url)
        --         echo("loadworld")
        --         echo(world)
        --         local mytimer = commonlib.Timer:new(
        --             {
        --                 callbackFunc = function(timer)
        --                     InternetLoadWorld.LoadWorld(
        --                         world,
        --                         nil,
        --                         refreshMode or "auto",
        --                         function(bSucceed, localWorldPath)
        --                             echo({localWorldPath = localWorldPath})
        --                             DownloadWorld.Close()
        --                         end
        --                     )
        --                 end
        --             }
        --         );
        --         -- prevent recursive calls.
        --         mytimer:Change(1,nil);
        --     else
        --         _guihelper.MessageBox(L"无效的世界文件");
        --     end
        -- end
        -- LoadWorld(world, 'auto')
    end) 
end

function UserConsole:Logout()
    CodePkuServiceSession:Logout()
    local StartLearningPage = Mod.CodePku.Store:Get('page/StartLearning')
    if StartLearningPage then
        StartLearningPage:CloseWindow()
    end
    GameMainLogin:next_step({IsLoginModeSelected = false})
end

function UserConsole:GetProjectId(url)
    if (tonumber(url or '') or 99999) < 99999 then
        return url
    end

    local pid = string.match(url or '', "^p(%d+)$")

    if not pid then
        pid = string.match(url or '', "/pbl/project/(%d+)")
    end

    return pid or false
end

function UserConsole:HandleWorldId(pid)
    if not pid then
        return false
    end

    pid = tonumber(pid)

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

    CodePkuServiceSession:CourseWorldByKeepworkId(pid, function (response, error)        
        if (error == 401) then
            GameLogic.AddBBS(nil, L"请先登录", 3000, "255 0 0", 21)
            -- todo 看下怎么回到登录页面
            return false
        end   
        if (error ~= 200) then
            GameLogic.AddBBS(nil, L"获取入口世界失败", 3000, "255 0 0", 21)
            return false
        end
        local url = response and response.data and response.data.world
        
        if not url then
            GameLogic.AddBBS(nil, L"获取入口世界失败", 3000, "255 0 0", 21)
            return false
        end

        local world = RemoteWorld.LoadFromHref(url, "self")
        commonlib.setfield("System.Codepku.Coursewares", response.data);

        LoadWorld(world, 'auto')    
    end)
end
