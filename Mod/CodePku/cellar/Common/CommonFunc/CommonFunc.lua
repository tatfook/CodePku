--[[
Title: Page
Author(s): NieXX
Date: 2020/9/10
Desc:
use the lib:
virtual functions:
    isHuaweiApproval()
    isIOSApproval()
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/CommonFunc/CommonFunc.lua")
local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")
------------------------------------------------------------
]]

CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc");
NPL.load("(gl)script/ide/System/os/os.lua");


CommonFunc.ConfigCodingKeys = {
    [1] = '!F-gH.nKAhPC94fa', -- ApiService.saveScore
}

-- local CommonFunc = NPL.export();


-- Judge whether to pass the channel audit, such as huawei, flyme, sogou
-- e.g. CommonFunc.isHuaweiApproval();
-- @return:if successful return true, if falied return false
CommonFunc.isHuaweiApproval = function ()
    local huaweiApprovalStatus = Mod.CodePku.BasicConfigTable.huawei_approval_status == 'on'
    local app_market = ParaEngine.GetAppCommandLineByParam("app_market", "")
    local flymeApprovalStatus = Mod.CodePku.BasicConfigTable.flyme_approval_status == 'on'
    local sogouApprovalStatus = Mod.CodePku.BasicConfigTable.sogou_approval_status == 'on'
    if app_market == 'huawei' then
        return huaweiApprovalStatus
    elseif app_market == 'flyme' then
        return flymeApprovalStatus
    elseif app_market == 'sogou' then
        return sogouApprovalStatus
    else
        return false
    end
end

-- Judge whether IOS channel is approved or not
-- e.g. CommonFunc.isIOSApproval();
-- @return:if successful return true, if falied return false
CommonFunc.isIOSApproval = function ()
    local iosApprovalStatus = Mod.CodePku.BasicConfigTable.ios_approval_status == 'on'
    local mock_ios = ParaEngine.GetAppCommandLineByParam("mock_ios", "") == "true"
    local isIOSPlatform = System.os.GetPlatform() == 'ios'
    return (isIOSPlatform or mock_ios) and iosApprovalStatus
end

CommonFunc.isIOSPlatform = function ()
    local mock_ios = ParaEngine.GetAppCommandLineByParam("mock_ios", "") == "true"
    local isIOSPlatform = System.os.GetPlatform() == 'ios'
    return mock_ios or isIOSPlatform
end

-- 本地使用或者获得金币后, 刷新金币本地缓存和页面
-- 参数walletChange格式{{amount=0,currency_id=1,},{amount=0,currency_id=2,},}
-- 参数bshow是否显示金币页面
-- id=1玩学币,id=2玩学券    amount正数是获得,负数是消耗    可以只有一项{{amount=-1,currency_id=2,},}
--[[eg:
local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")
CommonFunc.RefreshLocalMoney({{amount=-100,currency_id=1,},{amount=-1,currency_id=2,},})
--]]
CommonFunc.RefreshLocalMoney = function (walletChange, windows, bshow)
    if walletChange and type(walletChange) == 'table' then
        local moneyChange = {}
        for _,v in pairs(walletChange) do
            if v. currency_id and v.amount then
                moneyChange[v.currency_id] = v.amount
            end
        end

        local info = System.User.info
        local user_wallets =  info and info.user_wallets
        if not (user_wallets and next(user_wallets)) then
            user_wallets = {{amount=0,currency_id=1,},{amount=0,currency_id=2,},}  -- 新号user_wallets为{}
        end

        for _,v in pairs(user_wallets) do
            if moneyChange[v.currency_id] then
                v.amount = v.amount + moneyChange[v.currency_id]
            end
        end
        info.user_wallets = user_wallets
        Mod.CodePku.Store:Set('user/info', info)

        if windows then
            for _,window in pairs(windows) do
                window:Refresh(0)
            end
        end

        if bshow then
            local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
            if MainUIButtons.money_window ~= nil then
                MainUIButtons.money_window:CloseWindow()
                MainUIButtons.money_window = nil
            end
            MainUIButtons.show_money_ui()
        end
    end
end

-- 同步服务器金币到本地缓存
CommonFunc.GetServerMoney = function (windows)
    local path = "/users/profile"
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    request:get(path):next(function(response)
        if (response.status == 200) then
            -- 指定年级学期的所有课程包信息,用于解锁课程包
            local data = response.data.data
            local user_wallets = data.user_wallets
            if not (user_wallets and next(user_wallets)) then
                user_wallets = {{amount=0,currency_id=1,},{amount=0,currency_id=2,},}
            end

            local info = System.User.info
            info.user_wallets = user_wallets
            Mod.CodePku.Store:Set('user/info', info)

            if windows then
                for _,window in pairs(windows) do
                    window:Refresh(0)
                end
            end

            local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
            if MainUIButtons.money_window ~= nil then
                MainUIButtons.money_window:CloseWindow()
                MainUIButtons.money_window = nil
            end
            MainUIButtons.show_money_ui()
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

CommonFunc.OpenUrl = function (url, withToken, screenOrientation)                
    local function stringifyPrimitive(v)
        return tostring(v)
    end
      
    local function urlencode(str)
        if str then
            str = string.gsub(str, '\n', '\r\n')
            str = string.gsub(str, '([^%w-_.~])', function(c)
            return string.format('%%%02X', byte(c))
            end)
        end
        return str
    end
      
    local function stringify(params, sep, eq)
        if not sep then sep = '&' end
        if not eq then eq = '=' end
        if type(params) == "table" then
            local fields = {}
            for key,value in pairs(params) do
                local keyString = urlencode(stringifyPrimitive(key)) .. eq
                if type(value) == "table" then
                    for _, v in ipairs(value) do
                    table.insert(fields, keyString .. urlencode(stringifyPrimitive(v)))
                    end
                else
                    table.insert(fields, keyString .. urlencode(stringifyPrimitive(value)))
                end
            end
            return table.concat(fields, sep)
        end
        return ''
    end
    
    local function tableLength(t)
        local leng=0
        for k, v in pairs(t) do
          leng=leng+1
        end
        return leng;
    end

    NPL.load("(gl)script/ide/socket/url.lua");    
    
    local UrlLib = commonlib.gettable("commonlib.socket.url");    
    local parsedUrl = UrlLib.parse(url);    

    local queryParams = {};
    if withToken then
        local token = Mod.CodePku.Store:Get("user/token");
        queryParams.token = token;
    end
    
    local currentOs = System.os.GetPlatform();    
    if currentOs == 'android' and screenOrientation == 'portrait' then         
        queryParams.screenOrientation = 'portrait';        
    end

    if tableLength(queryParams) > 0 then
        if parsedUrl.query then
            parsedUrl.query = parsedUrl.query .. "&" .. stringify(queryParams)
        else
            parsedUrl.query = stringify(queryParams)
        end
    end

    url = UrlLib.build(parsedUrl)
    if currentOs == 'android' then
        Map3DSystem.App.Commands.Call("File.WebBrowser", url)        
    else
        GameLogic.RunCommand(string.format("/open %s", url))
    end
end

CommonFunc.ConnectStandToEnd = function ()
    local Config = NPL.load("(gl)Mod/CodePku/online/client/Config.lua");
    if Config.defaultEnv == "RELEASE" then
        GameLogic.RunCommand("/connectCodePku -serverIp=106.53.135.151 -serverPort=9900 25161")
    else
        GameLogic.RunCommand("/connectCodePku 25161")
    end
end