--[[
Title: Mail Page
Author(s): NieXX
Date: 2020/9/11
Desc:
use the lib:
functions:
    Mail:ShowPage()
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Mail/Mail.lua")
local Mail = commonlib.gettable("Mod.CodePku.celler.Mail")
------------------------------------------------------------
]]
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local WebSocketClient = NPL.load("(gl)Mod/CodePku/cellar/Heartbeat/WebSocketClient.lua");
local CodepkuConfig = NPL.load("(gl)Mod/CodePku/config/Config.lua")
local mailImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mailImageData.lua")
local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua");
NPL.load("(gl)script/ide/DateTime.lua");
Mail = commonlib.gettable("Mod.CodePku.celler.Mail");

Mail.content = {}
Mail.todoLen = 0;
Mail.receiveFlag = 0;
Mail.tips = "当前有"..Mail.todoLen.."封待处理的邮件"
Mail.ShowMailPage = false
Mail.Status = {
    [0] = {style = ""},--string.format("%s:tcp", self:GetAddressID())
    [1] = {title = "已读",style = string.format("position:relative;width: 82;height:53;left:10;top:-130;background:url(%s)", mailImageData:GetIconUrl("mail_tab_read.png"))},
    [2] = {title = "新",style = string.format("position:relative;width: 82;height:53;left:15;top:-125;background:url(%s)", mailImageData:GetIconUrl("mail_tab_new.png"))},
    [3] = {title = "道具",style = string.format("position:relative;width: 50;height:46;left:200;top:-95;background:url(%s)", mailImageData:GetIconUrl("mail_icon_gift.png"))},
}
Mail.reward_json = {}
Mail.rewardList = {}
-- status: 0-未读 1-已读
-- annex_status 0-未领取，1-已领取，2-无奖励
Mail.mailList = {}


function Mail.StaticInit()
    LOG.std("", "info", "Mail", "StaticInit");
    Mail:GetMailList();
	-- GameLogic:Connect("WorldLoaded", Mail, Mail.OnWorldLoaded, "UniqueConnection");

    -- GameLogic.GetFilters():remove_filter("OnCodepkuLogin", Mail.OnCodepkuLogin_Callback);
    -- GameLogic.GetFilters():remove_filter("OnCodepkuLogout", Mail.OnCodepkuLogout_Callback);
    -- GameLogic.GetFilters():add_filter(
    --     "Mail", 
    --     function (data)
    --         -- if(Mail.worldId_pending)then
    --             Mail:Connect("/worlds/keepwork/25161",nil,function()
    --                 -- Mail.JoinWorld(Mail.worldId_pending);
    --                 echo("connnect--------callback")
    --             end);
    --         -- end  
    --     end
    -- );
    Mail:Connect(nil,nil,function()
        echo("connnect--------callback")
    end);
end

-- 获取邮件列表
function Mail:GetMailList()
    request:get('/mails',{},nil):next(function(response)
        Mail.mailList = (response and response.data and response.data.data) or {}
        Mail:GetTodoCount()
        echo("=======Mail:GetMailList=======")
        for i,v in pairs(Mail.mailList) do
            echo(i)
        end
    end):catch(function(e)
        GameLogic.AddBBS(nil, L"邮件获取失败，请重试", 3000, "255 0 0", 21);
    end);
end

function Mail:Connect(url,options,onopen_callback)    
    if(not System.User.codepkuToken)then
        return
    end

    url = url or Mail.GetUrl();
    WebSocketClient.client = commonlib.getfield("System.CodePku.WebSocketClient")
    if(not WebSocketClient.client)then
        WebSocketClient.client = WebSocketClient:new():Init(url, System.User.codepkuToken);
        commonlib.setfield("System.CodePku.WebSocketClient", WebSocketClient.client)
    end
    WebSocketClient.client:AddEventListener("OnOpen",Mail.OnOpen,Mail);
    WebSocketClient.client:AddEventListener("OnMsg",Mail.OnMsg,Mail);
    WebSocketClient.client:AddEventListener("OnClose",Mail.OnClose,Mail);
    -- options = options or {};
    -- Mail.onopen_callback = onopen_callback;
    -- if(WebSocketClient.client.state == "OPEN")then
    --     Mail.OnOpen();
    --     return
    -- end
    -- WebSocketClient.client:Connect(url);
end

function Mail.GetUrl()
    local coursewareId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
    return CodepkuConfig.defaultSocketServer .. string.format("?token=%s&world_id=%s", System.User.codepkuToken, tostring(coursewareId));
end

function Mail.OnOpen(self)
	LOG.std("", "info", "Mail", "OnOpen");
    if(Mail.onopen_callback)then
        Mail.onopen_callback();
    end
end

function Mail.OnClose(self)
	LOG.std("", "info", "Mail", "OnClose");
end

