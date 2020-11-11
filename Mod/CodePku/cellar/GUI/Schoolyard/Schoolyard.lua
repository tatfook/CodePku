--[[
Title: Schoolyard
Author: loujiayu
Date: 2020/11/02
-----------------------------------------------
local Schoolyard = NPL.load("(gl)Mod/CodePku/cellar/GUI/Schoolyard/Schoolyard.lua");
Schoolyard:ShowPage();
-----------------------------------------------
]]

local Schoolyard = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local schoolyardImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/schoolyardImageData.lua")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");


-- 标签
Schoolyard.tabs = {
    [1] = {name = "home", title = "首页"},
    [2] = {name = "members", title = "成员"},
    [3] = {name = "trends", title = "动态"},
}

-- 存放省市区学校
Schoolyard.location_table = {}

-- 返回图片path
function Schoolyard:GetImagePath(index)
    return schoolyardImageData:GetIconUrl(index)
end

-- 获取地址树
function Schoolyard:GetAreasTree()
    request:get('/areas'):next(function(response)
        Schoolyard.AreasTreeData = response.data.data
        echo("Schoolyard.AreasTreeData[1].name")
        echo(Schoolyard.AreasTreeData[1].name)
    end):catch(function(e)
        LOG.std(nil, "error", "Schoolyard", "GetAreasTree")
    end);
end

-- 活跃度数值处理|return str
function Schoolyard:DigitalProcessing(vitality)
    local vitality_int = tonumber(vitality)
    local result
    if vitality_int <10000 then
        result = tostring(vitality_int)
    elseif vitality_int > 9999 then
        vitality_int = vitality_int / 10000
        result = vitality_int - vitality_int % 0.1
        result = tostring(result) .. "w+"
    end
    return result
end

-- 上线状态数值处理|return str
function Schoolyard:TimeProcessing(time_statu)
    local result
    result = time_statu
    return result
end

-- todo增加活跃度
function Schoolyard:AddVitality(params)
    --[[
        @params:
        登陆{type = "login"}
        上课{type = "course",courseware_id = courseware_id,category = System.Codepku.Coursewares and System.Codepku.Coursewares.course.category}
        游戏{type = "game", courseware_id = courseware_id}
        家园{type = "home", time = "start\close"}
        小目标{type = "smalltarget"}
        大计划{type = "bigplan"}
    ]]

    echo("when the user trigger the vitality filter")
    echo(params.type)
    if params.type == "home" and params.time then
        echo(params.time)
        if params.time == "close" then
            -- 关闭计时器
        elseif params.time == "start" then
            -- 开启计时器
            Schoolyard.duration_timer = commonlib.Timer:new({
                callbackFunc = function(timer)
                    if Schoolyard.TimerTimes == 15 then
                        GameLogic.AddBBS("CodeGlobals", L"关闭计时器", 3000, "#FF0000");
                        Schoolyard.TimerTimes = nil
                        LOG.std("", "info", "Schoolyard", "timer close");
                        timer:Change()
                    end
                    if not Schoolyard.TimerTimes then
                        Schoolyard.TimerTimes = 0
                        LOG.std("", "info", "Schoolyard", "timer init");
                    end
                    Schoolyard.TimerTimes = Schoolyard.TimerTimes + 1
                end
            })
            Schoolyard.duration_timer:Change(0, 1000)
        end
    end
end

-- 查询我的学校
function Schoolyard:GetMySchoolyardInfo(page)
    request:get('/schools/mime'):next(function(response)
        local data = response.data.data
        if not next(data) then
            Schoolyard.joined_schoolyard = false
        else
            local province, city, district
            Schoolyard.joined_schoolyard = true     -- 是否已经有组织了
            Schoolyard.schoolyard_avatar = "https://cdn.codepku.com//img/default_avatar/0714/20180714163534.png"    -- 学校头像
            Schoolyard.week_rank = data.weekly_activity        -- 学校周活跃排行
            Schoolyard.total_rank = data.total_activity       -- 学校总活跃排行
            Schoolyard.schoolyard_name = data.name       -- 学校名字
            -- todo 拼接学校地址
            Schoolyard.schoolyard_address = province .. city .. district .. data.name      -- 学校位置


            Schoolyard.schoolyard_level = "Lv.999"        -- 学校等级
            Schoolyard.schoolyard_vitality = 123123123      -- 学校周活跃度
            Schoolyard.number_of_people = 1234      -- 学校人数

            page:Refresh(0)
        end
        
    end):catch(function(e)
        LOG.std(nil, "error", "Schoolyard", "GetMySchoolyardInfo")
    end);


