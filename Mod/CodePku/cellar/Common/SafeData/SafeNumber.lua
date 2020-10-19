--[[
Author:zouren
Date: 2020-10-15 17:37:57
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/SafeNumber.lua")
local SafeNumber = commonlib.gettable("Mod.CodePku.SafeNumber")

local testData = SafeNumber:new():init(100)
-----------------------------------
]]--
NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/SafeData.lua")
local SafeNumber = commonlib.inherit(commonlib.gettable("System.Core.SafeData"), commonlib.gettable("Mod.CodePku.SafeNumber"))

function SafeNumber:ctor()
end

--[[
    @desc 
    time:2020-10-18 19:09:27
    @_value:
    return 
]]
function SafeNumber:init(_value)
    if type(_value) ~= "number" then
        LOG.std(nil, "error", "SafeData", "Type Error");
        return
    end
    self:setValue(_value)
    return self
end

--[[
    @desc 
    time:2020-10-19 10:31:33
    @_value:
    return 
]]
function SafeNumber:setValue(_value)
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

-- 设置元表和元方法  重载运算符   由于lua原生问题，不同数据类型比较永远不相等 所以==重载会有问题
local _mt  = {__index = SafeNumber}
SafeNumber.__metatable = _mt
--[[
    @desc 
    time:2020-10-16 12:57:03
    @_lValue: 
    @_rValue:
    return 
]]
function _mt.__add(_lValue ,_rValue)
    if type(_lValue) == "table" and _lValue:isa(SafeNumber) then
        _lValue:checkDataAndRevert()
        _lValue = _lValue.data
    end
    if type(_rValue) == "table" and _rValue:isa(SafeNumber) then
        _rValue:checkDataAndRevert()
        _rValue = _rValue.data
    end
    return SafeNumber:new():init(_lValue + _rValue)
end

--[[
    @desc 
    time:2020-10-19 10:30:42
    @_lValue: 
    @_rValue:
    return 
]]
function _mt:__sub(_lValue ,_rValue)
    if type(_lValue) == "table" and _lValue:isa(SafeNumber) then
        _lValue:checkDataAndRevert()
        _lValue = _lValue.data
    end
    if type(_rValue) == "table" and _rValue:isa(SafeNumber) then
        _rValue:checkDataAndRevert()
        _rValue = _rValue.data
    end
    return SafeNumber:new():init(_lValue - _rValue)
end

--[[
    @desc 
    time:2020-10-19 10:30:42
    @_lValue: 
    @_rValue:
    return 
]]
function _mt:__div(_lValue ,_rValue)
    if type(_lValue) == "table" and _lValue:isa(SafeNumber) then
        _lValue:checkDataAndRevert()
        _lValue = _lValue.data
    end
    if type(_rValue) == "table" and _rValue:isa(SafeNumber) then
        _rValue:checkDataAndRevert()
        _rValue = _rValue.data
    end
    return SafeNumber:new():init(_lValue / _rValue)
end

--[[
    @desc 
    time:2020-10-18 15:13:26
    return 
]]
function _mt.__tostring(_value)
    _value:checkDataAndRevert()
    return tostring(_value.data)
end