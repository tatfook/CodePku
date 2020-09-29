local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local FastEntrence = NPL.export();

FastEntrence.page = nil
FastEntrence.coursePage = nil

FastEntrence.nowGradeIndex = 1

FastEntrence.nowGrade = {}

FastEntrence.GradePrimary = {{},{},{}}
FastEntrence.GradeMiddle = {}
FastEntrence.GradeHigh = {}

FastEntrence.GradeDetails = {
        {
            {name='一年级(上)', grade=2, semester=1, count=0, open=0},
            {name='一年级(下)', grade=2, semester=2, count=0, open=0}
        },
        {
            {name='二年级(上)', grade=3, semester=1, count=0, open=0},
            {name='二年级(下)', grade=3, semester=2, count=0, open=0}
        },
        {
            {name='三年级(上)', grade=4, semester=1, count=0, open=0},
            {name='三年级(下)', grade=4, semester=2, count=0, open=0}
        },
        {
            {name='四年级(上)', grade=5, semester=1, count=0, open=0},
            {name='四年级(下)', grade=5, semester=2, count=0, open=0}
        },
        {
            {name='五年级(上)', grade=6, semester=1, count=0, open=0},
            {name='五年级(下)', grade=6, semester=2, count=0, open=0}
        },
        {
            {name='六年级(上)', grade=7, semester=1, count=0, open=0},
            {name='六年级(下)', grade=7, semester=2, count=0, open=0}
        },
        {
            {name='初一(上)', grade=8, semester=1, count=0, open=0},
            {name='初一(下)', grade=8, semester=2, count=0, open=0}
        },
        {
            {name='初二(上)', grade=9, semester=1, count=0, open=0},
            {name='初二(下)', grade=9, semester=2, count=0, open=0}
        },
        {
            {name='初三(上)', grade=10, semester=1, count=0, open=0},
            {name='初三(下)', grade=10, semester=2, count=0, open=0}
        },
        {
            {name='高一(上)', grade=11, semester=1, count=0, open=0},
            {name='高一(下)', grade=11, semester=2, count=0, open=0}
        },
        {
            {name='高二(上)', grade=12, semester=1, count=0, open=0},
            {name='高二(下)', grade=12, semester=2, count=0, open=0}
        },
        {
            {name='高三(上)', grade=13, semester=1, count=0, open=0},
            {name='高三(下)', grade=13, semester=2, count=0, open=0}
        }
}

function FastEntrence:GetGradeInfo(grade)
    local response = request:get('/coursewares/by-grade',nil,{sync = true})
    data = response.data.data
    if response.data.code == 200 then
        local myIndex, max = 1, #data
        while myIndex <= max do
            FastEntrence.GradeDetails[data[myIndex].grade-1][data[myIndex].semester].count = data[myIndex].count
            myIndex = myIndex + 1
        end

        -- 初始化小学
        local primary_index = 1
        local pi = 1
        while(primary_index <= 3)do
            FastEntrence.GradePrimary[1][pi] = FastEntrence.GradeDetails[primary_index][1]
            pi = pi + 1
            FastEntrence.GradePrimary[1][pi] = FastEntrence.GradeDetails[primary_index][2]
            pi = pi + 1
            primary_index = primary_index + 1
        end

        pi = 1
        while(primary_index <= 6)do
            FastEntrence.GradePrimary[2][pi] = FastEntrence.GradeDetails[primary_index][1]
            pi = pi + 1
            FastEntrence.GradePrimary[2][pi] = FastEntrence.GradeDetails[primary_index][2]
            pi = pi + 1
            primary_index = primary_index + 1
        end
        
        -- 初始化初中
        local middle_index = 7
        local gm = 1
        while(middle_index >= 7 and middle_index <= 9)do
            FastEntrence.GradeMiddle[gm] = FastEntrence.GradeDetails[middle_index][1]
            gm = gm + 1
            FastEntrence.GradeMiddle[gm] = FastEntrence.GradeDetails[middle_index][2]
            middle_index = middle_index + 1
            gm = gm + 1
        end

        -- 初始化高中
        local high_index = 10
        local gh = 1
        while(high_index >= 10 and high_index <= 12)do
            FastEntrence.GradeHigh[gh] = FastEntrence.GradeDetails[high_index][1]
            gh = gh + 1
            FastEntrence.GradeHigh[gh] = FastEntrence.GradeDetails[high_index][2]
            high_index = high_index + 1
            gh = gh + 1
        end

    end