end

-- 搜索学校
function Schoolyard:GetSearchSchoolResult(params, page)
    Schoolyard.search_result = {
        {name = "宾夕法尼亚小学", no = 1,},
        {name = "宾夕法尼亚小学", no = 2,},
        {name = "宾夕法尼亚小学", no = 3,},
        {name = "宾夕法尼亚小学", no = 4,},
        {name = "宾夕法尼亚小学", no = 5,},
        {name = "宾夕法尼亚小学", no = 6,},
        {name = "宾夕法尼亚小学", no = 7,},
        {name = "宾夕法尼亚小学", no = 8,},
        {name = "宾夕法尼亚小学", no = 9,},
        {name = "宾夕法尼亚小学", no = 10,},
        {name = "宾夕法尼亚小学", no = 11,},
    }
    if page then
        page:Refresh(0)
    end
end

-- 筛选学校
function Schoolyard:GetSelectLocation(param, page)
    if param == "province" then
        Schoolyard.location_table["province"] = {"北京", "上海", "广州"}
    end
end

-- 我的校园成员
function Schoolyard:GetMembers()
    Schoolyard.my_members = {
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
    }
end

-- 选择省市区
-- 省市县学校初始，用户选择后用下面的变量来接收
Schoolyard.selected_province = nil
Schoolyard.selected_city = nil
Schoolyard.selected_area = nil
Schoolyard.selected_school = nil

-- 展示我的校园页面
function Schoolyard:ShowPage()
    if self.main_ui then
        self.main_ui:CloseWindow()
        self.main_ui = nil
    end
    -- 默认选择index=1的标签，这里是首页
    Schoolyard.tabs_select_index = 1
    local params = {
        url="Mod/CodePku/cellar/GUI/Schoolyard/Schoolyard.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 20
    };
    self.main_ui = AdaptWindow:QuickWindow(params)
    Schoolyard:GetMySchoolyardInfo(self.main_ui)
end

-- 展示加入学校页面
function Schoolyard:ShowJoinPage()
    -- 这里有输入框，为了IOS适配，需要特殊处理下，再开一个空页面放下面
    if self.EmptyBG then
        self.EmptyBG:CloseWindow()
        self.EmptyBG = nil
    end

    local BGparams = {
        url="Mod/CodePku/cellar/GUI/Profile/EditNameEmptyPage.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 21,
    }
    self.EmptyBG = AdaptWindow:QuickWindow(BGparams)

    -- 加入的页面
    if self.join_page then
        self.join_page:CloseWindow()
        self.join_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/Schoolyard/Popup/JoinSchoolyard.html",
        alignment="_lt", left = 330, top = 82, width = 1312 , height = 832, zorder = 22
    };
    self.join_page = AdaptWindow:QuickWindow(params)
end

-- 加入页面有输入框，需要把两个窗口都关掉
function Schoolyard:JoinPageSpecialClose()
    if self.EmptyBG then
        self.EmptyBG:CloseWindow()
        self.EmptyBG = nil
    end
    if self.join_page then
        self.join_page:CloseWindow()
        self.join_page = nil
    end
end

-- 筛选弹窗
function Schoolyard:ShowSelectPage()
    if self.select_page then
        self.select_page:CloseWindow()
        self.select_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/Schoolyard/Popup/SelectLocation.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 23
    };
    self.select_page = AdaptWindow:QuickWindow(params)
end
