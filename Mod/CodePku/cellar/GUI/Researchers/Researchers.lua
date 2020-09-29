--[[
Title: Researchers
Author: loujiayu
Date: 2020/9/23
-----------------------------------------------

local Researchers = NPL.load("(gl)Mod/CodePku/cellar/GUI/Researchers/Researchers.lua");
Researchers:ShowPage(id);
-----------------------------------------------
]]

local Researchers = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local Eldership = NPL.load("(gl)Mod/CodePku/cellar/GUI/Eldership/Eldership.lua");


Researchers.IconsV1 = "codepku/image/textures/researchers/researchersV1.png"    -- 按键雪碧图
Researchers.NoticeBGV1 = "codepku/image/textures/researchers/bg.png"    -- 蓝色弹窗背景
Researchers.PKV1 = "codepku/image/textures/researchers/PKV1.png"    -- 搭建PK背景
Researchers.PKBGV1 = "codepku/image/textures/researchers/PKcontentBGV1.png" -- 搭建PK的紫色小背景
Researchers.BuildingContentV1 = "codepku/image/textures/researchers/buildingV1.png" -- 家园搭建图片内容
Researchers.NoticeV1 = "codepku/image/textures/researchers/noticeV1.png"    -- 通知的图片内容
Researchers.Activity = "codepku/image/textures/researchers/activity.png"    -- 黄色确认按钮



Researchers.contents = {
    [1] = "家园区搭建指南",
    [2] = "我要学习",
    [3] = "进入家园区",
    [4] = "信息发送",
    [5] = "确认",
    [6] = "接受挑战",
}

Researchers.iconData = {
    [1] = {url=Researchers.IconsV1, left=64, top=63, width=246, height=86, desc="绿色按键",},
    [2] = {url=Researchers.IconsV1, left=444, top=68, width=68, height=78, desc="黄色叉叉",},
    [3] = {url=Researchers.IconsV1, left=580, top=66, width=68, height=78, desc="白色叉叉",},
    [4] = {url=Researchers.IconsV1, left=64, top=161, width=289, height=100, desc="蓝色按键",},
    [5] = {url=Researchers.IconsV1, left=67, top=293, width=175, height=175, desc="小助手微信二维码",},
    [6] = {url=Researchers.IconsV1, left=67, top=503, width=859, height=171, desc="搭建大PKtitle",},
    [7] = {url=Researchers.IconsV1, left=76, top=758, width=511, height=108, desc="黄色标题背景",},
}

-- 获取对应图标
function Researchers.GetResearchersIconHTMLStr( id )
    local path=""
    id = tonumber(id)
    path = path..Researchers.iconData[id].url
    if Researchers.iconData[id].left then
      path = path..'#'
      path = path..tostring(Researchers.iconData[id].left)
      path = path..' '..tostring(Researchers.iconData[id].top)
      path = path..' '..tostring(Researchers.iconData[id].width)
      path = path..' '..tostring(Researchers.iconData[id].height)
    end
    LOG.std(nil, "Researchers", "GetResearchersIconHTMLStr", "path = %s", path)
    return path
end

function Researchers:xiaoe()
    request:post('/external-courses/xiaoe0923',{}):next(function(response)
        
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end);
end


-- 页面
Researchers.params = {
    -- 搭建指南
    [1] = {url="Mod/CodePku/cellar/GUI/Researchers/BuildingBoard.html", alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,},
    -- 赛事通知
    [2] = {url="Mod/CodePku/cellar/GUI/Researchers/CompetitionBoard.html", alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,},
    -- 信息发送通知
    [3] = {url="Mod/CodePku/cellar/GUI/Researchers/MsgNotice.html", alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,},
}

function Researchers:ShowPage(id, url)

    if url == nil then
        Researchers.link_url = Mod.CodePku.BasicConfigTable.links.main_world_announcement or "https://none.h5.xeknow.com/st/1rEaMCUNU"
    else
        local url = tostring(url)
        Researchers.link_url = url
    end

    local id = tonumber(id)
    if self.ui then
        self.ui = nil
    end
    if id == 1 then
        -- 查询绑定状态
        Eldership:GetBindStatus()
    end
    self.ui = AdaptWindow:QuickWindow(self.params[id])
end