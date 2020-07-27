local InterceptorManager = commonlib.inherit(nil, NPL.export({}));
-- local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");

function InterceptorManager:ctor()
    self.handlers = {};
end

function InterceptorManager.use(self,fulfilled, rejected)
    table.insert(self.handlers, {
        fulfilled = fulfilled,
        rejected = rejected
    });
    return #self.handlers;
end

function InterceptorManager.eject(self,id)
    if self.handlers[id] then
        self.handlers[id] = nil;
    end
end

function InterceptorManager.forEach(self,fn)
    for _, h in ipairs(self.handlers) do
        if h ~= nil then
            fn(h);            
        end
    end
end