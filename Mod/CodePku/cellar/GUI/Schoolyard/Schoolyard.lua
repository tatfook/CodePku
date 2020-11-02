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
