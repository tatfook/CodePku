--[[
Author:zouren
Date: 2020-09-09 14:23:05
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/SaveHome.lua");
local SaveHome = commonlib.gettable("Mod.CodePku.GUI.SaveHome")
SaveHome:ShowPage()
-----------------------------------
]]--
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local SaveHome = commonlib.gettable("Mod.CodePku.GUI.SaveHome")

function SaveHome:OnInit()
    
end

function SaveHome:Save()
    GameLogic.SaveAll(true, true)
    SaveHome.UI:CloseWindow()
    SaveHome.UI = nil
end

function SaveHome:Share()
    local LocalService = NPL.load("(gl)Mod/WorldShare/service/LocalService.lua")
    local worldpath = ParaWorld.GetWorldDirectory()
    local files = commonlib.Files.Find(
        {},
        worldpath,
        5,
        5000,
        function(item)
            return true
        end
    )

    local filesTotal = 0
    for key, value in ipairs(files) do
        filesTotal = filesTotal + tonumber(value.filesize)
    end


    local source = System.world.name;
    -- local worldpath = source.."/";
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
    WorldCommon.SaveWorldAs()
    -- GameLogic.SaveAll(true, true)
    MakeNewZipPackage_()

    SaveHome.UI:CloseWindow()
    SaveHome.UI = nil
end

function SaveHome:ShowPage()
    if SaveHome.UI then
        SaveHome.UI:CloseWindow()
        SaveHome.UI = nil
    end
    params = {
        url = "Mod/CodePku/cellar/GUI/Home/SaveHome.html",
        alignment="_ct",
        left = -960,
        top = -540,
        width = 1920,
        height = 1080,
        zorder = 20,
    }

    SaveHome.UI = AdaptWindow:QuickWindow(params)
end
