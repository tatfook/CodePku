--[[
Author(s): wanglj
Date: 2020.08.14
Desc: store UI
]]

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local MainStorePage = NPL.export()
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

MainStorePage.mainWindow = nil
MainStorePage.subWindow = nil

MainStorePage.cur_index = 1
MainStorePage.cur_item = nil
MainStorePage.items = {}

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


function MainStorePage:GetCategory()
    response = request:get('/config/basic',nil,{sync = true})

    if (response.status == 200 and response.data.code == 200) then        
        local data = response.data.data.prop_shop_categories or {};
        -- echo('MainStorePage:GetCategory')
        -- echo(data)

        local category = {}

        for k,v in pairs(data) do
            table.insert(category,{categoryId=tonumber(k),name=v})
        end
        -- echo(category)
        return category
    end
end


MainStorePage.category = MainStorePage:GetCategory()


function MainStorePage:GetItems(category)
    response = request:get('/shop',{category=category}, {sync = true})

    if (response.status == 200 and response.data.code == 200) then 

        local data = response.data.data or {};
        table.sort(data, function(a, b)
            return a.sort < b.sort
        end)
        -- echo('MainStorePage:GetItems')
        -- echo(data)
        return data
    end
end


MainStorePage.items = MainStorePage:GetItems(MainStorePage.cur_index)


function MainStorePage:GetCurItem(itemId)
    for _,v in pairs(MainStorePage.items) do
        if v.id == itemId then
            return v
        end
    end
    
    return nil
end


function MainStorePage:ShowPage(pageIndex, itemId)
    --[[pageIndex:
        0       打开页面
        1以上   切换分类,刷新子页面
        -1      打开购买页面

        itemId:
        商品编号
    ]]
    index = tonumber(pageIndex)
    if index ~= nil then
        if index == 0 then
            MainStorePage.cur_index = 1
            MainStorePage.items = MainStorePage:GetItems(MainStorePage.cur_index)
            MainStorePage.mainWindow = AdaptWindow:QuickWindow(MainStorePage.pages["mainPage"])
            MainStorePage.subWindow = AdaptWindow:QuickWindow(MainStorePage.pages["subPage"])
        
        elseif index == -1 then
            MainStorePage.cur_item = MainStorePage:GetCurItem(itemId)
            if MainStorePage.cur_item then
                AdaptWindow:QuickWindow(MainStorePage.pages["buyPage"])
            end

        else
            if index ~= MainStorePage.cur_index then               
                MainStorePage.cur_index = index
                MainStorePage.items = MainStorePage:GetItems(MainStorePage.cur_index)
                MainStorePage.subWindow:Refresh(0)
            end
        end
    end
end


function RefreshMoney(id,num)
    id = tonumber(id)
    num = tonumber(num)
    local info = Mod.CodePku.Store:Get('user/info')
    local wallets = info.user_wallets or {}
    if #wallets == 0 then
        table.insert(wallets,{currency_id = id, amount = num})
    else
        for _, v in ipairs(wallets) do
            if v.currency_id == 1 and id == 1 then
                v.amount = v.amount - num
            elseif v.currency_id == 2 and id == 2 then
                v.amount = v.amount - num
            end
        end
    end

    Mod.CodePku.Store:Set('user/info', info)

end


function MainStorePage:BuyItem(itemId)
    response = request:post('/shop/purchase',{prop_shop_id=itemId}, {sync = true})

    if (response.status == 200 and response.data.code == 200) then
        RefreshMoney(MainStorePage.cur_item['currency_id'], MainStorePage.cur_item['price'])
        MainStorePage.mainWindow:Refresh(0)
        GameLogic.AddBBS("CodeGlobals", L'购买成功', 2000, "#FF0000") 
    else
        errString = string.format('%s(%s)',L'购买失败',response.data.code)
        echo(errString)
        GameLogic.AddBBS("CodeGlobals", errString, 3000, "#FF0000")
    end
end