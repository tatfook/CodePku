local GenAndName = commonlib.gettable("Mod.CodePku.GenAndName")
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

function GenAndName.CheckNickName()
    if System.User and System.User.nickName and #System.User.nickName > 0 then
        return true
    end

    return false
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

function GenAndName:ShowPage()
    -- NPL.load("(gl)Mod/CodePku/cellar/GUI/GenAndName.lua")
    -- local GenAndName = commonlib.gettable("Mod.CodePku.GenAndName")

    params = {
        url = "Mod/CodePku/cellar/GUI/GenAndName.html", 
        name = "GenAndName", 
        isShowTitleBar = false,
        DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        zorder = 0,
        bShow = bShow,
        directPosition = true,
            align = "_fi",
            x = 0,
            y = 0,
            width = 0,
            height = 0,
        cancelShowAnimation = true,
    }

    System.App.Commands.Call("File.MCMLWindowFrame", params);
end