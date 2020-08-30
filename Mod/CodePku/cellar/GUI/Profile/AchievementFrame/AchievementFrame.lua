--[[
Title: Achievement
Author: loujiayu
Date: 2020/8/25
-----------------------------------------------

AchievementPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/Profile/AchievementFrame/AchievementFrame.lua");

-----------------------------------------------
]]
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local AchievementPage = NPL.export();

--[[
成就解锁状态可以优化，1-已解锁已领取，2-已解锁未领取，3未解锁
params:
    total_score:玩家成就总分数;
    rank:1-已解锁,2-未解锁;
    name:成就名称;
    status:1-已领取,2-未领取;
--]]

-- 测试成就数据
AchievementPage.award_png = {
    [1] = {url = "codepku/image/textures/common_32bits.png#913 41 73 71", description = "金币图片"},
    [2] = {url = "codepku/image/textures/profile/achievement.png#199 15 139 134", description = "成就积分奖杯图片"},
    [3] = {url = "codepku/image/textures/profile/achievement.png#341 330 272 272:15 15 15 15", description = "已解锁成就图片"},
    [4] = {url = "codepku/image/textures/profile/achievement.png#22 330 272 272", description = "未解锁成就图片"},
    [5] = {url = "codepku/image/textures/profile/achievement.png#246 192 80 82:15 15 15 15", description = "已解锁成就名称背景图"},
    [6] = {url = "codepku/image/textures/profile/achievement.png#361 192 81 81:15 15 15 15", description = "未解锁成就名称背景图"},
    [7] = {url = "codepku/image/textures/profile/achievement.png#731 183 100 100:20 20 20 20", description = "成就描述背景图"},
    [8] = {url = "codepku/image/textures/profile/achievement.png#6 718 862 300", description = "成就奖励列表背景图"},
    [9] = {url = "codepku/image/textures/profile/achievement.png#18 15 134 134", description = "金币白色边框"},
    [10] = {url = "codepku/image/textures/designation/designationIcon.png#107 106 354 99", description = "奖励解锁称号"},
    [11] = {url = "codepku/image/textures/profile/achievement.png#21 190 86 86:15 15 15 15", description = "绿色按钮背景图"},
    [12] = {url = "codepku/image/textures/profile/achievement.png#490 190 86 86:15 15 15 15", description = "灰色按钮背景图"},
    [13] = {url = "codepku/image/textures/profile/achievement.png#961 88 44 44", description = "提示红点"},
    [14] = {url = "codepku/image/textures/profile/achievement.png#731 183 100 100:20 20 20 20", description = "成就奖励弹窗蓝色大背景图"},
    [15] = {url = "codepku/image/textures/profile/achievement.png#670 307 281 418", description = "成就奖励背景图"},
    [16] = {url = "codepku/image/textures/profile/achievement.png#609 183 100 100:20 20 20 20", description = "未解锁奖励灰色透明遮罩"},
    [17] = {url = "codepku/image/textures/profile/achievement.png#874 241 94 32:20 0 20 0", description = "成就积分进度条白底"},
    [18] = {url = "codepku/image/textures/profile/achievement.png#874 191 94 32:20 0 20 0", description = "成就积分进度条"},
    [19] = {url = "codepku/image/textures/profile/achievement.png#837 99 31 22", description = "下箭头，暂时代替左右翻页"},
}