function Mail.OnMsg(self, msg)
    if(not msg or not msg.data)then
        return
    end
    echo("Mail输出msg=========")  
    echo(msg)
    msg = msg.data;
    if msg["action"] == "new_mail" then
        -- 更新本地缓存数据
        local list = Mail.mailList
        local data = msg.data
        table.insert(Mail.mailList, 1, data);

        -- 更新 Mail.todoLen
        Mail.todoLen = Mail.todoLen + 1
        Mail.tips = "当前有"..Mail.todoLen.."封待处理的邮件"
        Mail:RefreshCategoryPage()
        Mail:RefreshPage()
        -- WebSocketClient.client:SendMsg({ msg ="确认收到邮件", });
    end
end

-- Get mail status
-- @param 
-- @return background image of the state
function Mail:GetStatus(status,time)
    if status == 0 then
        return self.Status[2].style
    elseif status == 1 then
        return self.Status[1].style
    else
        return self.Status[0].style
    end
end


-- 给邮件列表排序 新邮件-已读有附件-已读无附件
-- status：0-未读，1-已读
-- annex_status 0 未领取，1已领取，2无奖励
function Mail:TableSort(t)
    if #t > 1 then
        local sortFun = function(a, b)
            local r = false
            local timestamp = Mail:TranslateTime(a.send_time)
            local timestamp2 = Mail:TranslateTime(b.send_time)
            if a.status == b.status then
                if a.status == 0 then -- 新邮件，仅按时间排序
                    if timestamp < timestamp2 then
                        r = false
                    elseif timestamp == timestamp2 then
                        r = false
                    else
                        r = true
                    end
                else -- 已读邮件 先按有无附件，再按时间排序
                    if a.annex_status == b.annex_status and a.annex_status == 0 then
                    -- if a.annex_status == b.annex_status then
                        if timestamp < timestamp2 then
                            r = false
                        elseif timestamp == timestamp2 then
                            r = false
                        else
                            r = true
                        end
                    else
                        if (a.annex_status ~= 0 and b.annex_status ~= 0) then
                            if timestamp < timestamp2 then
                                r = false
                            elseif timestamp == timestamp2 then
                                r = false
                            else
                                r = true
                            end
                        else
                            r = a.annex_status < b.annex_status
                        end
                    end
                end
            else
                r = a.status < b.status
            end
            return r
        end
        table.sort(t, sortFun)
    end
    -- t = Mail:TableSortByTime(t)
    -- t = Mail:TableSortByAnnexStatus(t)
    -- t = Mail:TableSortByStatus(t)
    return t
end

function Mail:TableSortByTime(t)
    if #t > 1 then
        table.sort(t, function (a, b)
            local timestamp = Mail:TranslateTime(a.send_time)
            local timestamp2 = Mail:TranslateTime(b.send_time)
            return timestamp > timestamp2
        end)
    end
    return t
end

function Mail:TableSortByStatus(t)
    if #t > 1 then
        table.sort(t, function (a, b)
            return a.status < b.status
        end) 
    end
    return t
end

function Mail:TableSortByAnnexStatus(t)
    if #t > 1 then
        table.sort(t, function (a, b)
            return a.annex_status < b.annex_status
        end) 
    end
    return t
end

function Mail:TranslateTime(time)
    local _, _, y, m, d, _hour, _min, _sec = string.find(time, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)");
    return os.time({year=y, month = m, day = d, hour = _hour, min = _min, sec = _sec})
end

function Mail:HandleTitle(title)
    if commonlib.utf8.len(title) > 6 then 
        return commonlib.utf8.sub(title,1,6).."..."
    else
        return title  
    end
end

function Mail:GetTodoCount()
    local list = Mail.mailList;
    local count = 0;
    for k, v in ipairs(list) do
        if v.status == 0 or v.annex_status == 0 then
            count = count + 1
        end
    end
    Mail.todoLen = count
    Mail.tips = "当前有"..Mail.todoLen.."封待处理的邮件"
end

function Mail:RefreshPage()
    if Mail.mailPage and Mail.ShowMailPage then
        Mail.mailPage:Refresh()
    end
end


function Mail:ShowPage()
    local params = {
        url = "Mod/CodePku/cellar/Mail/Mail.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080, zorder = 30,
        click_through = false,
    }
    Mail.ShowMailPage = true
    Mail.mailPage = AdaptWindow:QuickWindow(params)
end

-- 确认一键删除页面
function Mail:ConfirmDeleteAll()
    local params = {
        url = "Mod/CodePku/cellar/Mail/Popup/Confirm.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080, zorder = 31,
            click_through = false,
    }
    Mail.ConfirmDeleteAllPage = AdaptWindow:QuickWindow(params)
end

-- 奖励
function Mail:ReceivedAward()
    local params = {
        url = "Mod/CodePku/cellar/Mail/Popup/Reward.html",
        alignment="_lt", left = 0, top = 0, width = 1920, height = 1080, zorder = 31,
            click_through = false,
    }
    Mail.ReceivedAwardPage = AdaptWindow:QuickWindow(params)
end

function Mail:HandleStatus(id)
    local list = Mail.mailList;
    local value = {};
    for k, v in ipairs(list) do
        if v.user_mail_id == id then
            v.status = 1
            value = v;
        end
    end

    Mail.mailList = list;
    Mail:GetTodoCount()
    Mail:RefreshCategoryPage();

    request:post('/mails/read/'..id,{},nil):next(function(response)
    end):catch(function(e)
    end);
    return value
