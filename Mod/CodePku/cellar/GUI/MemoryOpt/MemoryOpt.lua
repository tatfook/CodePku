--[[
Title: cache cleanup
Author(s): NieXX
Date: 2020/10/22
Desc: 清除白名单以外的图片以及资源缓存
use the lib:
functions:

------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/MemoryOpt/MemoryOpt.lua")
local MemoryOpt = commonlib.gettable("Mod.CodePku.cellar.GUI.MemoryOpt")
------------------------------------------------------------
]]

MemoryOpt = commonlib.gettable("Mod.CodePku.GUI.MemoryOpt")
local Device = NPL.load("(gl)Mod/CodePku/util/Device.lua");
local DeviceInstance = Device.newInstance();
local platform = System.os.GetPlatform();
local isAndroid = platform == "android";
local isIOS = platform == "ios";
NPL.load("(gl)Mod/CodePku/cellar/AssetManage/CodePkuAssetPreloader.lua")
local CodePkuAssetPreloader = commonlib.gettable("Mod.CodePku.AssetManage.CodePkuAssetPreloader")
function MemoryOpt:StaticInit()
    LOG.std("", "info", "MemoryOpt", "OnInit");
    GameLogic:Connect("WorldLoaded", MemoryOpt, MemoryOpt.Clear, "UniqueConnection");
end

function MemoryOpt.Clear()
    local assetManager = ParaEngine.GetAttributeObject():GetChild("AssetManager");
    local paraXManager = assetManager:GetChild("ParaXManager");
    for i=1, paraXManager:GetChildCount(0) do
        local attr = paraXManager:GetChildAt(i)
        local filename = attr:GetField("name", "");
        if(filename ~= "") then
            local ext = filename:match("%.(%w+)$");
            if(ext) then
                ext = string.lower(ext)
                if(ext == "bmax" or ext == "x" or ext == "fbx") then
                    ParaAsset.LoadParaX("", filename):UnloadAsset();
                    -- LOG.std(nil, "info", "Files", "unload unused asset file: %s", filename);
                end
            end
        end
    end

    local textureManager = assetManager:GetChild("TextureManager")
    for i=1, textureManager:GetChildCount(0) do
        local attr = textureManager:GetChildAt(i)
        local filename = attr:GetField("name", "");
        local IsInWhiteList = CodePkuAssetPreloader.getSingleTon():IsInWhiteList(filename)
        if(filename ~= "" and not IsInWhiteList) then
            local ext = filename:match("%.(%w+)$");
            -- also release http textures
            if(not ext and filename:match("^https?://")) then
                local localFilename = attr:GetField("LocalFileName", "")
                ext = localFilename:match("^temp/webcache/.*%.(%w+)$");
            end
            if(ext) then
                ext = string.lower(ext)
                if(ext == "jpg" or ext == "png" or ext == "dds") then
                    ParaAsset.LoadTexture("", filename, 1):UnloadAsset();
                    -- LOG.std(nil, "info", "Files", "unload unused asset file: %s", filename);
                end
            end
        end
    end
end