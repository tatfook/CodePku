local AxiosCore = NPL.load("(gl)Mod/CodePku/util/axios/core/Axios.lua");

local Axios = NPL.export();

function createInstance(defaultConfig)
    local context = AxiosCore:new():init(defaultConfig);
    return context;
end

function Axios.create(instanceConfig)
    local newInstance = createInstance(instanceConfig);
    return newInstance;
end

setmetatable(Axios,{__index = createInstance()});