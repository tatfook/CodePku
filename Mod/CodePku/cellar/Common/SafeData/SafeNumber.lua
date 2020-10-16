--[[
Author:zouren
Date: 2020-10-15 17:37:57
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/SafeNumber.lua")
local SafeNumber = commonlib.gettable("Mod.CodePku.SafeNumber")
-----------------------------------
]]--
NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/SafeData.lua")
local SafeNumber = commonlib.inherit(commonlib.gettable("Mod.CodePku.SafeData"), commonlib.gettable("Mod.CodePku.SafeNumber"))

function SafeNumber:ctor(_value)
    if type(_value) ~= "number" then
        LOG.std(nil, "error", "SafeData", "Type Error");
        return
    end
    self.data = _value
    self:setSafeData()
end

--[[
    @desc 
    time:2020-10-15 17:44:24
    return 
]]
function SafeNumber:setSafeData()
    local refStr = tostring(self.data)
    local refList = {}
    for index = 1, string.len(refStr) do
        table.insert(refList, string.byte(refStr, index))
    end
    self.safeData = table.concat( refList )
end

--[[
    @desc 
    time:2020-10-16 09:15:27
    return 
]]
function SafeNumber:checkDataAndRevert()
	local refStr = tostring(self.data)
    local refList = {}
    for index = 1, string.len(refStr) do
        table.insert(refList, string.byte(refStr, index))
    end
    local checkStr = table.concat( refList )
    if self.safeData ~= checkStr then
        self:revertData()
    end
end

--[[
    @desc 
    time:2020-10-16 11:40:28
    return 
]]
function SafeNumber:revertData()
    local charList = {}
    for index = 1, string.len( self.safeData ), 2 do
        table.insert(charList, string.char(string.sub(self.safeData, index, index+1)))
    end
    self.data = table.concat(charList)
end
