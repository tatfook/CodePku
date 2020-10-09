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
Payment.Recharge_send_content = "已推送详情到家长微信~快和爸爸妈妈沟通购买课程吧"

Payment.TimerTable = {}

Payment.params = {
    -- 解锁提示页面
    CoursePayment = {
        url="Mod/CodePku/cellar/GUI/Payment/CoursePayment.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 32
      },
    -- 充值提示页面
    Recharge = {
        url="Mod/CodePku/cellar/GUI/Payment/Recharge.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 33
      },
    -- 家长绑定页面
    Eldership = {
        url="Mod/CodePku/cellar/GUI/Eldership/EldershipBind.html", 
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 32
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

Payment.pagePackage = {}
function Payment:ShowPage(pagename)
    local page
    ToPage = tostring(pagename)
    page = AdaptWindow:QuickWindow(Payment.params[ToPage])
    table.insert(Payment.pagePackage, page)
end


function Payment:PurchaseNotice()
    if next(Payment.TimerTable) ~= nil then
        for k,v in pairs(Payment.TimerTable) do
            --遍历表，找到已经发送过请求的记录,结尾必须返回，防止进入下面全新请求的逻辑
            if v.lastClicktype == Payment.entity_type and v.lastClickid == Payment.entity_id then
                -- 计时器结束时会清空当前表，所以能遍历到记录说明计时器没过期，此时需要直接返回
                return
            end
        end
    end
    -- 表中未记录的请求，需要重新发起并加入表中
    Payment:SendNotice()
    local temp_table = {}
    temp_table.lastClicktype = Payment.entity_type
    temp_table.lastClickid = Payment.entity_id
    temp_table.TimerTimes = 60
    temp_table.content = "课程解锁申请已推送到您家长微信啦~请勿频繁点击哦"
    temp_table.timer = commonlib.Timer:new({
        callbackFunc = function(timer)
            if temp_table.TimerTimes == 0 then
                temp_table.lastClicktype = nil
                temp_table.lastClickid = nil
                temp_table.content = nil
                timer:Change(nil, nil)
            end
            temp_table.TimerTimes = temp_table.TimerTimes - 1
        end
    })
    temp_table.timer:Change(1000, 1000)
    table.insert(Payment.TimerTable, temp_table)
end

function Payment:SendNotice()
    -- todo 发送购买通知
    local params = {
        entity_id = Payment.entity_id,
        entity_type = Payment.entity_type,
    }
    request:post('/notices/parent-unlock-course',params):next(function(response)

    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end);
end


-- 一键关闭所有教学区页面，慎用
function Payment:TurnOffAllPage()
    for k,v in pairs(Payment.pagePackage) do
        if next(v) ~= nil then
            v:CloseWindow()
        end
    end
end