--[[
Title: Page_ui
Author(s): NieXX
Date: 2020/10/27
Desc: 玩家操作数据统计
use the lib:
functions:

------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/ClickStatistics/ClickStatistics.lua")
local ClickStatistics = commonlib.gettable("Mod.CodePku.GUI.ClickStatistics")
------------------------------------------------------------
]]
ClickStatistics = commonlib.gettable("Mod.CodePku.GUI.ClickStatistics")

ClickStatistics.ClickInfo={
    [1] = {type="login_code", id= 1}, --点击获取验证码
    [2] = {type="login_tourist", id= 2}, --点击游客模式
    [3] = {type="login_signin", id= 3}, --点击登录
    [4] = {type="login_agree", id= 4}, --点击服务协议同意选项
    [5] = {type="login_password", id= 5}, --点击密码登录
    [6] = {type="login_switch", id= 6}, --点击切换账号
    [7] = {type="login_Notice", id= 7}, --点击公告
    [8] = {type="login_community", id= 8}, --点击社区
    [9] = {type="login_qq", id= 9}, --点击QQ群
    [10] = {type="main_map", id= 10}, --点击主界面地图
    [11] = {type="main_Reset", id= 11}, --点击主界面防卡死
    [12] = {type="main_community", id= 12}, --点击主界面社区
    [13] = {type="main_feedback", id= 13}, --点击主界面反馈
    [14] = {type="main_qq", id= 14}, --点击主界面官方Q群
    [15] = {type="main_parent", id= 15}, --点击主界面我的家长
    [16] = {type="main_share", id= 16}, --点击主界面点击分享
    [17] = {type="main_role", id= 17}, --点击主界面角色详情
    [18] = {type="main_Friends", id= 18}, --点击主界面好友
    [19] = {type="main_Ranking ", id= 19}, --点击主界面排行榜
    [20] = {type="main_autograph", id= 20}, --点击主界面签到
    [21] = {type="main_task", id= 21}, --点击主界面任务
    [22] = {type="main_formal", id= 22}, --点击主界面升级账号
    [23] = {type="formal_register", id= 23}, --点击升级账号注册
    [24] = {type="formal_cancel", id= 24}, --点击升级账号取消
    [25] = {type="map_teaching", id= 25}, --点击地图教学区
    [26] = {type="map_special", id= 26},--点击地图专题区
    [27] = {type="map_sports", id= 27}, --点击地图竞技区
    [28] = {type="map_home", id= 28}, --地图点击家园区
    [29] = {type="map_hall", id= 29}, --地图点击大厅
    [30] = {type="curriculum_share_no", id= 30},  --点击课程结算界面确定
    [31] = {type="curriculum_share_yes", id= 31}, --点击课程结算界面分享
    [32] = {type="Running_share_no", id= 32}, --点击单词爱跑酷结算界面确定
    [33] = {type="Running_share_yes", id= 33}, --点击单词爱跑酷结算界面分享
    [34] = {type="Huaxia_share_no", id= 34}, --点击华夏游学记结算界面确定
    [35] = {type="Huaxia_share_yes", id= 35}, --点击华夏游学记结算界面分享
    [36] = {type="tourist_curriculum_no", id= 36}, --点击游客课程权限框-下次
    [37] = {type="tourist_curriculum_yes", id= 37}, --点击游客课程权限框-注册
    [38] = {type="tourist_home_no", id= 38}, --点击游客家园权限框-下次
    [39] = {type="tourist_home_yes", id= 39}, --点击游客家园权限框-注册
}

function ClickStatistics:StaticInit()
    LOG.std("", "info", "ClickStatistics", "StaticInit");
    -- GameLogic.GetFilters():apply_filters("ClickStatistics", data);
    GameLogic.GetFilters():remove_filter("ClickStatistics", ClickStatistics.OnClick_Callback);
    GameLogic.GetFilters():add_filter(
        "ClickStatistics",
        function (data)
            NPL.load("(gl)Mod/CodePku/cellar/GUI/ClickStatistics/ClickStatistics.lua")
            local ClickStatistics = commonlib.gettable("Mod.CodePku.GUI.ClickStatistics")
            if data then
                echo("----------------data----------------")
                echo(data)
                
            end
        end
    );
end

function ClickStatistics:OnClick_Callback()

end

--[[
    更新后台数据
    @param data eg:{ids="1, 20"}
]]
function ClickStatistics:UpdateClickStatistics(data)
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:post('/tasks/up-tasks', data, nil);
end
