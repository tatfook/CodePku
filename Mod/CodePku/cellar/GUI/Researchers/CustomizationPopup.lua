--[[
Title: CustomizationPopup
Author: loujiayu
Date: 2020/11/25
-----------------------------------------------

local CustomizationPopup = NPL.load("(gl)Mod/CodePku/cellar/GUI/Researchers/CustomizationPopup.lua");
NPL.load("(gl)Mod/CodePku/cellar/Common/CommonFunc/CommonFunc.lua")
local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")

local title_icon_path = "pic/title.png"     -- 左上角图片的路径
local data = {
    [1] = {title = "标题最多十二个字一", pic_path = "pic/1.png", func = function ()
        CommonFunc.OpenUrl(url, true, 'portrait')
    end, },
    [2] = {title = "标题最多十二个字二", pic_path = "pic/2.jpg", func = function ()
        GameLogic.RunCommand(string.format('/connectCodePku %d', id))
    end, },
    [3] = {title = "标题最多十二个字三", pic_path = "pic/3.png", func = function ()
        GameLogic.RunCommand(string.format('/loadworld %d', id))
    end, },
}
CustomizationPopup:ShowPage(data, title_icon_path)

-----------------------------------------------
]]
local CustomizationPopup = NPL.export()
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")


function CustomizationPopup:GetIconPathStr(index)
    return inviteImageData:GetIconUrl(index)
end

function CustomizationPopup:ShowPage(data, title_icon_path)
    if type(data) ~= "table" then
        GameLogic.AddBBS("CodeGlobals", L"无效的参数", 3000, "#FF0000");
        return
    end
    if title_icon_path then
        CustomizationPopup.title_icon_path = title_icon_path
    end
    CustomizationPopup.DataSource = {}
    for k,v in pairs(data) do
        local temp_table = {}
        temp_table.title = type(v.title) == "string" and v.title or ""
        temp_table.pic_path = type(v.pic_path) == "string" and v.pic_path or ""
        temp_table.func = type(v.func) == "function" and v.func or function () GameLogic.AddBBS("CodeGlobals", L"无效的function", 3000, "#FF0000"); end
        table.insert(CustomizationPopup.DataSource, temp_table)
    end
    local params = {
        url="Mod/CodePku/cellar/GUI/Researchers/CustomizationPopup.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    };
    AdaptWindow:QuickWindow(params)
end