--[[
Title: Timing cache cleanup
Author(s): NieXX
Date: 2020/10/22
Desc: 定时清除图片以及资源缓存（白名单内的资源除外）
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
    GameLogic:Connect("WorldLoaded", MemoryOpt, MemoryOpt.OnMemoryClear, "UniqueConnection");
    GameLogic:Connect("WorldLoaded", MemoryOpt, MemoryOpt.Clear, "UniqueConnection");
end

-- function MemoryOpt.OnMemoryClear_Callback()
function MemoryOpt.OnMemoryClear()
    local timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            echo("test clear")
            -- 剩余内存低于30%时清理内存
            local rate = 1
            if isAndroid then
                local memory = DeviceInstance:getMemory();
                rate = memory.available_memory/memory.total_memory;
                echo(memory)
                if rate < 0.3 then
                    -- MemoryOpt.Clear()
                end
            elseif isIOS then
                -- todo 
                local function getMemory(pData)
                    local decodeData = commonlib.Json.Decode(pData);
                    rate = decodeData.ram_memory_free/decodeData.ram_memory_total;
                    echo(rate); 
                end
                local memory = DeviceInstance:getMemory(getMemory);
                echo(memory)
                if rate < 0.3 then
                    -- MemoryOpt.Clear()
                end
            end
            echo("rate="..rate)
        end
    })
    timer:Change(4000, 4000)
end

function MemoryOpt.Clear()
    local before_count = collectgarbage("count");
	collectgarbage("collect");
	local after_count = collectgarbage("count");
	echo("before_count="..before_count)
    echo("after_count="..after_count)
    local memory = DeviceInstance:getMemory();
    echo("rate1="..memory.available_memory/memory.total_memory)
    local assetManager = ParaEngine.GetAttributeObject():GetChild("AssetManager");
    local paraXManager = assetManager:GetChild("ParaXManager");
    for i=1, paraXManager:GetChildCount(0) do
        local attr = paraXManager:GetChildAt(i)
        -- todo 添加白名单
        local filename = attr:GetField("name", "");
        local IsInWhiteList = CodePkuAssetPreloader.getSingleTon():IsInWhiteList(filename)
        if(filename ~= "" and not IsInWhiteList) then
            local ext = filename:match("%.(%w+)$");
            if(ext) then
                ext = string.lower(ext)
                if(ext == "bmax" or ext == "x" or ext == "fbx") then
                    ParaAsset.LoadParaX("", filename):UnloadAsset();
                    LOG.std(nil, "info", "Files", "unload unused asset file: %s", filename);
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
                    LOG.std(nil, "info", "Files", "unload unused asset file: %s", filename);
                end
            end
        end
    end
    local memory2 = DeviceInstance:getMemory();
    echo("rate2="..memory2.available_memory/memory2.total_memory)
end