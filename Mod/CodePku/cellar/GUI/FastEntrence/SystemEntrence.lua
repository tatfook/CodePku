NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local SystemEntrencePage = commonlib.gettable("Mod.CodePku.SystemEntrencePage");
local SystemLevelPage = commonlib.gettable("Mod.CodePku.SystemLevelPage");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local SystemEntranceChoosePage = commonlib.gettable("Mod.CodePku.SystemEntranceChoosePage");

local page;

SystemEntranceChoosePage.GradeDetails = {}
SystemEntranceChoosePage.GradeDetails['primary'] = {
    [1]={
        [1] = {name='一年级(上)', index=1, grade_id=2, semester_id=1, open=0},
        [2] = {name='一年级(下)', index=2, grade_id=2, semester_id=2, open=0},
        [3] = {name='二年级(上)', index=3, grade_id=3, semester_id=1, open=0},
        [4] = {name='二年级(下)', index=4, grade_id=3, semester_id=2, open=0},
        [5] = {name='三年级(上)', index=5, grade_id=4, semester_id=1, open=0},
        [6] = {name='三年级(下)', index=6, grade_id=4, semester_id=2, open=0},
    },
    [2]={
        [1] = {name='四年级(上)', index=1, grade_id=5, semester_id=1, open=0},
        [2] = {name='四年级(下)', index=2, grade_id=5, semester_id=2, open=0},
        [3] = {name='五年级(上)', index=3, grade_id=6, semester_id=1, open=0},
        [4] = {name='五年级(下)', index=4, grade_id=6, semester_id=2, open=0},
        [5] = {name='六年级(上)', index=5, grade_id=7, semester_id=1, open=0},
        [6] = {name='六年级(下)', index=6, grade_id=7, semester_id=2, open=0},
    }
}

SystemEntranceChoosePage.GradeDetails['middle'] = {
    [1]={
    [1] = {name='初一(上)', index=1, grade_id=8, semester_id=1, open=0},
    [2] = {name='初一(下)', index=2, grade_id=8, semester_id=2, open=0},
    [3] = {name='初二(上)', index=3, grade_id=9, semester_id=1, open=0},
    [4] = {name='初二(下)', index=4, grade_id=9, semester_id=2, open=0},
    [5] = {name='初三(上)', index=5, grade_id=10, semester_id=1, open=0},
    [6] = {name='初三(下)', index=6, grade_id=10, semester_id=2, open=0},
}}

SystemEntranceChoosePage.GradeDetails['high'] = {
    [1]={
    [1] = {name='高一(上)', index=1, grade_id=11, semester_id=1, open=0},
    [2] = {name='高一(下)', index=2, grade_id=11, semester_id=2, open=0},
    [3] = {name='高二(上)', index=3, grade_id=12, semester_id=1, open=0},
    [4] = {name='高二(下)', index=4, grade_id=12, semester_id=2, open=0},
    [5] = {name='高三(上)', index=5, grade_id=13, semester_id=1, open=0},
    [6] = {name='高三(下)', index=6, grade_id=13, semester_id=2, open=0},
}}

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
                if c.is_open == true then
                    l = {}
                    l['cover'] = c.cover_file.file_url
                    l['course'] = c
                    l['index'] = a % 10
                    a = a + 1
                    table.insert(list, l)
                end
            end
        end
    SystemLevelPage.total_courses = #list
    return slice(list, (page-1)*10+1, page*10)
    end
end

function SystemEntrencePage:ShowPage(bShow)
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

function SystemEntranceChoosePage:ShowPage(bShow, school, page, last_ctrl)
    page = page or 1
    SystemEntranceChoosePage.school = school
    SystemEntranceChoosePage.page = page
    SystemEntranceChoosePage.last_ctrl = last_ctrl
    -- 查询年级下有无课程
    _response = request:get("/coursewares/by-grade",nil,{sync = true})
    if _response.data.code == 200 then
        _data = _response.data.data
        for _, grades in ipairs(SystemEntranceChoosePage.GradeDetails[school]) do
            for _, grade in ipairs(grades) do
                grade_id = grade.grade_id
                semester_id = grade.semester_id
                for _, d in ipairs(_data) do
                    if d.grade == grade_id and d.semester == semester_id and d.count > 0 then
                        grade.open = 1
                    end
                end
            end
        end
    end
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/SystemEntranceChoose.html", 
        name = "SystemEntranceChoose.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 21,
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
    SystemLevelPage.last_clicked_index = 1
    SystemLevelPage.subjects = {
        [1] = {name='推荐', title='reco_clicked', index=1, subject_id=2, show=true},
        [2] = {name='语文', title='chinese', index=2, subject_id=1, show=true},
        [3] = {name='数学', title='math', index=3, subject_id=2, show=true},
        [4] = {name='英语', title='english', index=4, subject_id=3, show=true},
        [5] = {name='物理', title='physics', index=5, subject_id=4, show=true},
        [6] = {name='化学', title='chemestry', index=6, subject_id=5, show=true},
        [7] = {name='生物', title='biology', index=7, subject_id=6, show=true},
    }
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
        zorder = 21,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end