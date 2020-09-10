--[[
Title: Page
Author(s): NieXX
Date: 2020/9/10
Desc:
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/CommonFunc/CommonFunc.lua")
local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")
------------------------------------------------------------
]]

CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc");
NPL.load("(gl)script/ide/System/os/os.lua");

-- local CommonFunc = NPL.export();

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
    end
end

CommonFunc.isIOSApproval = function ()
    -- local iosApprovalStatus = Mod.CodePku.BasicConfigTable.ios_approval_status == 'on'
    local mock_ios = ParaEngine.GetAppCommandLineByParam("mock_ios", "") == "true"
    local isIOSPlatform = System.os.GetPlatform() == 'ios'
    local iosApprovalStatus = true
    -- echo("---------isIOSApproval---------")
    -- echo(System.os.GetPlatform())
    -- echo(isIOSPlatform)
    -- echo(mock_ios)
    -- echo((isIOSPlatform or mock_ios) and iosApprovalStatus)
    return (isIOSPlatform or mock_ios) and iosApprovalStatus
end