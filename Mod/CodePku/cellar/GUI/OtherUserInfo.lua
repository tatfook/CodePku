local OtherUserInfoPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.OtherUserInfoPage")
local OtherUserInfo = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.OtherUserInfo")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local page;


function OtherUserInfoPage.OnInit()
	OtherUserInfoPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function OtherUserInfoPage.OneTimeInit()
	if(OtherUserInfoPage.is_inited) then
		return;
	end
	OtherUserInfoPage.is_inited = true;
end

-- clicked a block
function OtherUserInfoPage.OnClickBlock(block_id)
end

-- 获取用户信息
function OtherUserInfoPage.GetUserInfo(id)
    response = request:get('/users/profile/' .. id,nil,{sync = true})
    if response.status == 200 then
        data = response.data.data
        OtherUserInfo.name = data.nickname or string.sub(data.mobile,1,7)
        OtherUserInfo.id = data.id
        OtherUserInfo.gender = data.gender
        return true
    else
        return false
    end
end

function OtherUserInfoPage:ShowPage(id,bShow)
    OtherUserInfoPage.bForceHide = bShow == false;
    res = OtherUserInfoPage.GetUserInfo(id)
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
   
    if res then
        local params = {
            url = "Mod/CodePku/cellar/GUI/OtherUserInfo.html", 
            alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
        }
        AdaptWindow:QuickWindow(params)
    else
        GameLogic.AddBBS("CodeGlobals", L"用户数据错误", 3000, "#ff0000");
    end

end