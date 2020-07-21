NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local SystemEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SystemEntrencePage");
local SystemLevelPage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.SystemLevelPage");
local request = NPL.load("(gl)Mod/CodePkuCommon/api/BaseRequest.lua");
local page;
SystemLevelPage.subjects = {
    [1] = {name='推荐', title='reco_clicked', index=1, subject_id=2, show=true},
    [2] = {name='语文', title='chinese', index=2, subject_id=1, show=true},
    [3] = {name='数学', title='math', index=3, subject_id=2, show=true},
    [4] = {name='英语', title='english', index=4, subject_id=3, show=true},
    [5] = {name='物理', title='physics', index=5, subject_id=4, show=true},
    [6] = {name='化学', title='chemestry', index=6, subject_id=5, show=true},
    [7] = {name='生物', title='biology', index=7, subject_id=6, show=true},
}

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

function SystemLevelPage.GetLevels(grade_id, semester_id, subject_id)
    response = request:get(string.format('/coursewares/entrance/system?grade=%d&semester=%d&subject=%d&', grade_id, semester_id, subject_id),nil,{sync = true})
    data = response.data.data
    page = SystemLevelPage.page or 1
    list = {}
    a = 0
    if (response.data.code == 200 and #data ~= 0) then
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
    SystemLevelPage.total_courses = #list
    return slice(list, (page-1)*10+1, page*10)
    end
end

function SystemEntrencePage:ShowPage(bShow, school, on_choose, page)
    SystemEntrencePage.school = school
    SystemEntrencePage.on_choose = on_choose or false
    SystemEntrencePage.page = page or 1
    SystemEntrencePage.length = length or 6
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/SystemEntrence.html", 
        name = "SystemEntrence.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end

function SystemLevelPage:ShowPage(bShow, grade_id, semester_id, page)
    SystemLevelPage.grade_id = grade_id
    SystemLevelPage.semester_id = semester_id
    SystemLevelPage.page = page or 1
    SystemLevelPage.courses = SystemLevelPage.GetLevels(grade_id, semester_id, 2)
    
    for i, v in ipairs(SystemLevelPage.subjects) do
        course = SystemLevelPage.GetLevels(grade_id, semester_id, v.subject_id)
        if course == nil or #course == 0 then
            v.show = false
        end
    end
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/SystemLevel.html", 
        name = "SystemLevelPage.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end