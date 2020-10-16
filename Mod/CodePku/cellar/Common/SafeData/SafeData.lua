--[[
Author:zouren
Date: 2020-10-15 17:29:37
Des: virtual base class of safe datas ,don't use it, just for inherit
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/SafeData.lua")
local SafeData = commonlib.gettable("Mod.CodePku.SafeData")
-----------------------------------
]]--
local SafeData = commonlib.inherit(nil, commonlib.gettable("Mod.CodePku.SafeData"))

function SafeData:ctor()
    self.key = "codepku"
end

function SafeData:setSafeData()
end

function SafeData:checkDataAndRevert()
end

function SafeData:revertData()
end

--[[
    @desc 
    time:2020-10-16 12:57:03
    @_value1: 
    @_value2:
    return 
]]
function SafeData.__add(Lhs ,Rls)
    
end

