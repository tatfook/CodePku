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

local WorldCommon = commonlib.gettable("MyCompany.Aries.Creator.WorldCommon")
local GameMode = commonlib.gettable("MyCompany.Aries.Game.GameLogic.GameMode")

local HomeManage = commonlib.gettable("Mod.CodePku.Common.HomeManage")

-- init default value
function HomeManage:OnInit()
    GameLogic:Connect("WorldLoaded", HomeManage, HomeManage.OnWorldLoaded, "UniqueConnection");
end

function HomeManage:EnterHome()
    local homeId = tonumber(tostring(System.User.id).."000001")
    if System.Codepku.Coursewares.keepwork_project_id == 14293 then
        System.Codepku.isHome = true
    else
        System.Codepku.isHome = false
    end

    LOG.std(nil, "SaveHome", "OpenLocalWorld", "Enter")
    if System.Codepku.isHome then
        local worldFolder = ParaWorld.GetWorldDirectory()
        WorldCommon.CopyWorldTo(worldFolder)
        WorldCommon.OpenWorld(worldFolder, true)
    end
end

function HomeManage:GetHomeWorld()
    --body
end

function HomeManage:UploadHomeWorld()
    --body
end

function HomeManage:ChangeGameMode()
    if GameLogic.GameMode:IsEditor() then
        GameLogic.RunCommand("/mode game")
    else
        GameLogic.RunCommand("/mode edit")
    end
end

function HomeManage:SaveHome()
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