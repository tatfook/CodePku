--[[
Author(s): wanglj
Date: 2020.08.14
Desc: store UI
]]

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local MainStorePage = NPL.export()

MainStorePage.cur_index = 1
MainStorePage.mainWindow = nil
MainStorePage.subWindow = nil

MainStorePage.cur_item = {}

MainStorePage.pages = {
    mainPage = {
        url = "Mod/CodePku/cellar/GUI/MainStore/mainPage.html", 
        alignment = "_ct",x = -1920/2,y = -1080/2,width = 1920,height = 1080,zorder = 10
    },
    subPage = {
        url = "Mod/CodePku/cellar/GUI/MainStore/subPage.html", 
        alignment = "_lt",x = 0,y = 131, width = 1920,height = 900,zorder = 20
    },
    buyPage = {
        url = "Mod/CodePku/cellar/GUI/MainStore/buyPage.html", 
        alignment = "_ct",x = -1920/2,y = -1080/2,width = 1920,height = 1080,zorder = 30
    },
}

MainStorePage.menu = {
    {pageIndex = 1, name = "建造"},
    {pageIndex = 2, name = "道具"},
}

MainStorePage.items = {
    {
        {itemIndex = 1, itemType = 1, itemId = 1, name = "名字最多七个字", imgUrl = "codepku/image/textures/store/test1.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 2, itemType = 1, itemId = 2, name = "蓝色的包裹2", imgUrl = "codepku/image/textures/store/test1.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 3, itemType = 1, itemId = 3, name = "蓝色的包裹3", imgUrl = "codepku/image/textures/store/test1.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 4, itemType = 1, itemId = 4, name = "蓝色的包裹4", imgUrl = "codepku/image/textures/store/test1.png",num = 4, coinType = 1, price = 66, limit=nil, remain = nil, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 5, itemType = 1, itemId = 1, name = "蓝色的包裹5", imgUrl = "codepku/image/textures/store/test1.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 6, itemType = 1, itemId = 2, name = "蓝色的包裹6", imgUrl = "codepku/image/textures/store/test1.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 7, itemType = 1, itemId = 3, name = "蓝色的包裹7", imgUrl = "codepku/image/textures/store/test1.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 8, itemType = 1, itemId = 4, name = "蓝色的包裹8", imgUrl = "codepku/image/textures/store/test1.png",num = 4, coinType = 1, price = 66, limit=nil, remain = nil, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 9, itemType = 1, itemId = 1, name = "蓝色的包裹9", imgUrl = "codepku/image/textures/store/test1.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 10, itemType = 1, itemId = 2, name = "蓝色的包裹10", imgUrl = "codepku/image/textures/store/test1.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2}, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......",
        {itemIndex = 11, itemType = 1, itemId = 3, name = "蓝色的包裹11", imgUrl = "codepku/image/textures/store/test1.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 12, itemType = 1, itemId = 4, name = "蓝色的包裹12", imgUrl = "codepku/image/textures/store/test1.png",num = 4, coinType = 1, price = 66, limit=nil, remain = nil, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 13, itemType = 1, itemId = 1, name = "蓝色的包裹13", imgUrl = "codepku/image/textures/store/test1.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 14, itemType = 1, itemId = 2, name = "蓝色的包裹14", imgUrl = "codepku/image/textures/store/test1.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 15, itemType = 1, itemId = 3, name = "蓝色的包裹15", imgUrl = "codepku/image/textures/store/test1.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 16, itemType = 1, itemId = 4, name = "蓝色的包裹16", imgUrl = "codepku/image/textures/store/test1.png",num = 4, coinType = 1, price = 66, limit=nil, remain = nil, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
    },
    {
        {itemIndex = 1, itemType = 2, itemId = 1, name = "棕色的包裹1", imgUrl = "codepku/image/textures/store/test2.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 2, itemType = 2, itemId = 2, name = "棕色的包裹2", imgUrl = "codepku/image/textures/store/test2.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 3, itemType = 2, itemId = 3, name = "棕色的包裹3", imgUrl = "codepku/image/textures/store/test2.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 4, itemType = 2, itemId = 4, name = "棕色的包裹4", imgUrl = "codepku/image/textures/store/test2.png",num = 4, coinType = 1, price = 66, limit=nil, remain = nil, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 5, itemType = 2, itemId = 1, name = "棕色的包裹5", imgUrl = "codepku/image/textures/store/test2.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 6, itemType = 2, itemId = 2, name = "棕色的包裹6", imgUrl = "codepku/image/textures/store/test2.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 7, itemType = 2, itemId = 3, name = "棕色的包裹7", imgUrl = "codepku/image/textures/store/test2.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 8, itemType = 2, itemId = 4, name = "棕色的包裹8", imgUrl = "codepku/image/textures/store/test2.png",num = 4, coinType = 1, price = 66, limit=nil, remain = nil, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 9, itemType = 2, itemId = 1, name = "棕色的包裹9", imgUrl = "codepku/image/textures/store/test2.png",num = 1, coinType = 1, price = 999999, limit=3, remain = 3, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 10, itemType = 2, itemId = 2, name = "棕色的包裹10", imgUrl = "codepku/image/textures/store/test2.png",num = 666, coinType = 2, price = 222, limit=3, remain = 2, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
        {itemIndex = 11, itemType = 2, itemId = 3, name = "棕色的包裹11", imgUrl = "codepku/image/textures/store/test2.png",num = 3, coinType = 1, price = 333, limit=3, remain = 0, desc="散发着香甜的气息，不知道会孵出什么，要不打开尝尝散发着香甜的气息，不知道会孵出什么，要不打开看看看......"},
    }
}


function MainStorePage:ShowPage(pageIndex, itemIndex)
    --[[pageIndex:
        0       打开页面
        1以上   切换分类,刷新子页面
        -1      打开购买页面

        itemIndex:
        物品编号
    ]]
    index = tonumber(pageIndex)
    if index ~= nil then
        if index == 0 then
            MainStorePage.cur_index = 1
            MainStorePage.mainWindow = AdaptWindow:QuickWindow(MainStorePage.pages["mainPage"])
            MainStorePage.subWindow = AdaptWindow:QuickWindow(MainStorePage.pages["subPage"])
        
        elseif index == -1 then
            local item = MainStorePage.items[MainStorePage.cur_index][itemIndex]
            MainStorePage.cur_item = item
            AdaptWindow:QuickWindow(MainStorePage.pages["buyPage"])

        else
            if index ~= MainStorePage.cur_index then
                MainStorePage.cur_index = index
                MainStorePage.subWindow:Refresh(0)
            end
        end
    end
end