end

-- 删除单条
function Mail:Delete(id)
    local list = Mail.mailList;
    for k, v in ipairs(list) do
        if v.user_mail_id == id then
            table.remove(list, k)
            echo(k)
        end
    end
    Mail.mailList = list;
    Mail:GetTodoCount()
    Mail:RefreshCategoryPage()
    Mail:RefreshPage()
    request:delete('/mails/delete/'..id,{},nil):next(function(response)
    end):catch(function(e)
    end);
end

-- 一键删除
function Mail:DeleteAll()
    echo("一键删除")
    local list = Mail.mailList;
    for i = #list, 1, -1 do
        if list[i]["status"] == 1 then --已读
            if list[i]["annex_status"] == 1 or list[i]["annex_status"] == 2 then --已领取/无奖励
                table.remove(list, i)
            end
        end
    end
    Mail.mailList = list;
    Mail:GetTodoCount()
    Mail:RefreshCategoryPage()
    Mail:RefreshPage()

    request:delete('/mails/delete-all',{},nil):next(function(response)
    end):catch(function(e)
    end);
end

function Mail:RefreshCategoryPage()
    if MainUIButtons.showCategoryWindow then
        MainUIButtons:show_category_top_ui()
    end
end

-- 一键领取
function Mail:ReceiveAll()
    echo("一键领取")
    local list = Mail.mailList;
    local reward = {}
    local flag
    local index
    for k, v in ipairs(list) do
        if v.annexes and v.annex_status == 0 then --如果有奖励
            flag = false
            for x, y in ipairs(v.annexes) do
                if #reward == 0 then
                    table.insert(reward, {prop_id=y.prop_id,prop_num = y.prop_num, prop_icon_url=y.prop_icon_url})
                else
                    for m, n in ipairs(reward) do
                        if n.prop_id == y.prop_id then
                            flag = true
                            index = m
                        end
                    end
                    if not flag then
                        table.insert(reward, {prop_id=y.prop_id,prop_num = y.prop_num, prop_icon_url=y.prop_icon_url})
                    else
                        reward[index].prop_num = y.prop_num + reward[index].prop_num --处理数量
                    end
                end
            end
            v.annex_status = 1
            v.status = 1
        end
        
    end

    if #reward > 0 then
        Mail.mailList = list;
        Mail.rewardList = reward;
        Mail:GetTodoCount()
        Mail:RefreshCategoryPage()
        Mail:RefreshPage();
        Mail:ReceivedAward();
        Mail:RefreshMoneyPage(reward)
    end

    request:post('/mails/receive-all',{},nil):next(function(response)
    end):catch(function(e)
    end);
end

function Mail:ClickReceive(value)
    local list = Mail.mailList;
    Mail.rewardList = value.annexes
    for k, v in ipairs(list) do
        if v.user_mail_id == value.user_mail_id then
            v.status = 1
            v.annex_status = 1
        end
    end
    Mail.mailList = list
    Mail:GetTodoCount()
    Mail:RefreshCategoryPage()
    Mail:RefreshPage();
    Mail:ReceivedAward();
    Mail:RefreshMoneyPage(value.annexes)

    request:post('/mails/receive/'..value.user_mail_id,{},nil):next(function(response)
        
    end):catch(function(e)
        
    end);
end

function Mail:GetDate(time)
    local strDate = time
    local _, _, y, m, d, _hour, _min, _sec = string.find(strDate, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)");
    local result = y.."年"..m.."月"..d.."日 ".._hour.."时".._min.."分".._sec.."秒"
    return result
end

-- 刷新右上角金币界面
function Mail:RefreshMoneyPage(reward_json)
    if reward_json then
        for k,v in pairs(reward_json) do
            Mail:RefreshMoney(v.prop_id,v.prop_num)
            if MainUIButtons.money_window ~= nil then
                MainUIButtons.money_window:CloseWindow()
                MainUIButtons.money_window = nil
                MainUIButtons.show_money_ui()
            end
        end
    end
end

-- 领取奖励后更新道具列表
function Mail:RefreshMoney(id, num)
    local id = tonumber(id)
    local num = tonumber(num)
    local info = Mod.CodePku.Store:Get('user/info')
    local wallets = info.user_wallets or {}
    local flag = false
    if #wallets == 0 then
        table.insert(wallets,{currency_id = id, amount = num})
    else
        for _, v in ipairs(wallets) do
            if v.currency_id == 1 and id == 1 then
                v.amount = v.amount + num
            elseif v.currency_id == 2 and id == 2 then
                v.amount = v.amount + num
            end
            if v.currency_id == id then -- 解决钱包中道具为0时未自增的问题
                flag = true
            end
        end
    end
    if not flag then
        table.insert(wallets,{currency_id = id, amount = num})
    end
    info.user_wallets = wallets --防止初始化钱包为nil的时候客户端不同步的bug
    Mod.CodePku.Store:Set('user/info', info)
end

function Mail:HandleContent(content)
    echo("Mail:HandleContent============")
    echo(content)
    local result = content


    return result
end