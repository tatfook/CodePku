--[[
	local EditNamePage = NPL.load("(gl)Mod/CodePku/cellar/GUI/Profile/EditName.lua");
	EditNamePage:ShowPage();
--]]

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local UserInfoPage = NPL.load("(gl)Mod/CodePku/cellar/GUI/UserInfo.lua");

local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")
local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")

-- 导Editbox是为了改EmptyText的文本颜色，后面帕拉卡如果添加了对应的属性可以改掉这里的代码
NPL.load("(gl)script/ide/System/Windows/Controls/EditBox.lua");
local EditBox = commonlib.gettable("System.Windows.Controls.EditBox");

local EditNamePage = NPL.export();


-- 获取图片,tpye  1 通用；2 ESC专用
function EditNamePage:GetIconPath(type, index)
	if type == 1 then
        return common1ImageData:GetIconUrl(index)
    elseif type == 2 then
        return escFrameImageData:GetIconUrl(index)
    end
end

-- 关闭页面
function EditNamePage:OnCancelBtnClicked()
	-- 关闭遮罩window
	if EditNamePage.BG then
		EditNamePage.BG:CloseWindow()
		EditNamePage.BG = nil
	end
	if EditNamePage.ui then
		EditNamePage.ui:CloseWindow()
		EditNamePage.ui = nil
	end
	-- 关闭页面之后要还原为默认的，避免影响其它页面
	EditBox:Property({"EmptyTextColor", "#888888", auto=true})
end

-- 两个window是为了适配IOS虚拟键盘无法失去焦点,同时关闭页面需要特殊处理，两个window都要关掉
function EditNamePage:ShowPage()
	-- 打开之前先设置input标签的EmptyText文本颜色
	EditBox:Property({"EmptyTextColor", "#a35229", auto=true})
	if not EditNamePage.BG then
		local BGparams = {
		url="Mod/CodePku/cellar/GUI/Profile/EditNameEmptyPage.html",
		alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31,
		}
		EditNamePage.BG = AdaptWindow:QuickWindow(BGparams)
	end
	if not EditNamePage.ui then
		local params = {
			url = "Mod/CodePku/cellar/GUI/Profile/EditName.html",
			alignment="_lt", left = 600, top = 334, width = 723 , height = 412, zorder = 32
		}
		EditNamePage.ui = AdaptWindow:QuickWindow(params)
	end
end

-- 修改昵称
function EditNamePage:ChangeNickname(new_nickname)
	-- 校验昵称
	-- 长度超过7
	local new_nickname = tostring(new_nickname)
	
	if (commonlib.utf8.len(new_nickname) > 7) then
		EditNamePage.ErrorContent = "名字长度不能大于7"
		EditNamePage.ui:Refresh(0)
		return
	end
	-- 没填昵称
	if (commonlib.utf8.len(new_nickname) == 0) then
		EditNamePage.ErrorContent = "新昵称不能为空"
		EditNamePage.ui:Refresh(0)
		return
	end
	-- 与自己的昵称一致
	if new_nickname == UserInfoPage.name then
		EditNamePage.ErrorContent = "与旧昵称一致，无法设置"
		EditNamePage.ui:Refresh(0)
		return
	end

	local params = {
		nickname = new_nickname,
		gender = UserInfoPage.gender
	}
	if EditNamePage.CallingServer then
		return
	end
	-- 防止快速点击提交
	EditNamePage.CallingServer = true
	request:put('/users/profile',params):next(function(response)
		if response.status == 200 then
			commonlib.setfield("System.User.username", new_nickname)
			commonlib.setfield("System.User.nickName", new_nickname)
			Mod.CodePku.Store:Set("user/random_name", new_nickname)
			UserInfoPage.name = new_nickname
			GameLogic.AddBBS("CodeGlobals", L"设置新昵称成功", 3000, "#00FF00");
			-- local msg = {
			-- 	action = "UpdateNickName",
			-- 	nickname = UserInfoPage.name,
			-- }
			-- GameLogic.GetFilters():apply_filters("ggs", msg);
			EditNamePage.CallingServer = false
			EditNamePage:OnCancelBtnClicked()
			UserInfoPage.ShowSettingPopupUI:Refresh(0)
			UserInfoPage.MainUI:Refresh(0)
		end
	end):catch(function(e)
		if e.data.message then
			EditNamePage.ErrorContent = e.data.message
		else
			EditNamePage.ErrorContent = "失败了哟"
		end
		EditNamePage.CallingServer = false
		EditNamePage.ui:Refresh(0)
	end);
end