end

FastEntrence.params = {
    {
        url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourses/TeachMain.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    },
    {
        url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/CompeteEntrence.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    },
    {
        url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TopicEntrence.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    }
}

FastEntrence.popupParams = {
    {
        url="Mod/CodePku/cellar/GUI/SmallMap/Popup/ChooseGrade.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
    }
}

FastEntrence.CourseParams = {
    {
        url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourse.html",
        alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =20
    }
}

-- 后期数据完善了把 show 改为 true就会显示相应分页
FastEntrence.subjects = {
    [0] = {name='推荐', title='reco_clicked', index=1, subject_id=2, course = {}, show=false},
    [1] = {name='语文', title='chinese', index=2, subject_id=1, course = {}, show=false},
    [2] = {name='数学', title='math', index=3, subject_id=2, course = {}, show=true},
    [3] = {name='英语', title='english', index=4, subject_id=3, course = {}, show=false},
    [4] = {name='物理', title='physics', index=5, subject_id=4, course = {}, show=false},
    [5] = {name='化学', title='chemestry', index=6, subject_id=5, course = {}, show=false},
    [6] = {name='生物', title='biology', index=7, subject_id=6, course = {}, show=false},
}   


function FastEntrence:GetSubjects(gradeInfo, subject_id)

    FastEntrence.nowGrade = gradeInfo

    -- if subject_id == nil then
    --     local count = 1
    --     while(count <= #FastEntrence.subjects - 1)do
    --         response = request:get(string.format('/coursewares/entrance/system?grade=%d&semester=%d&subject=%d&', grade.grade, grade.semester, count), nil, {sync = true})
    --         data = response.data.data
    --         if response.data.code == 200 then
    --             local index = 1
    --             FastEntrence.subjects[count].course = {}
    --             for i, v in ipairs(data) do
    --                 for j, d in ipairs(v.course_wares) do
    --                     FastEntrence.subjects[count].course[index] = d
    --                     index = index + 1
    --                 end
    --             end
    --         end
            
    --         count = count + 1
            
    --     end
    --     FastEntrence.subjects[0].course = FastEntrence.subjects[2].course
    --else     
        if subject_id == 0 then
            subject_id = 2  -- 推荐数学
        end
    
        response = request:get(string.format('/coursewares/entrance/system?grade=%d&semester=%d&subject=%d&', gradeInfo.grade, gradeInfo.semester, subject_id), nil, {sync = true})
        data = response.data.data
        if response.data.code == 200 then
            local index = 1
            FastEntrence.subjects[subject_id].course = {}
            for i, v in ipairs(data) do
                for j, d in ipairs(v.course_wares) do
                    FastEntrence.subjects[subject_id].course[index] = d
                    index = index + 1
                end
            end
        end
    -- end
end

function FastEntrence:ShowPage(index)

    if FastEntrence.page ~= nil then
        FastEntrence.page:CloseWindow()
    end

    local Index = tonumber(index)

    FastEntrence.page = AdaptWindow:QuickWindow(FastEntrence.params[Index])
end


function FastEntrence:ShowCoursePage(index)
    if FastEntrence.coursePage ~= nil then
        FastEntrence.coursePage:CloseWindow()
    end
    local Index = tonumber(index)
    FastEntrence.coursePage = AdaptWindow:QuickWindow(FastEntrence.CourseParams[Index])
end

function FastEntrence:ShowPopupPage(index, pageIndex)

    if FastEntrence.popupPage ~= nil then
        FastEntrence.popupPage:CloseWindow()
    end

    local Index = tonumber(index)

    FastEntrence.nowGradeIndex = tonumber(pageIndex) or 1

    FastEntrence.popupPage = AdaptWindow:QuickWindow(FastEntrence.popupParams[Index])
end

function FastEntrence:ClosePage(num)
    if FastEntrence.page ~= nil then
        FastEntrence.page:CloseWindow()
    end
    if(num == 2)then
        if FastEntrence.coursePage ~= nil then
            local length = (#FastEntrence.subjects)-1
            for i=0, length do
                FastEntrence.subjects[i].course = {}
            end
            FastEntrence.coursePage:CloseWindow()
        end
    end
end