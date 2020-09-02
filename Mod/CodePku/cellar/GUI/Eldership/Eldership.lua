--[[
Title: eldership
Author: loujiayu
Date: 2020/9/1
-----------------------------------------------

local Eldership = NPL.load("(gl)Mod/CodePku/cellar/GUI/Eldership/Eldership.lua");
Eldership:ShowPage();
-----------------------------------------------
]]

local Eldership = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");


Eldership.iconPng = "codepku/image/textures/eldership/eldership.png"                -- 按键雪碧图
Eldership.backgroundPng = "codepku/image/textures/eldership/eldershipbg.png"        -- 我的家长背景图
Eldership.unbindPng = "codepku/image/textures/eldership/unbind.png"                 -- 解绑提示背景图
Eldership.unbindContent = {
    [1] = "我的家长:",
    [2] = "学习报告",
    [3] = "实时掌握孩子学情",
    [4] = "教学咨询",
    [5] = "一手教学课程全掌握",
    [6] = "充值代付",
    [7] = "消费充值全透明",
    [8] = "未绑定微信",
    [9] = "扫码直接关联学生或者",
    [10] = "截屏保存二维码 > 打开微信扫描二维码关联",
    [11] = "温馨提示：扫码后微信将自动关联学生账号，请勿分享至陌生人",
    [12] = "小朋友，解除微信绑定后无法再解锁课程，是否解除家长绑定？",
}

Eldership.iconData = {
    [1] = {url=Eldership.iconPng, left=40, top=44, width=107, height=129},
    [2] = {url=Eldership.iconPng, left=175, top=47, width=84, height=86},
    [3] = {url=Eldership.iconPng, left=304, top=46, width=113, height=71},
    [4] = {url=Eldership.iconPng, left=470, top=29, width=122, height=123},
    [5] = {url=Eldership.iconPng, left=647, top=45, width=67, height=85},
    [6] = {url=Eldership.iconPng, left=775, top=44, width=75, height=89},
    [7] = {url=Eldership.iconPng, left=908, top=46, width=73, height=81},
    [8] = {url=Eldership.iconPng, left=61, top=204, width=268, height=268},
    [9] = {url=Eldership.iconPng, left=368, top=278, width=245, height=86},
    [10] = {url=Eldership.iconPng, left=694, top=278, width=245, height=86},
}

-- 获取对应图标
function Eldership.GetEldershipIconHTMLStr( id )
    local path=""
    id = tonumber(id)
    path = path..Eldership.iconData[id].url
    path = path..'#'
    path = path..tostring(Eldership.iconData[id].left)
    path = path..' '..tostring(Eldership.iconData[id].top)
    path = path..' '..tostring(Eldership.iconData[id].width)
    path = path..' '..tostring(Eldership.iconData[id].height)
    LOG.std(nil, "Eldership", "GetEldershipIconHTMLStr", "path = %s", path)
    return path
end

-- 我的家长页面
function Eldership:ShowPage()
    GameLogic.AddBBS("CodeGlobals", L"功能开发中", 3000, "#ff0000");
    params = {
      url="Mod/CodePku/cellar/GUI/Eldership/Eldership.html", 
      alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    };
    AdaptWindow:QuickWindow(params)
end

-- 绑定页面
function Eldership:ShowBindPage()
    GameLogic.AddBBS("CodeGlobals", L"绑定页面功能开发中", 3000, "#ff0000");
    params = {
      url="Mod/CodePku/cellar/GUI/Eldership/EldershipBind.html", 
      alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    };
    AdaptWindow:QuickWindow(params)
end

-- 解绑页面
function Eldership:ShowUnbindPage()
    GameLogic.AddBBS("CodeGlobals", L"解绑功能开发中", 3000, "#ff0000");
    params = {
      url="Mod/CodePku/cellar/GUI/Eldership/EldershipUnbind.html", 
      alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
    };
    AdaptWindow:QuickWindow(params)
end