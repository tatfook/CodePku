GenAndName = commonlib.gettable("Mod.CodePku.GenAndName")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local page;

function GenAndName.OnInit()
	GenAndName.OneTimeInit();
	page = document:GetPageCtrl();
end

function GenAndName.Init()
    GenAndName.isVisitor = commonlib.getfield("System.User.isVisitor")
    GenAndName.randomName = commonlib.getfield("System.User.randomName")
    GenAndName.gen = 0
    LOG.std(nil, "GenAndName", "Init", "isVisitor = %s, randomName = %s", tostring(GenAndName.isVisitor), tostring(GenAndName.randomName))
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

function GenAndName.IsVisitor()
    --body
    if Systerm.User and System.User.isVisitor then
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

    commonlib.setfield("System.User.info.gender", gen) 
    commonlib.setfield("System.User.info.nickname", name)
    return response
end

function GenAndName:ShowPage()
    -- NPL.load("(gl)Mod/CodePku/cellar/GUI/GenAndName.lua")
    -- local GenAndName = commonlib.gettable("Mod.CodePku.GenAndName")


    -- local params = {
    --     url = "Mod/CodePku/cellar/GUI/GenAndName.html", 
    --     name = "GenAndName", 
    --     isShowTitleBar = false,
    --     DestroyOnClose = true,
    --     allowDrag = false,
    --     enable_esc_key = true,
    --     -- bShow = bShow,
    --     click_through = false, 
    --     zorder = 20,
    --     directPosition = true,
    --     alignment = "_ct",
    --     x = -1920/2,
    --     y = -1080/2,
    --     width = 1920,
    --     height = 1080,
    --     };

    local params = {
        [1] = { 
            url = "Mod/CodePku/cellar/GUI/GenAndName.html", 
            name = "GenAndName", 
            isShowTitleBar = false,
            DestroyOnClose = true,
            allowDrag = false,
            enable_esc_key = true,
            -- bShow = bShow,
            click_through = false, 
            zorder = 20,
            directPosition = true,
            alignment = "_ct",
            x = -1920/2,
            y = -1080/2,
            width = 1920,
            height = 1080,
        },
        [2] = { --  游客选择性别名称界面
            url = "Mod/CodePku/cellar/GUI/GenAndNameQuickLogin.html", 
            name = "GenAndNameQuickLogin", 
            isShowTitleBar = false,
            DestroyOnClose = true,
            allowDrag = false,
            enable_esc_key = true,
            -- bShow = bShow,
            click_through = false, 
            zorder = 20,
            directPosition = true,
            alignment = "_ct",
            x = -1920/2,
            y = -1080/2,
            width = 1920,
            height = 1080,
        }
    };
    if GenAndName.isVisitor then
        AdaptWindow:QuickWindow(params[2])
    else
        AdaptWindow:QuickWindow(params[1])
    end
end