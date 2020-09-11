--[[
Title: Page
Author(s): NieXX
Date: 2020/9/10
Desc:
use the lib:
virtual functions:
    isHuaweiApproval()
    isIOSApproval()
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/CommonFunc/CommonFunc.lua")
local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")
------------------------------------------------------------
]]

CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc");
NPL.load("(gl)script/ide/System/os/os.lua");

-- local CommonFunc = NPL.export();


-- Judge whether to pass the channel audit, such as huawei, flyme, sogou
-- e.g. CommonFunc.isHuaweiApproval();
-- @return:if successful return true, if falied return false
CommonFunc.isHuaweiApproval = function ()
    local huaweiApprovalStatus = Mod.CodePku.BasicConfigTable.huawei_approval_status == 'on'
    local app_market = ParaEngine.GetAppCommandLineByParam("app_market", "")
    local flymeApprovalStatus = Mod.CodePku.BasicConfigTable.flyme_approval_status == 'on'
    local sogouApprovalStatus = Mod.CodePku.BasicConfigTable.sogou_approval_status == 'on'
    if app_market == 'huawei' then
        return huaweiApprovalStatus
    elseif app_market == 'flyme' then
        return flymeApprovalStatus
    elseif app_market == 'sogou' then
        return sogouApprovalStatus
    else 
        return false
    end
end

-- Judge whether IOS channel is approved or not
-- e.g. CommonFunc.isIOSApproval();
-- @return:if successful return true, if falied return false
CommonFunc.isIOSApproval = function ()
    local iosApprovalStatus = Mod.CodePku.BasicConfigTable.ios_approval_status == 'on'
    local mock_ios = ParaEngine.GetAppCommandLineByParam("mock_ios", "") == "true"
    local isIOSPlatform = System.os.GetPlatform() == 'ios'
    return (isIOSPlatform or mock_ios) and iosApprovalStatus
end