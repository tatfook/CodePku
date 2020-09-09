--[[Title: Axios Core 
Author(s): John Mai
Date: 2020-06-18 11:53:57
Desc: Axios Core
Example:
------------------------------------------------------------
    local AxiosCore = NPL.load("(gl)Mod/CodePku/util/Axios/core/axios.lua");
-------------------------------------------------------
]]
local Axios = commonlib.inherit(nil, NPL.export({}));

-- NPL.load("(gl)Mod/CodePku/util/Log.lua");
-- local Log = commonlib.gettable("Mod.CodePku.Utils.Log");
local Table = NPL.load("(gl)Mod/CodePku/util/Table.lua");
local Promise = NPL.load("(gl)Mod/CodePku/util/axios/util/Promise.lua");
local InterceptorManager = NPL.load("(gl)Mod/CodePku/util/axios/core/InterceptorManager.lua");

local os = commonlib.gettable("System.os");

function Axios:ctor()
    self.defaults = {};
    self.interceptors = {
        request = InterceptorManager:new(),
        response = InterceptorManager:new()
    };
end

function Axios:init(instanceConfig)
    self.defaults = instanceConfig or {};
    self.__index = self;
    return self;
end

function Axios:mergeConfig(config)
    local newConfig = commonlib.clone(self.defaults);

    for k, v in pairs(config) do
        newConfig[k] = v
    end

    return newConfig;
end

function Axios.request(self, ...)
    local arguments = { ... };

    if type(arguments[1]) == "string" then
        config = arguments[2] or {};
        config.url = arguments[1];
    else
        config = ... or {};
    end

    config = self:mergeConfig(config);


    if config.baseUrl then
        config.url = string.format("%s%s", config.baseUrl, config.url);
    end

    if config.method then
        config.method = string.upper(config.method);
    elseif self.defaults.method then
        config.method = string.upper(self.defaults.method);
    else
        config.method = "GET";
    end

    if config.query then
        config.url = NPL.EncodeURLQuery(config.url, config.query);
        config.query = nil;
    elseif config.params then
        config.url = NPL.EncodeURLQuery(config.url, config.params);
        config.params = nil;
    end

    if config.data then
        config.form = config.data;
        config.data = nil;
    end

    if config.json == nil then 
        config.json = true;
    end

    config.headers = {};

    self.interceptors.request:forEach(function(interceptor)
        config = interceptor.fulfilled(config);
    end);

    -- Log.info('### request config ###',config);
   echo('### request config ###',config);
   echo(config);

    local request = nil;


    if config.sync then
        local status, headers, data = System.os.GetUrl(config);

        request = {
            status = status,
            headers = headers,
            data = data,
            config = config
        };

        -- Log.info('### sync request response ###',request);\
        echo('### sync request response ###',response)
        echo(response)
        echo(request.data)
    else
        request = Promise.new(function(resolve, reject)
            System.os.GetUrl(config, function(status, headers, data)
                local response = {
                    status = status,
                    headers = headers,
                    data = data,
                    config = config
                };

                -- Log.info('### async request response ###',response);

                echo('### async request response ###',response)
                echo(response)

                if status >= 200 and status < 300 then
                    resolve(response);
                else
                    reject(response);
                end
            end);
        end);
    end

    self.interceptors.response:forEach(function(interceptor)
        if config.sync then
            request = interceptor.fulfilled(request);
        else
            request = Promise.new(function(resolve, reject)
                request:next(function(response)
                    if interceptor.fulfilled then
                        resolve(interceptor.fulfilled(response));
                    else
                        resolve(response);
                    end
                end):catch(function(error)
                    if interceptor.rejected then
                        reject(interceptor.rejected(error));
                    else
                        reject(error);
                    end
                end);
            end);
        end
    end);

    return request;
end

function Axios.get(self, url, query, config)
    config = config or {};
    config.url = url;
    config.query = query;
    return self:request(config);
end

function Axios.delete(self, url, query, config)
    config = config or {};
    config.url = url;
    config.query = query;
    config.method = 'DELETE';
    return self:request(config);
end

function Axios.head(self, url, query, config)
    config = config or {};
    config.url = url;
    config.query = query;
    config.method = 'HEAD';
    return self:request(config);
end

function Axios.options(self, url, query, config)
    config = config or {};
    config.url = url;
    config.query = query;
    config.method = 'OPTIONS';
    return self:request(config);
end

function Axios.post(self, url, data, config)
    config = config or {};
    config.url = url;
    config.data = data;
    config.method = 'POST';
    config.json = true;
    return self:request(config);
end

function Axios.put(self, url, data, config)
    config = config or {};
    config.url = url;
    config.data = data;
    config.method = 'PUT';
    return self:request(config);
end

function Axios.patch(self, url, data, config)
    config = config or {};
    config.url = url;
    config.data = data;
    config.method = 'PATCH';
    return self:request(config);
end

function Axios.resolve(data)
    local promise = Promise:new();
    promise:resolve(result);
    return promise;
end

function Axios.reject(data)
    local promise = Promise:new();
    promise:reject(result);
    return promise;
end

function contains(table, value)
    for i = 1, #table do
        if table[i] == value then
            return true;
        end
    end
    return false;
end