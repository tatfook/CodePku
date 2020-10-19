--[[
Author:{zouren}
Date: 2020-10-18 10:56:44
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/TestSafeData.lua");
local TestSafeData = commonlib.gettable("Mod.CodePku.TestSafeData")
TestSafeData:Test()
-----------------------------------
]]--

local TestSafeData = commonlib.gettable("Mod.CodePku.TestSafeData")

NPL.load("(gl)Mod/CodePku/cellar/Common/SafeData/SafeNumber.lua")
local SafeNumber = commonlib.gettable("Mod.CodePku.SafeNumber")

function TestSafeData:Test()
    local testSafeNumber = SafeNumber:new():init(100)

    print(testSafeNumber)
    testSafeNumber.data = 150
    print(testSafeNumber)
    local num = testSafeNumber + 20
    print(num)
end
