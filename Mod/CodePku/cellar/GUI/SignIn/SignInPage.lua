
local SignInPage = commonlib.gettable("Mod.CodePku.GUI.SignInPage")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

SignInPage.ui = nil
SignInPage.supplement_card = nil
SignInPage.signin_data = {}
SignInPage.signin_total_day = nil
SignInPage.year = nil
SignInPage.month = nil
SignInPage.day = nil
SignInPage.full_attendance = nil
SignInPage.gain_total_award = nil
SignInPage.total_award = {}

SignInPage.award_item = {
    [1] = {prop_id = 1, name = '玩学币', img = '369 179 61 60'},
    [2] = {prop_id = 2, name = '玩学券', img = '369 178 61 60'},
    [11001] = {prop_id = 11001, name = '补签卡', img = '369 178 61 60'},
}

function SignInPage:initData()
    SignInPage.signin_data = {}
    SignInPage.total_award = {}
    for i = 1,28 do
        table.insert(SignInPage.signin_data, {date = i, state = 0, prop_id = 1, prop_num = 0})
    end
    table.insert(SignInPage.total_award,{prop_id = 1, prop_num = 0})
end

function SignInPage:GetSupplementCard()

    local response = request:get('/user-props/re-sign-card',nil,{sync = true})
    if response.data.code == 200 then
        return response.data.data.re_sign_card_num or 0
    end
end

function SignInPage:GetSigninData(month)
    local response = request:get('/sign-in?month='..month,nil,{sync = true})
    self.initData()
    if response.data.code == 200 then
        local data = response.data.data.lists
        SignInPage.signin_total_day = response.data.data.sign_count or 0
        SignInPage.full_attendance = response.data.data.full_attendance or false
        SignInPage.gain_total_award = response.data.data.full_attendance_award or false
        for i = 1, #data do
            local day = tonumber(string.sub(data[i].sign_date, 9))
            SignInPage.signin_data[day].state = 1
        end
    end
end

function SignInPage:SetSignin()
    local response = request:post('/sign-in', {},{sync = true})
    if response.data.code == 400 then
        return response.data.message
    elseif response.data.code == 200 then
        return L"签到成功"
    end
end

function SignInPage:retroactive(date)
    local response = request:post('/sign-in/retroactive', {sign_date = date},{sync = true})
    if response.data.code == 200 then
        return L"补签成功"
    else
        return response.data.message
    end
end

function SignInPage:SetAward()
    local response = request:get('/user-props/full-attendance-award', nil,{sync = true})
    if response.data.code == 200 then
        return L"领取成功"
    else
        return response.data.message
    end
end

function SignInPage:GetDayAward(month)
    local response = request:get('/sign-in/daily-rewards?month='..month, nil, {sync = true})
    if response.data.code == 200 then
        local data = response.data.data.daily_awards
        for i = 1, #data do
            local day = tonumber(string.sub(data[i].sign_date, 9))
            if day <=28 then
                SignInPage.signin_data[day].prop_id = tonumber(data[i].prop_id)
                SignInPage.signin_data[day].prop_num = data[i].prop_num
            end
        end
        if #response.data.data.full_attendance_awards >=1 then
            SignInPage.total_award[1].prop_id = tonumber(response.data.data.full_attendance_awards[1].prop_id)
            SignInPage.total_award[1].prop_num = response.data.data.full_attendance_awards[1].prop_num
        end
    end
end

function SignInPage:ShowPage(bShow)
    
    if SignInPage.ui ~= nil then
        SignInPage.ui:CloseWindow()
    end
    SignInPage.bForceHide = bShow == false;
    SignInPage.year = os.date("%Y")
    SignInPage.month = os.date("%m")
    SignInPage.day = os.date("%d")
    SignInPage.supplement_card = SignInPage:GetSupplementCard()
    SignInPage:GetSigninData(SignInPage.year.."-"..SignInPage.month)
    SignInPage:GetDayAward(SignInPage.year.."-"..SignInPage.month)
    SignInPage.ui = AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/SignIn/SignInPage.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21})
    
end