--[[
use the lib:
------------------------------------------------------------
local AppStats = NPL.load("(gl)Mod/CodePku/script/apps/Statistics/AppStats.lua")
------------------------------------------------------------
]]

local AppStats = NPL.export();

local appMarket = ParaEngine.GetAppCommandLineByParam("app_market", "default")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")

function AppStats:init()
    AppStats:FirstLaunch()
    AppStats:LaunchCount()
end

-- 获取设备唯一标识
function AppStats:GetDeviceUUID()
    local deviceData = GameLogic.GetPlayerController():LoadLocalData("DeviceData", {}, true)
    local currentParacraftDir = ParaIO.GetWritablePath()
    if not deviceData.softwareUUID or
       not deviceData.paracraftDir or
       deviceData.paracraftDir ~= currentParacraftDir then
        deviceData.paracraftDir = ParaIO.GetWritablePath()
        deviceData.softwareUUID = System.Encoding.guid.uuid()
        GameLogic.GetPlayerController():SaveLocalData("DeviceData", deviceData, true)
    end
    -- local machineID = ParaEngine.GetAttributeObject():GetField("MachineID","")
    return deviceData.softwareUUID;
end

-- 新设备首次启动 - 激活量统计
function AppStats:FirstLaunch()
    local deviceUUID = GameLogic.GetPlayerController():LoadLocalData("DeviceData", {}, true)
    if (not deviceUUID.softwareUUID) then
        request:post('/statistics/activation', {
            app_market = appMarket,
            device_id = AppStats:GetDeviceUUID()
        }):next(function(response)
            -- LOG.std(nil, "info", "AppStat", "FirstLaunch: ", GameLogic.GetPlayerController():LoadLocalData("DeviceData", {}, true))
        end):catch(function(err)
            LOG.error(err)
        end)
    end
end

-- 记录启动次数
function AppStats:LaunchCount()
    request:post('/statistics/start-up', {
        app_market = appMarket
    }):next(function(response)
        -- LOG.std(nil, "info", "AppStat", "LaunchCount")
    end):catch(function(err)
        LOG.error(err)
    end)
end