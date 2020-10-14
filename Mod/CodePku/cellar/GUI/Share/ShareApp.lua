--[[
Title: ShareApp
Author: loujiayu
Date: 2020/10/10
Desc:分享内容至手机其它app，目前限制为只分享图片，本质是使用CodePkuCommon/util/Share.lua里的Share.fire("type",{})
Example:
-----------------------------------------------
local ShareApp = NPL.load("(gl)Mod/CodePku/cellar/GUI/Share/ShareApp.lua");
ShareApp:fire(id, page)         不需要弹窗时使用该函数
ShareApp:ShowPage(id, page)     需要弹窗时使用该函数,会根据设备和场景判断是否有弹窗
@params: page 选传参数，可以不传，当需要当前页面刷新时传入当前页page
id 后台会根据id返回图片url
id=1    主界面
id=2    课程结算
id=3    彩蛋
id=4    游戏
id=11   单词爱跑酷
id=12   华夏游学记
id=111  单词爱跑酷通用
id=112  单词爱跑酷专属1
id=113  单词爱跑酷专属2
id=114  单词爱跑酷专属3
id=121  华夏游学记通用
id=122  华夏游学记专属1
id=123  华夏游学记专属2
id=124  华夏游学记专属3
-----------------------------------------------
]]


local ShareApp = NPL.export();
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local Share = NPL.load("(gl)Mod/CodePkuCommon/util/Share.lua")

ShareApp.icons_path = "codepku/image/textures/share_app/shareapp.png"    -- 雪碧图
ShareApp.pcpopup_path = "codepku/image/textures/share_app/pcpopup.png"    -- PC端展示弹窗
ShareApp.pccancel_path = "codepku/image/textures/share_app/pccancel.png"    -- PC端取消按钮

ShareApp.icons = {
    [1] = {url = ShareApp.icons_path, left=107, top=110, width=101, height=102, desc = '红叉'},
    [2] = {url = ShareApp.icons_path, left=365, top=66, width=395, height=193, desc = '分享按钮'},
    [3] = {url = ShareApp.icons_path, left=101, top=365, width=1423, height=852, desc = '背景'},
}

-- 获取对应图标
function ShareApp.GetIconPathStr(id)
    local path=""
    id = tonumber(id)
    path = path .. ShareApp.icons[id].url
    if ShareApp.icons[id].left then
      path = path..'#'
      path = path..tostring(ShareApp.icons[id].left)
      path = path..' '..tostring(ShareApp.icons[id].top)
      path = path..' '..tostring(ShareApp.icons[id].width)
      path = path..' '..tostring(ShareApp.icons[id].height)
    end
    LOG.std(nil, "ShareApp", "GetIconPathStr", "path = %s", path)
    return path
end

-- 获取海报
function ShareApp:GetPoster(id, page)
    ShareApp.poster_id = id
    ShareApp.bShare = true
    local path = string.format("/posters/show?type=%d", id)
    request:get(path):next(function(response)
        -- 拿到返回值，根据返回值拼接share参数
        local data = response.data.data
        ShareApp.bShare = false
        ShareApp.poster_url = data.img_url
        if page then
            page:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end);

end

-- 分享主逻辑
function ShareApp:ShareLogic()
    ShareApp.bShare = true
    Share:fire("image", {
        image = ShareApp.poster_url,
        title = "分享海报"
    }, {
        onStart = function(e)
            -- 开始分享
            ShareApp.bShare = false
        end,
        onResult = function(e)
            -- 分享结果
            ShareApp.bShare = false
            GameLogic.AddBBS("CodeGlobals", L"分享成功", 3000, "#00FF00");
        end,
        onError = function(e)
            -- 分享失败
            GameLogic.AddBBS("CodeGlobals", L"分享失败", 3000, "#FF0000");
            ShareApp.bShare = false
        end,
        onCancel = function(e)
            -- 取消分享
            GameLogic.AddBBS("CodeGlobals", L"取消分享", 3000, "#FF0000");
            ShareApp.bShare = false
        end
    })
end

-- 分享
function ShareApp:fire(id, page)
    -- 防止开启多个分享界面
    if ShareApp.bShare then
        return
    end
    -- 避免重复分享或者不同的分享页分享了同一个图片，这里需要单独处理，看传入的id跟上一次的id是否相同，不同就重新获取图片
    if ShareApp.poster_id == nil or ShareApp.poster_id ~= id then
        ShareApp.poster_id = id
        ShareApp.bShare = true
        local path = string.format("/posters/show?type=%d", id)
        request:get(path):next(function(response)
            -- 拿到返回值，根据返回值拼接share参数
            local data = response.data.data
            ShareApp.poster_url = data.img_url
            -- 拿到图片开始分享
            ShareApp:ShareLogic()
            if page then
                page:Refresh(0)
            end
        end):catch(function(e)
            GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
        end);
    elseif ShareApp.poster_id == id then
        -- 无弹窗分享时需要先获取图片资源
        if not ShareApp.poster_url then
            ShareApp:GetPoster(id, page)
        end
        ShareApp:ShareLogic()
    end
end

-- 通用分享函数。手机端主界面分享会有弹窗，其它地方调用直接走分享逻辑。PC端调用展示PC端专属分享页面。
function ShareApp:ShowPage(id, page)
    if id and page then
        ShareApp:GetPoster(id, page)
    end
    ShareApp.poster_id = id
    -- 判断登陆设备，pc端和手机端展示不同的页面
    if System.os.IsMobilePlatform() then
        -- 手机端展示页面
        if id == 1 then
            -- 主界面分享，有弹窗
            local params = {
                url = "Mod/CodePku/cellar/GUI/Share/ShareApp.html",
                alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,
            }
            if self.ui then
                self.ui:CloseWindow()
                self.ui = nil
            end
            self.ui = AdaptWindow:QuickWindow(params)
        else
            -- 其它界面分享，无弹窗
            ShareApp:fire(id, page)
        end

    else
        -- pc端展示页面
        local params = {
            url = "Mod/CodePku/cellar/GUI/Share/SharePC.html",
            alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30,
        }
        if self.ui then
            self.ui:CloseWindow()
            self.ui = nil
        end
        self.ui = AdaptWindow:QuickWindow(params)
    end
end