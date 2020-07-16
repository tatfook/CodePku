--[[
Title: 云片行为分享 sdk
Author(s): John Mai
Date: 2020-07-16 17:39:02
Desc: 与Android层云片行为分享sdk进行通讯
Example:
------------------------------------------------------------
    local QPCaptcha = NPL.load("(gl)Mod/CodePku/util/QPCaptcha.lua");
    QPCaptcha.verify({options sdk},{
        onLoaded = function() end,
        onSuccess = function(message) end,
        onFail = function(message) end,
        onError = function(message) end,
        onCancel = function() end,
    });
-------------------------------------------------------
]]

local QPCaptcha = commonlib.inherit(nil, NPL.export());

QPCaptcha.callbacks = {}
function QPCaptcha:ctor()
end

NPL.this(function()
    local spltPos = string.find(msg, "_");
    if spltPos then
        local params = string.sub(msg, spltPos + 1)
        local method = string.sub(msg, 1, spltPos - 1);
        if QPCaptcha.callbacks and QPCaptcha.callbacks[method] then
            QPCaptcha.callbacks[method](params);
        end
    end
end);

function QPCaptcha.verify(options, callback)
    QPCaptcha.callbacks = callback;

    if LuaJavaBridge == nil then
        NPL.call("LuaJavaBridge.cpp", {});
    end

    if LuaJavaBridge then
        LuaJavaBridge.callJavaStaticMethod("plugin/YunPian/QPCaptcha", "verify", "()V", options);
    end
end