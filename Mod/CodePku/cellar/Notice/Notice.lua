--[[
Title: Page
Author(s): NieXX
Date: 2020/9/11
Desc:
use the lib:
virtual functions:
	mousePressEvent(event)
	mouseMoveEvent
	mouseReleaseEvent
	mouseWheelEvent
	keyPressEvent
	keyReleaseEvent: not implemented

	OnSelect()
	OnUnselect()
	OnLeftLongHoldBreakBlock()
	OnLeftMouseHold(fDelta)
	OnRightMouseHold(fDelta)

	handleHistoryKeyEvent();
	handlePlayerKeyEvent();

	GetClickData()
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Notice/Notice.lua")
local Notice = commonlib.gettable("Mod.CodePku.celler.Notice")
------------------------------------------------------------
]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
Notice = commonlib.gettable("Mod.CodePku.celler.Notice");

Notice.content = {}

Notice.isHuaweiApproval = function ()
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

function Notice:getNotice()
    return {

    }
end

function Notice:ShowPage(PageIndex, bShow, id, mainasset)
    -- if (id and id ~= "") then
    --     Notice.isSelf = false;
    --     Notice.tab_ds_name = Notice.tab_ds_other[PageIndex or 1].name;
    -- else
    --     Notice.isSelf = true;
    --     Notice.tab_ds_name = Notice.tab_ds_self[PageIndex or 1].name;
    -- end
    -- Notice.bForceHide = bShow == false;
    -- Notice.tab_ds_index = PageIndex or 1;
    -- Notice.GetUserInfo(id, true);
    -- Notice.GetItemInfo();
    -- Notice.mainasset = mainasset; -- 获取他人角色asset path
    echo("==========show==========")
    local params = {
		url = "Mod/CodePku/cellar/Notice/Notice.html",
		alignment="_lt", left = 0, top = 0, width = 1920, height = 1080, zorder = 30,
		click_through = false,
	}
	return AdaptWindow:QuickWindow(params)
end

function Notice:getNotice()
    -- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    -- request:get('/config/basic',{}):next(function(response)
        
    --     -- Notice.content = response.data.data;
    -- end):catch(function(e)
        
    -- end);

    local content ="为防止游戏内出现拉人的骗子，今天玩学就给大家普及下骗子的特征和套路：\n<a href=''>   1111111111111</a>1、内容内容内容内容内容内容内容内\n容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"
    Notice.content = commonlib.split(content, "\n")
    echo("---------------Notice.content--------------")
    echo(Notice.content)
    local new_content = {}
    for i,j in ipairs(Notice.content) do
        print(i)
        print(j)
        local temp = {}
        new_content.insert(i,j)
    end
    echo(new_content)
    return commonlib.split(content, "\n")
end