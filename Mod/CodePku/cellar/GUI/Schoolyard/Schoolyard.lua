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
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");



Schoolyard.tabs = {
    [1] = {name = "home", title = "首页"},
    [2] = {name = "members", title = "成员"},
    [3] = {name = "trends", title = "动态"},
}


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

-- todo增加活跃度
function Schoolyard:AddVitality(type)
    
end

-- 查询我的学校
function Schoolyard:GetMySchoolyard()
    Schoolyard.schoolyard_avatar = "https://cdn.codepku.com//img/default_avatar/0714/20180714163534.png"    -- 学校头像
    Schoolyard.schoolyard_name = "宾夕法尼亚小学"
    Schoolyard.schoolyard_address = "费城"
    Schoolyard.schoolyard_level = 10
    Schoolyard.schoolyard_vitality = 123123123
    Schoolyard.number_of_people = 1234
    Schoolyard.week_rank = 1
    Schoolyard.total_rank = 1
end

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
end

-- 展示加入学校页面
function Schoolyard:ShowJoinPage()
    if self.join_page then
        self.join_page:CloseWindow()
        self.join_page = nil
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/Schoolyard/Popup/JoinSchoolyard.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 21
    };
    self.join_page = AdaptWindow:QuickWindow(params)
end
