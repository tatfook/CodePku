
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
SignInPage.gain_total_award = nil

function SignInPage:initData()
    SignInPage.signin_data = {}
    for i = 1,28 do
        table.insert(SignInPage.signin_data, {date = i, state = 0, index = i})
    end
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
    elseif response.data.code == 200 and #response.data.data == 1 then
        return L"签到成功"
    end
end

function SignInPage:retroactive(date)
    local response = request:post('/sign-in/retroactive', {sign_date = date},{sync = true})
    return response.data.message
end

function SignInPage:GetAward()
    local response = request:get('/user-props/full-attendance-award', nil,{sync = true})
    return response.data.message
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
    SignInPage.ui = AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/SignIn/SignInPage.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21})
    
end