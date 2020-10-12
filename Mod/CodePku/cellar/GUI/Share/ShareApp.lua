--[[
Title: ShareApp
Author: loujiayu
Date: 2020/10/10
Desc:分享内容至手机其它app，本质是使用CodePkuCommon/util/Share.lua里的Share.fire("type",{})
Example:
-----------------------------------------------
local ShareApp = NPL.load("(gl)Mod/CodePku/cellar/GUI/Share/ShareApp.lua");
ShareApp.fire(id)
@params: string|table id 类型，后台会根据类型返回图片url
-----------------------------------------------
]]


local ShareApp = NPL.export();
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local Share = NPL.load("(gl)Mod/CodePkuCommon/util/Share.lua")


--[[
Share.fire("type",{});
share("image", {
   image = "https://www.codepku.com/image.jpg",
   title = "编玩边学"
}, {
   onStart = function(e)
       -- 开始分享
   end,
   onResult = function(e)
       -- 分享结果
   end,
   onError = function(e)
       -- 分享失败
   end,
   onCancel = function(e)
       -- 取消分享
   end
});
--]]


function ShareApp:fire(id)
    if ShareApp.bShare then
        return
    end
    ShareApp.bShare = true
    local params = {
        id = id,
    }
    request:get('/',params):next(function(response)
        -- 拿到返回值，根据返回值拼接share参数
        local data = response.data.data

        Share.fire("type",{})
        -- 本次分享结束后才允许再次点击分享
        ShareApp.bShare = false
      end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
      end);
end


function ShareApp:ShowPage()
    local params = {
        url = "Mod/CodePku/cellar/GUI/Share/ShareApp.html",
        alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,
    }
    AdaptWindow:QuickWindow(params)
end