--[[
Title: VisitorLimit
Author: loujiayu
Date: 2020/10/27
-----------------------------------------------
local VisitorLimit = NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/VisitorLimit.lua");
local params = {
    title = "标题",
    content = "提示内容",
}
VisitorLimit:CheckStatus(params);       |return true or false like isVisitor

代码方块内精品课权限通知推荐用法：
    local isVisitor = commonlib.getfield("System.User.isVisitor")
    if isVisitor then
        local VisitorLimit = NPL.load("(gl)Mod/CodePku/cellar/GUI/AccountUp/VisitorLimit.lua");
        local params = {
            title = "标题",
            content = "提示内容",
            source = 1(int，代表从不同的入口调用，不参与数据统计就不传)
        }
        VisitorLimit:CheckStatus(params);
    else
        cmd("/connectCodePku 世界ID")
    end
-----------------------------------------------
]]

local VisitorLimit = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")

-- 获取图片
function VisitorLimit:GetIconPath(type, index)
    if type == 1 then
        return common1ImageData:GetIconUrl(index)
    elseif type == 2 then
        return escFrameImageData:GetIconUrl(index)
    end
end

-- 判断游客身份，展示弹窗
function VisitorLimit:CheckStatus(params)
    local isVisitor = commonlib.getfield("System.User.isVisitor")
    if isVisitor then
        -- 是游客
        VisitorLimit.PageTitle = (params or {}).title or "提示"
        VisitorLimit.PageContent = (params or {}).content or "你现在是游客账号，暂不支持该操作，是否立即升级账号？"
        VisitorLimit.source = (params or {}).source
        VisitorLimit:ShowVisitorLimitPage()
        return true
    else
        -- 不是游客
        return false
    end
end

-- 权限提醒弹窗
function VisitorLimit:ShowVisitorLimitPage()
    if VisitorLimit.PageShowed then
        return
    end
    VisitorLimit.PageShowed = true
    local params = {
        url="Mod/CodePku/cellar/GUI/AccountUp/VisitorLimit.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
    };
    VisitorLimit.ui = AdaptWindow:QuickWindow(params)
end

-- 预设数据销毁，避免下次开启传入错误参数
function VisitorLimit:destroy()
    VisitorLimit.PageTitle = nil
    VisitorLimit.PageContent = nil
    VisitorLimit.source = nil
end