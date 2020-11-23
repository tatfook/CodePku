--[[
Title: 设备数据
Author(s): John Mai
Date: 2020-10-21 11:41:54
Desc: 获取设备的数据信息
Example:(下面只描述返回 table 或者 json 的对象例子，其他返回int string 不作描述  )
------------------------------------------------------------
    local Device = NPL.load("(gl)Mod/CodePku/util/Device.lua");
    local DeviceInstance = Device.newInstance();

    获取内存信息 ->
        Android Example ->
            local memory = DeviceInstance.getMemory();

            memory ->
                {
                    total_memory=3924017152,  总内存，单位 B
                    total_memory_format="3.92吉字节", 格式化总内存
                    available_memory=782659584, 可用内存，单位 B
                    available_memory_format="783兆字节",  格式化可用内存
                }

        获取内存信息 ->
        iOS Example ->
            -- 回调函数
            local function getMemory(pData)
                local decodeData = commonlib.Json.Decode(pData);
                echo(decodeData);
            end
            --
            local memory = DeviceInstance.getMemory(getMemory);
            
            -- 回调函数返回数据
            decodeData ->
                {
                    ram_memory_free = "", 可用内存，单位字节
                    ram_memory_used = "", 已使用内存，单位字节
                    ram_memory_total = "", 总内存，单位字节
                    
                    ram_memory_free_format = "", 格式化可用内存
                    ram_memory_used_format = "", 格式化已使用内存
                    ram_memory_total_format = "", 格式化总内存
                }
-------------------------------------------------------
]]


local Device =  commonlib.inherit(nil, NPL.export());

local platform = System.os.GetPlatform();
local isAndroid = platform == "android";
local isIOS = platform == "ios";

--对应oc/java互调
local BLUETOOTH_SYSTEM_CALL =
{
    GET_MEMORY = 555;
    GET_DEVICE = 777;
}

-- Android
Device.callbacks = {}
-- iOS
local LocalService = {callBacks = {}};

NPL.this(function()
    if isAndroid then
        local spltPos = string.find(msg, "_");
        if spltPos then
            local params = string.sub(msg, spltPos + 1)
            local method = string.sub(msg, 1, spltPos - 1);
            if Device.callbacks and Device.callbacks[method] then
                Device.callbacks[method](params);
            end
        end
    elseif isIOS then
        local spltPos = string.find(msg, "_");
        if spltPos then
            local extData = string.sub(msg, spltPos + 1)
            local extId = tonumber(string.sub(msg, 1, spltPos - 1));
            if LocalService and LocalService.callBacks then
                if LocalService.callBacks[extId] then
                    LocalService.callBacks[extId](extData);
                end
            end
        end
    end
end);

function Device:ctor()

end

local newInstance;
function Device.newInstance()
    if (not newInstance) then
        newInstance = Device:new():init();
    end

    return newInstance;
end

function Device:init()
    LOG.std("PluginDevice", "info", "init");
    if isAndroid then
        if LuaJavaBridge == nil then
            NPL.call("LuaJavaBridge.cpp", {});
        end
    elseif isIOS then
        -- lua层绑定OC的DeviceMessage类
        echo("Device.regNplEngineeBridge.start");
        if LuaObjcBridge == nil then
            NPL.call("LuaObjcBridge.cpp", {});
        end
        local args = { luaPath = "(gl)Mod/CodePku/util/Device.lua" };
        local ok, ret = LuaObjcBridge.callStaticMethod("DeviceMessage", "registerLuaCall", args);
        echo("Device.regNplEngineeBridge.end");
    end

    return self;
end

-- 获取内存信息
-- support devices：
-- android
-- ios
function Device:getMemory(callBack)
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getMemory", "()Ljava/lang/String;",{});
        if(type(ret.result) == "string") then
            ret.result = commonlib.Json.Decode(ret.result);
        end
        return ret.result;
    elseif isIOS then
        -- 注册iOS:GET_MEMORY回调
        LocalService.callBacks[BLUETOOTH_SYSTEM_CALL.GET_MEMORY] = callBack;
        -- 调用OC: Class:DeviceMessage Method:getMemoryJsonString
        local args = {};
        local ok, ret = LuaObjcBridge.callStaticMethod("DeviceMessage", "getMemoryJsonString", args);
    end
end

-- 获取 app 版本号
-- support devices：
-- android
function Device:getAppVersion()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getAppVersion", "()Ljava/lang/String;",{});
        return ret.result;
    elseif isIOS then

    end
end

-- 获取 Android 版本号
-- support devices：
-- android
function Device:getAndroidVersion()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getAndroidVersion", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取 Android SDK 版本
-- support devices：
-- android
function Device:getAndroidSDK()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getSDK", "()I",{});
        return ret.result;
    end
end

-- 获取 fingerprit 信息
-- support devices：
-- android
function Device:getFubgerprint()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getFubgerprint", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取设备名称
-- support devices：
-- android
function Device:getDevice(callBack)
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getDevice", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取手机主板名
-- support devices：
-- android
function Device:getBoard()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getBoard", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取手机型号
-- support devices：
-- android
function Device:getModel()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getModel", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取手机品牌
-- support devices：
-- android
function Device:getBrand()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getBrand", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取产品名
-- support devices：
-- android
function Device:getProduct()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getProduct", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取厂商名
-- support devices：
-- android
function Device:getManufacturer()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/Device", "getManufacturer", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

