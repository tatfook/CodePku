local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local TopicCourse = NPL.export()
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

TopicCourse.nowPage = nil
TopicCourse.lastClickIndex = 1
TopicCourse.searchByName = nil
TopicCourse.sortMethod = '默认排序'

function TopicCourse.GetCourse(subject_id)
    -- 获取subject_id对应的课程
    response = request:get(string.format('/coursewares/entrance/topic?subject=%d', subject_id), nil,{sync = true})
    data = response.data.data
    list = {}
    for i=1, #data do
        courses = data[i].course_wares
        for ii=1, #courses do
            if courses[ii].is_open then
                l = {}
                l['img'] = courses[ii].cover_file.file_url
                l['id'] = courses[ii].keepwork_project_id
                l['name'] = courses[ii].name
                l['index'] = ii % 6
                table.insert(list, l)
            end
        end
    end
    if response.data.code == 200 then
        return list
    end
end

function TopicCourse:ShowPage(index)

    TopicCourse.lastClickSubjectId = tonumber(index)
    
    TopicCourse.subjects = {
        [1] = {name='语文', title='chinese', index=1, subject_id=1, show=true},
        [2] = {name='数学', title='math', index=2, subject_id=2, show=true},
        [3] = {name='英语', title='english', index=3, subject_id=3, show=true},
        [4] = {name='物理', title='physics', index=4, subject_id=4, show=false},
        [5] = {name='化学', title='chemestry', index=5, subject_id=5, show=false},
        [6] = {name='生物', title='biology', index=6, subject_id=6, show=false},
        [7] = {name='政治', title='politics', index=7, subject_id=7, show=false},
        [8] = {name='历史', title='history', index=8, subject_id=8, show=false},
        [9] = {name='地理', title='geography', index=9, subject_id=9, show=false},
        [10] = {name='科学', title='science', index=10, subject_id=13, show=true},
        [11] = {name='人文', title='humanity', index=11, subject_id=12, show=true},
        [12] = {name='编程', title='programming', index=12, subject_id=10, show=true},
    }

    for k,v in ipairs(TopicCourse.subjects) do
        if v.subject_id == TopicCourse.lastClickSubjectId  then
            TopicCourse.lastClickIndex = k
        end
    end

    local params = {
        url = "Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TopicCourse.html", 
        name = "TopicCourse", 
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        --bShow = bShow,
        click_through = false, 
        zorder = 22,
        --directPosition = true,
        alignment = "_ct",
        x = -1920/2,
        y = -1080/2,
        width = 1920,
        height = 1080,
        };
        TopicCourse.nowPage = AdaptWindow:QuickWindow(params)
end

function TopicCourse:ClosePage()
    if TopicCourse.nowPage ~= nil then
        TopicCourse.nowPage:CloseWindow()
    end
end