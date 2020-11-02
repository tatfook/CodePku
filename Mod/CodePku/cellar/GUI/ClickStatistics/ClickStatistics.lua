--[[
Title:
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
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/HomeManage.lua")
HomeManage = commonlib.gettable("Mod.CodePku.Common.HomeManage")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

--[[
    track_id 行为ID 
    track_scene 行为场景，0-登录页 1-主界面 2-地图 3-精品课程 4-改名 5-课程结算 6-跑酷 7-游学记 8-底部功能键栏 9-顶部功能键栏 10-家园区
    track_type 行为类型，0点击 1分享
    keepwork_id 当前世界ID，没有ID则为0
]]
ClickStatistics.ClickInfo={
    [1] = {track_id= 0, track_scene =0, track_type=0, }, --点击获取验证码
    [2] = {track_id= 1, track_scene =0, track_type=0, }, --点击游客模式
    [3] = {track_id= 2, track_scene =0, track_type=0, }, --点击登录
    [4] = {track_id= 3, track_scene =0, track_type=0, }, --点击服务协议同意选项
    [5] = {track_id= 4, track_scene =0, track_type=0, }, --点击密码登录（短信登录页）
    [6] = {track_id= 5, track_scene =0, track_type=0, }, --点击密码登录（密码登录页）
    [7] = {track_id= 6, track_scene =0, track_type=0, }, --点击切换账号
    [8] = {track_id= 7, track_scene =0, track_type=0, }, --点击公告
    [9] = {track_id= 8, track_scene =0, track_type=0, }, --点击社区
    [10] = {track_id= 9, track_scene =0, track_type=0, }, --点击QQ群

    -- 顶部功能键栏
    [11] = {track_id= 10, track_scene=9, track_type=0, }, --点击主界面地图
    [12] = {track_id= 11, track_scene=9, track_type=0, }, --点击主界面防卡死
    [13] = {track_id= 12, track_scene=9, track_type=0, }, --点击主界面社区
    [14] = {track_id= 13, track_scene=9, track_type=0, }, --点击主界面反馈
    [15] = {track_id= 14, track_scene=9, track_type=0, }, --点击主界面官方Q群
    [16] = {track_id= 15, track_scene=9, track_type=0, }, --点击主界面我的家长
    [17] = {track_id= 16, track_scene=9, track_type=0, }, --点击弹出主界面点击分享（弃用,改用[74]）

    -- 底部功能键栏
    [18] = {track_id= 17, track_scene=8, track_type=0, }, --点击主界面角色详情
    [19] = {track_id= 18, track_scene=8, track_type=0, }, --点击主界面好友
    [20] = {track_id= 19, track_scene=8, track_type=0, }, --点击主界面排行榜
    [21] = {track_id= 20, track_scene=8, track_type=0, }, --点击主界面签到
    [22] = {track_id= 21, track_scene=8, track_type=0, }, --点击主界面任务

    [23] = {track_id= 22, track_scene=8, track_type=0, }, --点击主弹出界面升级账号 (弃用，改用[29])

    [24] = {track_id= 23, track_scene=2, track_type=0, }, --点击地图教学区
    [25] = {track_id= 24, track_scene=2, track_type=0, },--点击地图专题区
    [26] = {track_id= 25, track_scene=2, track_type=0, }, --点击地图竞技区
    [27] = {track_id= 26, track_scene=2, track_type=0, }, --地图点击家园区
    [28] = {track_id= 27, track_scene=2, track_type=0, }, --地图点击大厅


    -- 升级：
    -- 主界面
    [29] = {track_id= 28, track_scene=1, track_type=0, }, --弹出升级账号
    [30] = {track_id= 29, track_scene=1, track_type=0, }, --这次升级
    [31] = {track_id= 30, track_scene=1, track_type=0, }, --下次升级
    --精品课程
    [32] = {track_id= 28, track_scene=3, track_type=0, }, --弹出升级账号
    [33] = {track_id= 29, track_scene=3, track_type=0, }, --这次升级
    [34] = {track_id= 30, track_scene=3, track_type=0, }, --下次升级
    -- 家园
    [35] = {track_id= 28, track_scene=10, track_type=0, }, --弹出升级账号
    [36] = {track_id= 29, track_scene=10, track_type=0, }, --这次升级
    [37] = {track_id= 30, track_scene=10, track_type=0, }, --下次升级
    -- 改名
    [38] = {track_id= 28, track_scene=4, track_type=0, }, --弹出升级账号
    [39] = {track_id= 29, track_scene=4, track_type=0, }, --这次升级
    [40] = {track_id= 30, track_scene=4, track_type=0, }, --下次升级


    -- 分享：
    -- 课程结算
    [41] = {track_id= 31, track_scene=5, track_type=0, }, --弹出海报弹框
    [42] = {track_id= 31, track_scene=5, track_type=1, }, --分享成功
    [43] = {track_id= 32, track_scene=5, track_type=0, }, --确认分享
    [44] = {track_id= 33, track_scene=5, track_type=0, }, --QQ
    [45] = {track_id= 33, track_scene=5, track_type=1, }, --QQ分享成功
    [46] = {track_id= 34, track_scene=5, track_type=0, }, --QQ空间
    [47] = {track_id= 34, track_scene=5, track_type=1, }, --QQ空间分享成功
    [48] = {track_id= 35, track_scene=5, track_type=0, }, --微信
    [49] = {track_id= 35, track_scene=5, track_type=1, }, --微信分享成功
    [50] = {track_id= 36, track_scene=5, track_type=0, }, --朋友圈
    [51] = {track_id= 36, track_scene=5, track_type=1, }, --朋友圈分享成功
    -- 跑酷
    [52] = {track_id= 31, track_scene=6, track_type=0, }, --弹出海报弹框
    [53] = {track_id= 31, track_scene=6, track_type=1, }, --分享成功
    [54] = {track_id= 32, track_scene=6, track_type=0, }, --确认分享
    [55] = {track_id= 33, track_scene=6, track_type=0, }, --QQ
    [56] = {track_id= 33, track_scene=6, track_type=1, }, --QQ分享成功
    [57] = {track_id= 34, track_scene=6, track_type=0, }, --QQ空间
    [58] = {track_id= 34, track_scene=6, track_type=1, }, --QQ空间分享成功
    [59] = {track_id= 35, track_scene=6, track_type=0, }, --微信
    [60] = {track_id= 35, track_scene=6, track_type=1, }, --微信分享成功
    [61] = {track_id= 36, track_scene=6, track_type=0, }, --朋友圈
    [62] = {track_id= 36, track_scene=6, track_type=1, }, --朋友圈分享成功
    -- 游学记
    [63] = {track_id= 31, track_scene=7, track_type=0, }, --弹出海报弹框
    [64] = {track_id= 31, track_scene=7, track_type=1, }, --分享成功
    [65] = {track_id= 32, track_scene=7, track_type=0, }, --确认分享
    [66] = {track_id= 33, track_scene=7, track_type=0, }, --QQ
    [67] = {track_id= 33, track_scene=7, track_type=1, }, --QQ分享成功
    [68] = {track_id= 34, track_scene=7, track_type=0, }, --QQ空间
    [69] = {track_id= 34, track_scene=7, track_type=1, }, --QQ空间分享成功
    [70] = {track_id= 35, track_scene=7, track_type=0, }, --微信
    [71] = {track_id= 35, track_scene=7, track_type=1, }, --微信分享成功
    [72] = {track_id= 36, track_scene=7, track_type=0, }, --朋友圈
    [73] = {track_id= 36, track_scene=7, track_type=1, }, --朋友圈分享成功
    -- 顶部功能键栏
    [74] = {track_id= 31, track_scene=9, track_type=0, }, --弹出海报弹框
    [75] = {track_id= 31, track_scene=9, track_type=1, }, --分享成功
    [76] = {track_id= 32, track_scene=9, track_type=0, }, --确认分享
    [77] = {track_id= 33, track_scene=9, track_type=0, }, --QQ
    [78] = {track_id= 33, track_scene=9, track_type=1, }, --QQ分享成功
    [79] = {track_id= 34, track_scene=9, track_type=0, }, --QQ空间
    [80] = {track_id= 34, track_scene=9, track_type=1, }, --QQ空间分享成功
    [81] = {track_id= 35, track_scene=9, track_type=0, }, --微信
    [82] = {track_id= 35, track_scene=9, track_type=1, }, --微信分享成功
    [83] = {track_id= 36, track_scene=9, track_type=0, }, --朋友圈
    [84] = {track_id= 36, track_scene=9, track_type=1, }, --朋友圈分享成功
}

function ClickStatistics:StaticInit()
    LOG.std("", "info", "ClickStatistics", "StaticInit");
    -- GameLogic.GetFilters():apply_filters("ClickStatistics", data);
    GameLogic.GetFilters():remove_filter("ClickStatistics", ClickStatistics.OnClick_Callback);
    GameLogic.GetFilters():add_filter(
        "ClickStatistics",
        function (data)
            if data then
                echo("----------------data----------------")
                echo(data)
                echo(ClickStatistics.ClickInfo[data.type])
                local param = {}
                if ClickStatistics.ClickInfo[data.type] then
                    param = ClickStatistics.ClickInfo[data.type]
                end
                if System.Codepku then
                    if HomeManage:IsMyHome() then
                        param.keepwork_id = 0
                    else
                        if System.Codepku and System.Codepku.Coursewares then
                            param.keepwork_id = System.Codepku.Coursewares.keepwork_project_id
                            echo("System.Codepku.Coursewares.keepwork_project_id--------------------"..System.Codepku.Coursewares.keepwork_project_id)
                        end
                    end
                else
                    param.keepwork_id = 0
                end
                echo(param)
                ClickStatistics:UpdateClickStatistics(param)
            end
        end
    );
end

function ClickStatistics:OnClick_Callback()

end

--[[
    @desc 更新后台数据
    @param data eg:{ids="1, 20"}
]]
function ClickStatistics:UpdateClickStatistics(data)
    request:post('/users/track', data, nil):next(function(response)
        echo(response)
    end):catch(function(e)
    end);
end
