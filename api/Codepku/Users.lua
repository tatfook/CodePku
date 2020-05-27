--[[
Title: Keepwork Users API
Author(s):  big
Date:  2019.11.8
Place: Foshan
use the lib:
------------------------------------------------------------
local KeepworkUsersApi = NPL.load("(gl)Mod/WorldShare/api/Keepwork/Users.lua")
------------------------------------------------------------
]]

local CodePkuBaseApi = NPL.load('./BaseApi.lua')

local CodePkuUsersApi = NPL.export()

-- url: /users/login
-- method: POST
-- params:
--[[
    account	string 必须 用户名	
    password string 必须 密码
]]
-- return: object
function CodePkuUsersApi:Login(mobile, verify_code, success, error)
    if type(mobile) ~= "string" or type(verify_code) ~= "string" then
        return false
    end

    local params = {
        mobile = mobile,
        verify_code = verify_code
    }

    CodePkuBaseApi:Post("/users/login", params, nil, success, error, { 503, 400 })
end

-- url: /users/profile
-- method: POST
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:Profile(token, success, error)
    if type(token) ~= "string" and #token == 0 then
        return false
    end

    local headers = { Authorization = format("Bearer %s", token) }

    CodePkuBaseApi:Get("/users/profile", nil, headers, success, error, 401)
end

-- url: /users/register
-- method: POST
-- params:
--[[
    token string 必须 token
    username string 必须 username,
    password string 必须 password,
    key string 必须 captchaKey,
    captcha string 必须 captcha,
    channel = 3
]]
-- return: object
function CodePkuUsersApi:Register(params, success, error, noTryStatus)
    CodePkuBaseApi:Post('/users/register', params, { notTokenRequest = true }, success, error, noTryStatus)
end

-- url: /users/cellphone_captcha
-- method: POST
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:RealName(params, success, error, noTryStatus)
    CodePkuBaseApi:Post('/users/cellphone_captcha', params, nil, success, error, noTryStatus)
end

-- url: /users/svg_captcha?png=true
-- method: GET
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:FetchCaptcha(success, error)
    CodePkuBaseApi:Get('/users/svg_captcha?png=true', nil, { notTokenRequest = true }, success, error)
end


-- url: /users/cellphone_captcha
-- method: GET
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:CellphoneCaptcha(phone, success, error)
    if type(phone) ~= 'string' then
        return false
    end

    local url = '/users/cellphone_captcha?cellphone=' .. phone

    CodePkuBaseApi:Get(url, nil, { notTokenRequest = true }, success, error)
end

-- url: /users/cellphone_captcha
-- method: POST
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:BindPhone(params, success, error)
    CodePkuBaseApi:Post('/users/cellphone_captcha', params , { notTokenRequest = false }, success, error)
end

-- url: /users/email_captcha
-- method: GET
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:EmailCaptcha(email, success, error)
    local url = '/users/email_captcha?email=' .. email

    CodePkuBaseApi:Get(url, nil, { notTokenRequest = true }, success, error)
end

-- url: /users/email_captcha
-- method: POST
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:BindEmail(params, success, error)
    CodePkuBaseApi:Post('/users/email_captcha', params, { notTokenRequest = false }, success, error)
end

-- url: /users/reset_password
-- method: POST
-- params:
--[[
    token string 必须 token
]]
-- return: object
function CodePkuUsersApi:ResetPassword(params, success, error, noTryStatus)
    CodePkuBaseApi:Post('/users/reset_password', params, { notTokenRequest = true }, success, error, noTryStatus)
end

function CodePkuUsersApi:getMobileCode(mobile, success, error)    
    LOG.std(nil, "info", "codepku", type(mobile));
    if type(mobile) ~= "string" then        
        return false
    end
    local params = {
        mobile = mobile
    }
    CodePkuBaseApi:Post('/users/mobile-code', params, { notTokenRequest = true }, success, error, {503, 400, 422, 500})
end

function CodePkuUsersApi:getCourseEntry(success, error)
    LOG.std(nil, "info", "codepku", "user api getCourseEntry")

    -- CodePkuBaseApi:Get('worlds/coruse-entry', nil, )
end