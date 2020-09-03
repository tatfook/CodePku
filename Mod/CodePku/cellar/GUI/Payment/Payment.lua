--[[
Title: Payment
Author: loujiayu
Date: 2020/9/3
-----------------------------------------------

local Payment = NPL.load("(gl)Mod/CodePku/cellar/GUI/Payment/Payment.lua");
Payment:ShowPage();
-----------------------------------------------
注意:目前只调用本地货币数量

]]

local Payment = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local UserInfoPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/UserInfo.lua");

Payment.params = {
    CoursePayment = {
        url="Mod/CodePku/cellar/GUI/Payment/CoursePayment.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
      },
    Recharge = {
        url="Mod/CodePku/cellar/GUI/Payment/Recharge.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31
      },
}

-- UserInfoPage.money = {goldcoin=0, wanxuecoin=0} 用户登陆后获取数据库货币数量

function Payment:ShowPage(pagename)
    ToPage = tostring(pagename)
    AdaptWindow:QuickWindow(Payment.params[ToPage])
end
