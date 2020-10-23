--[[
Author:zouren
Date: 2020-10-22 19:17:57
Des:
use the lib:
------------------------------------
local BranchData = NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/BranchData.lua")
-----------------------------------
]]--
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local BranchData = commonlib.inherit(nil, NPL.export())

BranchData.branchStateTable = {

}


-- init default value
function BranchData:ctor()
    BranchData:GetBranchState()
end

--[[
    @desc 
    time:2020-10-23 14:25:34
    return 
]]
function BranchData:GetBranchState()
    -- local data = {
    --     worldId = "14293"
    -- }
	-- request:get('/config/basic', data, nil):next(function (responese)
        
    -- end)
    BranchData.branchStateTable = {

    }
end


