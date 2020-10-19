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
NPL.load("(gl)script/ide/System/Core/ToolBase.lua")
local SafeData = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"), commonlib.gettable("Mod.CodePku.SafeData"))



