local SystemEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SystemEntrencePage");
local SystemLevelPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SystemLevelPage");
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
local page;

function reverse(array)  --数组倒序
    local a, index, max = {}, 1, #array
    while index <= max do
        table.insert(a, array[max - index + 1])
        index = index + 1
    end
    return a
end

function slice(array, start, end_)  -- 数组切片
    local a, index, max = {}, start, #array
    if start > end_ then
        start = max - start + 1
        end_ = max - end_ + 1
        array = reverse(array)
    end
    if index > max then
        return nil
    end
    while index <= max and index <= end_ do
        table.insert(a, array[index])
        index = index + 1
    end
    return a
end
function SystemEntrencePage.OnInit()
	SystemEntrencePage.OneTimeInit();
	page = document:GetPageCtrl();
end

function SystemEntrencePage.OneTimeInit()
	if(SystemEntrencePage.is_inited) then
		return;
	end
	SystemEntrencePage.is_inited = true;
end

-- clicked a block
function SystemEntrencePage.OnClickBlock(block_id)
end

function SystemLevelPage.GetLevels(grade_id, semester_id, subject_id)
    response = request:get(string.format('/coursewares/entrance/system?grade=%d&semester=%d&subject=%d&', grade_id, semester_id, subject_id),nil,{sync = true})
    data = response.data.data
    page = SystemLevelPage.page or 1
    list = {}
    a = 0
    for i, d in ipairs(data) do
        courses = d.course_wares
        for ii, c in ipairs(courses) do
            
            l = {}
            l['cover'] = d.cover
            l['course'] = c
            l['index'] = a % 10
            a = a + 1
            table.insert(list, l)
        end
    end
    if response.data.code == 200 then
        SystemLevelPage.total_courses = #list
        return slice(list, (page-1)*10+1, page*10)
    end
end

function SystemEntrencePage:ShowPage(bShow, school, on_choose, page)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    SystemEntrencePage.bForceHide = bShow == false;
    SystemEntrencePage.school = school
    SystemEntrencePage.on_choose = on_choose or false
    SystemEntrencePage.page = page or 1
    SystemEntrencePage.length = length or 6
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/SystemEntrence.html", 
        name = "SystemEntrence.ShowPage", 
        isShowTitleBar = false,
        DestroyOnClose = true,
        bToggleShowHide=true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
        directPosition = true,
            align = "_ct",
            x = -1920/2,
            y = -1080/2,
            width = 1920,
            height = 1080,
        };
    System.App.Commands.Call("File.MCMLWindowFrame", params);
end

function SystemLevelPage.OnInit()
	SystemLevelPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function SystemLevelPage.OneTimeInit()
	if(SystemLevelPage.is_inited) then
		return;
	end
	SystemLevelPage.is_inited = true;
end

-- clicked a block
function SystemLevelPage.OnClickBlock(block_id)
end

function SystemLevelPage:ShowPage(bShow, grade_id, semester_id, page)
    NPL.load("(gl)script/apps/Aries/Creator/Game/Areas/DesktopMenuPage.lua");
    local DesktopMenuPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.DesktopMenuPage");
    SystemLevelPage.bForceHide = bShow == false;
    SystemLevelPage.grade_id = grade_id
    SystemLevelPage.semester_id = semester_id
    SystemLevelPage.page = page or 1
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/SystemLevel.html", 
        name = "SystemLevelPage.ShowPage", 
        isShowTitleBar = false,
        DestroyOnClose = true,
        bToggleShowHide=true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
        directPosition = true,
            align = "_ct",
            x = -1920/2,
            y = -1080/2,
            width = 1920,
            height = 1080,
        };
    System.App.Commands.Call("File.MCMLWindowFrame", params);
end