--[[
Title: AppControl
Author(s): feng
Date: 2020-11-05 
Desc: 控制app相关操作
Example:
------------------------------------------------------------
    local App = NPL.load("(gl)Mod/CodePku/util/App.lua");
    local AppInstance = App.newInstance();
-------------------------------------------------------
]]


local App =  commonlib.inherit(nil, NPL.export());

local platform = System.os.GetPlatform();
local isAndroid = platform == "android";
local isIOS = platform == "ios";


-- Android
App.callbacks = {}
-- iOS


NPL.this(function()
    if isAndroid then
        local spltPos = string.find(msg, "_");
        if spltPos then
            local params = string.sub(msg, spltPos + 1)
            local method = string.sub(msg, 1, spltPos - 1);
            if App.callbacks and App.callbacks[method] then
                App.callbacks[method](params);
            end
        end
    elseif isIOS then

    end
end);

function App:ctor()

end

local newInstance;
function App.newInstance()
    if (not newInstance) then
        newInstance = App:new():init();
    end

    return newInstance;
end

function App:init()
    LOG.std("PluginApp", "info", "init");
    if isAndroid then
        if LuaJavaBridge == nil then
            NPL.call("LuaJavaBridge.cpp", {});
        end
    elseif isIOS then

    end

    return self;
end

-- 注销App
-- support devices：
-- android
-- ios
function App:closeApp()
    if isAndroid then
        local ret = LuaJavaBridge.callJavaStaticMethod("plugin/Codepku/App", "closeApp", "()V",{});
        return ret.result;
    elseif isIOS then

    end
end

