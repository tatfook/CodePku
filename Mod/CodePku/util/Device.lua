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


-------------------------------------------------------
]]


local Device =  commonlib.inherit(nil, NPL.export());


local platform = System.os.GetPlatform();
local isAndroid = platform == "android";
local isIOS = platform == "ios";
callbacks = {}

NPL.this(function()
    local spltPos = string.find(msg, "_");
    if spltPos then
        local params = string.sub(msg, spltPos + 1)
        local method = string.sub(msg, 1, spltPos - 1);
        if callbacks and callbacks[method] then
            callbacks[method](params);
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

    end

    return self;
end

-- 获取内存信息
-- support devices：
-- android
-- ios
function Device:getMemory()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getMemory", "()Ljava/lang/String;",{});
        if(type(ret.result) == "string") then
            ret.result = commonlib.Json.Decode(ret.result);
        end
        return ret.result;
    elseif isIOS then

    end
end

-- 获取 app 版本号
-- support devices：
-- android
function Device:getAppVersion()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getAppVersion", "()Ljava/lang/String;",{});
        return ret.result;
    elseif isIOS then

    end
end

-- 获取 Android 版本号
-- support devices：
-- android
function Device:getAndroidVersion()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getAndroidVersion", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取 Android SDK 版本
-- support devices：
-- android
function Device:getAndroidSDK()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getSDK", "()I",{});
        return ret.result;
    end
end

-- 获取 fingerprit 信息
-- support devices：
-- android
function Device:getFubgerprint()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getFubgerprint", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取设备名称
-- support devices：
-- android
function Device:getDevice()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getDevice", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取手机主板名
-- support devices：
-- android
function Device:getBoard()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getBoard", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取手机型号
-- support devices：
-- android
function Device:getModel()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getModel", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取手机品牌
-- support devices：
-- android
function Device:getBrand()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getBrand", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取产品名
-- support devices：
-- android
function Device:getProduct()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getProduct", "()Ljava/lang/String;",{});
        return ret.result;
    end
end

-- 获取厂商名
-- support devices：
-- android
function Device:getManufacturer()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/CodePKU/Device", "getManufacturer", "()Ljava/lang/String;",{});
        return ret.result;
    end
end





