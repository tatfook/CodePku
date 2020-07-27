NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local TopicEntrencePage = commonlib.gettable("MyCompany.Aries.Creator.Game.Desktop.TopicEntrencePage");
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

function TopicEntrencePage.GetCourse(subject_id)
    response = request:get(string.format('/coursewares/entrance/topic?subject=%d', subject_id), nil,{sync = true})
    data = response.data.data
    list = {}
    for i, d in ipairs(data) do
        courses = d.course_wares
        a = 0
        for ii, c in ipairs(courses) do
            l = {}
            l['img'] = d.cover
            l['id'] = c.keepwork_project_id
            l['name'] = c.name
            l['index'] = a % 10
            a = a + 1
            table.insert(list, l)
        end
    end
    if response.data.code == 200 then
        return list
    end
end

function TopicEntrencePage:ShowPage(bShow)
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