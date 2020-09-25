--[[
Title: Payment
Author: loujiayu
Date: 2020/9/3
-----------------------------------------------

local Payment = NPL.load("(gl)Mod/CodePku/cellar/GUI/Payment/Payment.lua");
Payment:ShowPage();
-----------------------------------------------
注意:目前获得的货币数量是用户打开用户个人信息页面时缓存的货币数量,

]]

local Payment = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local UserInfoPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/UserInfo.lua");

Payment.iconPng = "codepku/image/textures/common_32bits.png"

Payment.params = {
    -- 解锁提示页面
    CoursePayment = {
        url="Mod/CodePku/cellar/GUI/Payment/CoursePayment.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
      },
    -- 充值提示页面
    Recharge = {
        url="Mod/CodePku/cellar/GUI/Payment/Recharge.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
      },
    -- 家长绑定页面
    Eldership = {
        url="Mod/CodePku/cellar/GUI/Eldership/EldershipBind.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
    },
}

Payment.iconData = {
    [1] = {url=Payment.iconPng, left=99, top=275, width=1158, height=588, describe="弹窗背景图"},
    [2] = {url=Payment.iconPng, left=1277, top=377, width=410, height=87, describe="黄色标题背景"},
    [3] = {url=Payment.iconPng, left=110, top=73, width=68, height=78, describe="关闭按钮"},
    [4] = {url=Payment.iconPng, left=1404, top=292, width=40, height=40, describe="蓝色背景"},
    [5] = {url=Payment.iconPng, left=913, top=136, width=77, height=78, describe="玩学币"},
    [6] = {url=Payment.iconPng, left=552, top=182, width=86, height=86, describe="绿色按钮"},
    [7] = {url=Payment.iconPng, left=438, top=182, width=86, height=86, describe="红色按钮"},

}

-- 获取对应图标
function Payment.GetPaymentIconHTMLStr(id)
    local path=""
    id = tonumber(id)
    path = path..Payment.iconData[id].url
    path = path..'#'
    path = path..tostring(Payment.iconData[id].left)
    path = path..' '..tostring(Payment.iconData[id].top)
    path = path..' '..tostring(Payment.iconData[id].width)
    path = path..' '..tostring(Payment.iconData[id].height)
    LOG.std(nil, "Payment", "GetPaymentIconHTMLStr", "path = %s", path)
    return path
end

-- UserInfoPage.money = {goldcoin=0, wanxuecoin=0} 用户登陆后获取数据库货币数量

function Payment:ShowPage(pagename)
    ToPage = tostring(pagename)
    AdaptWindow:QuickWindow(Payment.params[ToPage])
end
