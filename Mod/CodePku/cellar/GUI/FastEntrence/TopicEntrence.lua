NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local TopicEntrencePage = commonlib.gettable("Mod.CodePku.TopicEntrencePage");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

function TopicEntrencePage.GetCourse(subject_id)
    response = request:get(string.format('/coursewares/entrance/topic?subject=%d', subject_id), nil,{sync = true})
    data = response.data.data
    list = {}
    for i, d in ipairs(data) do
        courses = d.course_wares
        a = 0
        for ii, c in ipairs(courses) do
            if c.is_open then
                l = {}
                l['img'] = c.cover_file.file_url
                l['id'] = c.keepwork_project_id
                l['name'] = c.name
                l['index'] = a % 10
                a = a + 1
                table.insert(list, l)
            end
        end
    end
    if response.data.code == 200 then
        return list
    end
end

function TopicEntrencePage:ShowPage(bShow)
    TopicEntrencePage.searchByName = nil
    TopicEntrencePage.sortMethod = '默认排序'
    TopicEntrencePage.subjects = {
        [1] = {name='推荐', title='reco_clicked', index=1, subject_id=3, show=true},
        [2] = {name='语文', title='chinese', index=2, subject_id=1, show=true},
        [3] = {name='数学', title='math', index=3, subject_id=2, show=true},
        [4] = {name='英语', title='english', index=4, subject_id=3, show=true},
        [5] = {name='物理', title='physics', index=5, subject_id=4, show=true},
        [6] = {name='化学', title='chemestry', index=6, subject_id=5, show=true},
        [7] = {name='生物', title='biology', index=7, subject_id=6, show=true},
    }
    for i, v in ipairs(TopicEntrencePage.subjects) do
        course = TopicEntrencePage.GetCourse(v.subject_id)
        if course == nil or #course == 0 then
            v.show = false
        end
    end
    local params = {
        url = "Mod/CodePku/cellar/GUI/FastEntrence/TopicEntrence.html", 
        name = "TopicEntrence.ShowPage", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 20,
        directPosition = true,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
    local window = AdaptWindow:QuickWindow(params)
end