AchievementPage.data = {
    {rank = 1, name = "成就1", status = 1, id = 1, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 10, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"}, [3] = {title = "称号名称", value = "解锁称号", image = "codepku/image/textures/designation/designationIcon.png#107 106 354 99"},},},
    {rank = 1, name = "成就2", status = 1, id = 2, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 10, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 1, name = "成就3", status = 2, id = 3, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 10, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "道具奖励", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 1, name = "成就4", status = 2, id = 4, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 10, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"}, [3] = {title = "称号名称", value = "解锁称号", image = "codepku/image/textures/designation/designationIcon.png#107 106 354 99"},},},
    {rank = 2, name = "成就5", status = 2, id = 5, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就6", status = 2, id = 6, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "道具奖励", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就7", status = 2, id = 7, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就8", status = 2, id = 8, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "道具奖励", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就9", status = 2, id = 9, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就10", status = 2, id = 10, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就11", status = 2, id = 11, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就12", status = 2, id = 12, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
    {rank = 2, name = "成就13", status = 2, id = 13, description = "成就介绍，达成成就所需具备的条件，当前进度：", completed = 5, requirement = 10, award = {[1] = {title = "成就积分奖励", num = 200, image = "codepku/image/textures/profile/achievement.png#199 15 139 134"},[2] = {title = "金币", num = 1234, image = "codepku/image/textures/common_32bits.png#913 41 73 71"},},},
}



-- 成就页面初始化
function AchievementPage:Init()
    AchievementPage.show_top_navig = 0          -- 下拉框是否显示
    AchievementPage.top_navig_index = 1         -- 当前选择框显示的分类index
    AchievementPage.detail = {}                 -- 单个成就详细数据
    AchievementPage.top_navig_table = {
        [1] = {title = "全部",name = "all", index = 1},
        [2] = {title = "已解锁",name = "unlock",index = 2},
        [3] = {title = "未解锁",name = "lock", index = 3},
    }
    AchievementPage.achievementinfo = {
        userachievement = {
            total_score = 123123,
            next_level = 654321,
            title = "成就奖励",
            name = "成就积分",
            award_list = {
                [1] = {id = 1, status = 2, title = "已领取", bounty = 300, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [2] = {id = 2, status = 2, title = "已领取", bounty = 600, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [3] = {id = 3, status = 2, title = "已领取", bounty = 1000, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [4] = {id = 4, status = 1, title = "领取", bounty = 1500, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [5] = {id = 5, status = 1, title = "领取", bounty = 2000, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [6] = {id = 6, status = 1, title = "领取", bounty = 2500, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [7] = {id = 7, status = 3, title = "未解锁", bounty = 2500, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [8] = {id = 8, status = 3, title = "未解锁", bounty = 2500, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
                [9] = {id = 9, status = 3, title = "未解锁", bounty = 2500, background_pictrue = AchievementPage.award_png[9].url, picture = AchievementPage.award_png[1].url,},
            },
        },
        award = {
            total = 9999,
            total_unreceive = 0
        },
        achievementdata = AchievementPage.data
    }
    AchievementPage.GetTotalUnreceive(AchievementPage.achievementinfo)
    AchievementPage.SortData(AchievementPage.achievementinfo.achievementdata)
end

-- 领取奖励页面初始化
function AchievementPage:AwardInit()
    -- 当前所在页码
    AchievementPage.award_pagination = 1
    -- 首个展示的奖励
    AchievementPage.frist_show_index = 1
    -- 单页显示数量
    AchievementPage.detail_perpage = 4
    -- 奖励总个数
    AchievementPage.award_details_count = #AchievementPage.achievementinfo.userachievement.award_list
    -- 最大分页
    AchievementPage.max_award_page = math.ceil(AchievementPage.award_details_count/AchievementPage.detail_perpage)
    -- 获取展示的第一个奖励index
    for k,v in ipairs(AchievementPage.achievementinfo.userachievement.award_list) do
        if v.status == 1 then
            AchievementPage.frist_show_index = k
            return
        end
    end

end

-- 获取未领取奖励的个数
function AchievementPage.GetTotalUnreceive(data)
    local unreceive_num = 0
    for _,i in pairs(data.userachievement.award_list) do
        if i.status == 1 then
            unreceive_num = unreceive_num + 1
        end
    end
    data.award.total_unreceive = unreceive_num
end

-- 点击领取奖励
function AchievementPage.ClickReceiveScore()
    AchievementPage:ShowReceiveAwardPage()
end


-- 点击成就图片
function AchievementPage.ClickedAchievement(name)
    for _,v in pairs(AchievementPage.achievementinfo.achievementdata) do
        if v.id == name then
            AchievementPage.detail = v
        end
    end
    AchievementPage:ShowAchievementPage()
end

-- 选择下拉框
function AchievementPage.SelectShowPage()
    if AchievementPage.top_navig_index == 2 then
        -- 已解锁
        local temp_table = {}
        for _,i in pairs(AchievementPage.data) do 
            if AchievementPage.data.rank == 1 then
                table.insert(temp_table,i)
                AchievementPage.achievementinfo.achievementdata = temp_table
            end
        end
    elseif AchievementPage.top_navig_index == 3 then
        -- 未解锁
        local temp_table = {}
        for _,i in pairs(AchievementPage.data) do 
            if AchievementPage.data.rank == 2 then
                table.insert(temp_table,i)
                AchievementPage.achievementinfo.achievementdata = temp_table
            end
        end
    else
        -- 全部
        AchievementPage.achievementinfo.achievementdata = AchievementPage.data
    end
    AchievementPage.SortData(AchievementPage.achievementinfo.achievementdata)
end

-- 排序规则
function AchievementPage.SortData(data)
    if type(data) ~= "table" then
        LOG.std(nil, "Designation", "data_sort", "error: data is not a table")
        return nil
    end
    local function CompFunc(a, b)
        if a.rank == b.rank then
            if a.status == b.status then
                return a.id < b.id
            end
            return a.status > b.status
        end
        return a.rank < b.rank
    end
    table.sort(data, CompFunc)
end


-- 展示成就详情
function AchievementPage:ShowAchievementPage()
    params = {
        url="Mod/CodePku/cellar/GUI/Profile/AchievementFrame/AchievementDetail.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
      };
    AdaptWindow:QuickWindow(params)
end

-- 展示领取奖励
function AchievementPage:ShowReceiveAwardPage()
    params = {
        url="Mod/CodePku/cellar/GUI/Profile/AchievementFrame/ReceiveAward.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
      };
    AdaptWindow:QuickWindow(params)
end

