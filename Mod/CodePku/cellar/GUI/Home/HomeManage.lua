--[[
Author:zouren
Date: 2020-09-14 16:17:34
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeManage.lua");
local HomeManage = commonlib.gettable("Mod.CodePku.Common.HomeManage")
-----------------------------------
]]--
NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/GameRules/GameMode.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")

local RemoteWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.RemoteWorld")
local InternetLoadWorld = commonlib.gettable("MyCompany.Aries.Creator.Game.Login.InternetLoadWorld")
local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")
local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local GameMode = commonlib.gettable("MyCompany.Aries.Game.GameLogic.GameMode")

local HomeManage = commonlib.gettable("Mod.CodePku.Common.HomeManage")

-- init default value
function HomeManage:OnInit()
    LOG.std("", "info", "HomeManage", "OnInit");
    GameLogic:Connect("WorldLoaded", HomeManage, HomeManage.OnWorldLoaded, "UniqueConnection");
end

function HomeManage:OnWorldLoaded()
    --如果当前正在进入家园区就在进入世界后设置家园区判定变量为true
    if System.Codepku.isLoadingHome then
        System.Codepku.isHome = true
    else
        System.Codepku.isHome = false
    end
    --判定结束后将正在进入家园区判定变量设置为false
    System.Codepku.isLoadingHome = false
end

function HomeManage:EnterHome()
    LOG.std(nil, "SaveHome", "OpenLocalWorld", "Enter")
    System.Codepku.isLoadingHome = true -- 设置当前正在进入家园区判定
    local worldFolder = ParaWorld.GetWorldDirectory()
    WorldCommon.CopyWorldTo(worldFolder)
    WorldCommon.OpenWorld(worldFolder, true)
end

function HomeManage:GetHomeWorld()
    --body
    local function LoadWorld(world, refreshMode)
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
    end
end

function HomeManage:UploadHomeWorld()
    --body
    local params = {

    }
    local response = request:post("", params):next(function(response)
        GameLogic.AddBBS("CodeGlobals", L"世界上传成功", 3000, "#00FF00");
    end):catch(function(response)
        GameLogic.AddBBS("CodeGlobals", response.data.message or L"世界上传失败", 3000, "#00FF00");
    end);

end

function HomeManage:ChangeGameMode()
    if GameLogic.GameMode:IsEditor() then
        GameLogic.RunCommand("/mode game")
    else
        GameLogic.RunCommand("/mode edit")
    end
end

function HomeManage:SaveHome()
    if not System.Codepku.isHome then
        GameLogic.AddBBS(nil, L"这里不是你的家园", 3000, "255 0 0", 21)
        return
    end
    local source = System.world.name;
    local worldpath = source.."/";
    local zipfile = source..".zip";
    local worldname = string.gsub(source, ".*/(.-)$", "%1");
    echo("-----------zr-------------")
    echo("---filesTotal-- = "..tostring(filesTotal))
    echo("---source-- = "..tostring(source))
    echo("---worldpath-- = "..tostring(worldpath))
    echo("---zipfile-- = "..tostring(zipfile))
    echo("---worldname-- = "..tostring(worldname))
    echo("-----------zr-------------")

    local function MakeNewZipPackage_()
        if(ParaIO.DoesFileExist(zipfile)) then
            -- close and delete old file.
            ParaAsset.CloseArchive(zipfile);
            ParaIO.DeleteFile(zipfile);
            log("old zip file exist, we will delete it before making a new one\n");
        end

        local writer = ParaIO.CreateZip(zipfile,"");
        writer:AddDirectory(worldname, worldpath.."*.*", 6);
        writer:close();
    end
    NPL.load("(gl)script/apps/Aries/Creator/WorldCommon.lua");
    local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
    -- WorldCommon.SaveWorldAs()
    -- todo 后期加上世界是否被修改的判定，然后提示玩家是否保存并上传
    GameLogic.SaveAll(true)
    MakeNewZipPackage_()

    SaveHome.UI:CloseWindow()
    SaveHome.UI = nil
end