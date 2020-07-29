local GenAndName = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.GenAndName")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local page;

function GenAndName.OnInit()
	GenAndName.OneTimeInit();
	page = document:GetPageCtrl();
end

function GenAndName.OneTimeInit()
	if(GenAndName.is_inited) then
		return;
	end
	GenAndName.is_inited = true;
end

-- clicked a block
function GenAndName.OnClickBlock(block_id)

end

function GenAndName:getRequest(gender)
    response = request:get("/users/random-nickname?type=" .. gender,nil,{sync = true})
    echo(response)
    if response.status == 200 then
        data = response.data.data
        return data.name
    else
        return false
    end
end

function GenAndName:CreateRole(name,gen)
    data = {        
        nickname = name,        
        gender=gen
    }
    response =  request:put('/users/profile' ,data,{sync = true});


    if response.status == 200 then
        return true
    else
        return false
    end
end

function GenAndName:ShowPage(bShow)
    -- NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    -- local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    GenAndName.bForceHide = bShow == false;
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/GenAndName.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20})
end