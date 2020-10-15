--[[
Title: TeachCourses
Author: loujiayu
Date: 2020/9/21
--------------------------------------

local TeachCourses = NPL.load("(gl)Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourses/TeachCourses.lua");
TeachCourses:ShowPage();
--------------------------------------
]]

local TeachCourses = NPL.export();
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

TeachCourses.main_icons_path = "codepku/image/textures/smallmap/teach/mainicons.png"       -- 年级导图雪碧图
TeachCourses.courseware_icons_path = "codepku/image/textures/smallmap/teach/coursewareicons.png"         -- 单科分页雪碧图
TeachCourses.purchase_icons_path = "codepku/image/textures/smallmap/teach/purchaseicons.png"       -- 解锁课程包雪碧图
TeachCourses.background_path = "codepku/image/textures/smallmap/teach/background.png"        -- 小山坡背景图
TeachCourses.courseware_background_path = "codepku/image/textures/smallmap/teach/coursewarebackground.png"         -- 单科分页背景图

-- 年级封面
TeachCourses.grade_covers = {
    [1] = "codepku/image/textures/smallmap/teach/class_1.png",
    [2] = "codepku/image/textures/smallmap/teach/class_2.png",
    [3] = "codepku/image/textures/smallmap/teach/class_3.png",
    [4] = "codepku/image/textures/smallmap/teach/class_4.png",
    [5] = "codepku/image/textures/smallmap/teach/class_5.png",
    [6] = "codepku/image/textures/smallmap/teach/class_6.png",
}

TeachCourses.icons = {
    -- 年级导图图标
    [1] = {url = TeachCourses.main_icons_path, left=41, top=34, width=298, height=130, desc = '左上角年级导图小学飘旗'},
    [2] = {url = TeachCourses.main_icons_path, left=369, top=48, width=101, height=102, desc = '红叉'},
    [3] = {url = TeachCourses.main_icons_path, left=500, top=34, width=111, height=155, desc = '左箭头'},
    [4] = {url = TeachCourses.main_icons_path, left=657, top=36, width=111, height=155, desc = '右箭头'},
    [5] = {url = TeachCourses.main_icons_path, left=1027, top=105, width=24, height=24, desc = '实心页码点'},
    [6] = {url = TeachCourses.main_icons_path, left=1069, top=99, width=36, height=37, desc = '空心页码点'},
    [7] = {url = TeachCourses.main_icons_path, left=1287, top=36, width=502, height=158, desc = '解锁学期包'},
    [8] = {url = TeachCourses.main_icons_path, left=55, top=233, width=324, height=247, desc = '年级背景'},
    [9] = {url = TeachCourses.main_icons_path, left=421, top=246, width=283, height=221, desc = '年级图片(暂用)'},
    [10] = {url = TeachCourses.main_icons_path, left=734, top=288, width=186, height=118, desc = '年级图片右上角胶带'},
    [11] = {url = TeachCourses.main_icons_path, left=965, top=327, width=380, height=73, desc = '这个年级没课啊，搞个东西给他遮着'},
    [12] = {url = TeachCourses.main_icons_path, left=41, top=579, width=300, height=220, desc = '传送牌'},
    [13] = {url = TeachCourses.main_icons_path, left=91, top=938, width=1748, height=968, desc = '年级导图背景书本'},
    [14] = {url = TeachCourses.main_icons_path, left=419, top=626, width=204, height=68, desc = '一年级(上)'},
    [15] = {url = TeachCourses.main_icons_path, left=419, top=739, width=204, height=68, desc = '一年级(下)'},
    [16] = {url = TeachCourses.main_icons_path, left=641, top=626, width=204, height=68, desc = '二年级(上)'},
    [17] = {url = TeachCourses.main_icons_path, left=641, top=739, width=204, height=68, desc = '二年级(下)'},
    [18] = {url = TeachCourses.main_icons_path, left=863, top=626, width=204, height=68, desc = '三年级(上)'},
    [19] = {url = TeachCourses.main_icons_path, left=863, top=739, width=204, height=68, desc = '三年级(下)'},
    [20] = {url = TeachCourses.main_icons_path, left=1085, top=626, width=204, height=68, desc = '四年级(上)'},
    [21] = {url = TeachCourses.main_icons_path, left=1085, top=739, width=204, height=68, desc = '四年级(下)'},
    [22] = {url = TeachCourses.main_icons_path, left=1529, top=626, width=204, height=68, desc = '五年级(上)'},
    [23] = {url = TeachCourses.main_icons_path, left=1529, top=739, width=204, height=68, desc = '五年级(下)'},
    [24] = {url = TeachCourses.main_icons_path, left=1307, top=626, width=204, height=68, desc = '六年级(上)'},
    [25] = {url = TeachCourses.main_icons_path, left=1307, top=739, width=204, height=68, desc = '六年级(下)'},
    -- 单科分页图标
    [26] = {url = TeachCourses.courseware_icons_path, left=40, top=32, width=298, height=130, desc = '左上角哪个年级'},
    [27] = {url = TeachCourses.courseware_icons_path, left=369, top=48, width=101, height=102, desc = '红叉'},
    [28] = {url = TeachCourses.courseware_icons_path, left=524, top=62, width=69, height=95, desc = '翻页左箭头'},
    [29] = {url = TeachCourses.courseware_icons_path, left=674, top=62, width=69, height=95, desc = '翻页右箭头'},
    [30] = {url = TeachCourses.courseware_icons_path, left=910, top=97, width=24, height=24, desc = '实心页码点'},
    [31] = {url = TeachCourses.courseware_icons_path, left=952, top=91, width=36, height=37, desc = '空心页码点'},
    [32] = {url = TeachCourses.courseware_icons_path, left=1105, top=12, width=502, height=158, desc = '解锁课程包'},
    [33] = {url = TeachCourses.courseware_icons_path, left=55, top=233, width=324, height=247, desc = '课程背景'},
    [34] = {url = TeachCourses.courseware_icons_path, left=417, top=257, width=290, height=199, desc = '课程图片(暂用)'},
    [35] = {url = TeachCourses.courseware_icons_path, left=743, top=256, width=321, height=71, desc = '课程标题'},
    [36] = {url = TeachCourses.courseware_icons_path, left=747, top=373, width=121, height=78, desc = '回顾'},
    [37] = {url = TeachCourses.courseware_icons_path, left=942, top=378, width=85, height=79, desc = '点击购买'},
    [38] = {url = TeachCourses.courseware_icons_path, left=1105, top=233, width=311, height=233, desc = '未解锁遮罩'},
    [39] = {url = TeachCourses.courseware_icons_path, left=1451, top=229, width=72, height=76, desc = '银币'},
    [40] = {url = TeachCourses.courseware_icons_path, left=1564, top=229, width=73, height=83, desc = '金色玩学币'},
    [41] = {url = TeachCourses.courseware_icons_path, left=1673, top=248, width=215, height=63, desc = '填货币数量的地方'},
    [42] = {url = TeachCourses.courseware_icons_path, left=1925, top=261, width=103, height=53, desc = '解锁玩学币图片'},
    [43] = {url = TeachCourses.courseware_icons_path, left=1460, top=347, width=91, height=119, desc = '问号'},
    [44] = {url = TeachCourses.courseware_icons_path, left=1646, top=364, width=75, height=81, desc = '锁'},
    [45] = {url = TeachCourses.courseware_icons_path, left=72, top=587, width=236, height=104, desc = '数学选中'},
    [46] = {url = TeachCourses.courseware_icons_path, left=76, top=747, width=231, height=91, desc = '数学'},
    [47] = {url = TeachCourses.courseware_icons_path, left=359, top=584, width=235, height=107, desc = '语文选中'},
    [48] = {url = TeachCourses.courseware_icons_path, left=361, top=748, width=231, height=91, desc = '语文'},
    [49] = {url = TeachCourses.courseware_icons_path, left=640, top=591, width=240, height=100, desc = '英语选中'},
    [50] = {url = TeachCourses.courseware_icons_path, left=649, top=748, width=231, height=91, desc = '英语'},
    [51] = {url = TeachCourses.courseware_icons_path, left=65, top=903, width=1631, height=894, desc = '单科分页第一层背景'},
    -- 解锁课程包图标
    [52] = {url = TeachCourses.purchase_icons_path, left=57, top=51, width=104, height=105, desc = '红叉'},
    [53] = {url = TeachCourses.purchase_icons_path, left=268, top=63, width=69, height=95, desc = '左箭头'},
    [54] = {url = TeachCourses.purchase_icons_path, left=418, top=63, width=69, height=95, desc = '右箭头'},
    [55] = {url = TeachCourses.purchase_icons_path, left=607, top=84, width=55, height=56, desc = '红色感叹号'},
    -- 以下三个已废弃，原图已删除
    -- [56] = {url = TeachCourses.purchase_icons_path, left=21, top=215, width=399, height=327, desc = '紫色背景三星底座'},
    -- [57] = {url = TeachCourses.purchase_icons_path, left=437, top=215, width=399, height=327, desc = '绿色背景二星底座'},
    -- [58] = {url = TeachCourses.purchase_icons_path, left=852, top=215, width=399, height=327, desc = '蓝色背景一星底座'},
    [59] = {url = TeachCourses.purchase_icons_path, left=1269, top=215, width=399, height=327, desc = '说明小弹窗'},
    [60] = {url = TeachCourses.purchase_icons_path, left=1345, top=88, width=50, height=53, desc = '一般型号的玩学币'},
    [61] = {url = TeachCourses.purchase_icons_path, left=1497, top=99, width=30, height=33, desc = '小号玩学币'},
    [62] = {url = TeachCourses.purchase_icons_path, left=53, top=633, width=257, height=206, desc = '一大堆书'},
    [63] = {url = TeachCourses.purchase_icons_path, left=338, top=648, width=236, height=190, desc = '小堆书'},
    [64] = {url = TeachCourses.purchase_icons_path, left=599, top=692, width=231, height=123, desc = '一本书'},
    [65] = {url = TeachCourses.purchase_icons_path, left=895, top=684, width=221, height=108, desc = '学期包tips'},
    [66] = {url = TeachCourses.purchase_icons_path, left=1139, top=683, width=221, height=108, desc = '课程包tips'},
    [67] = {url = TeachCourses.purchase_icons_path, left=1391, top=669, width=211, height=135, desc = '单课tips'},
    [68] = {url = TeachCourses.purchase_icons_path, left=1666, top=698, width=307, height=106, desc = '这里用来放解锁价格'},
    [69] = {url = TeachCourses.purchase_icons_path, left=211, top=981, width=1609, height=916, desc = '课程解锁小黑板'},
    [70] = {url = TeachCourses.purchase_icons_path, left=72, top=319, width=357, height=206, desc = '单课解锁边缘遮罩'},
}


-- 获取对应图标
function TeachCourses.GetTeachCoursesIconPathStr(id)
    local path=""
    id = tonumber(id)
    path = path..TeachCourses.icons[id].url
    if TeachCourses.icons[id].left then
      path = path..'#'
      path = path..tostring(TeachCourses.icons[id].left)
      path = path..' '..tostring(TeachCourses.icons[id].top)
      path = path..' '..tostring(TeachCourses.icons[id].width)
      path = path..' '..tostring(TeachCourses.icons[id].height)
    end
    LOG.std(nil, "TeachCourses", "GetTeachCoursesIconPathStr", "path = %s", path)
    return path
end

-- 年级列表
-- @params:int sort_index 实际上并不影响排序，主要是为了定位具体的年级增加的唯一标识，跟index保持一致可以保证请求的课件信息是正确年级的课件
TeachCourses.grade_list = {
    [1] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(14), desc = '一年级(上)', count = 0, cover_url = TeachCourses.grade_covers[1], sort_index = 1, },
    [2] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(16), desc = '二年级(上)', count = 0, cover_url = TeachCourses.grade_covers[2], sort_index = 2, },
    [3] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(18), desc = '三年级(上)', count = 0, cover_url = TeachCourses.grade_covers[3], sort_index = 3, },
    [4] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(20), desc = '四年级(上)', count = 0, cover_url = TeachCourses.grade_covers[4], sort_index = 4, },
    [5] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(22), desc = '五年级(上)', count = 0, cover_url = TeachCourses.grade_covers[5], sort_index = 5, },
    [6] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(24), desc = '六年级(上)', count = 0, cover_url = TeachCourses.grade_covers[6], sort_index = 6, },
    [7] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(15), desc = '一年级(下)', count = 0, cover_url = TeachCourses.grade_covers[1], sort_index = 7, },
    [8] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(17), desc = '二年级(下)', count = 0, cover_url = TeachCourses.grade_covers[2], sort_index = 8, },
    [9] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(19), desc = '三年级(下)', count = 0, cover_url = TeachCourses.grade_covers[3], sort_index = 9, },
    [10] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(21), desc = '四年级(下)', count = 0, cover_url = TeachCourses.grade_covers[4], sort_index = 10, },
    [11] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(23), desc = '五年级(下)', count = 0, cover_url = TeachCourses.grade_covers[5], sort_index = 11, },
    [12] = {tips_url = TeachCourses.GetTeachCoursesIconPathStr(25), desc = '六年级(下)', count = 0, cover_url = TeachCourses.grade_covers[6], sort_index = 12, },
}

-- 用来展示教学区单课分页左上角标题
TeachCourses.grade_matrix = {[1]="一年级",[2]="二年级",[3]="三年级",[4]="四年级",[5]="五年级",[6]="六年级"}
TeachCourses.semester_matrix = {[1]="(上)",[2]="(下)"}

-- 学科列表
TeachCourses.subjects = {
    [1] = {name='语文', title='chinese', index=1, subject_id=1, course = {}, show=true},
    [2] = {name='数学', title='math', index=2, subject_id=2, course = {}, show=true},
    [3] = {name='英语', title='english', index=3, subject_id=3, course = {}, show=true},
    [4] = {name='物理', title='physics', index=4, subject_id=4, course = {}, show=false},
    [5] = {name='化学', title='chemestry', index=5, subject_id=5, course = {}, show=false},
    [6] = {name='生物', title='biology', index=6, subject_id=6, course = {}, show=false},
}

TeachCourses.params = {
    -- 解锁学期包
    [1] = {url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourses/PurchaseSemesterPackage.html",alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31},
    -- 解锁课程包
    [2] = {url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourses/PurchaseCoursesPackage.html",alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31},
    -- 单课解锁
    [3] = {url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourses/PurchaseCourse.html",alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 31},
    -- 单科分页
    [4] = {url="Mod/CodePku/cellar/GUI/SmallMap/FastEntrence/TeachCourses/TeachCourseware.html",alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30},
}

TeachCourses.pagePackage = {}

function TeachCourses:ShowPage(id)
    local page
    self.ui = AdaptWindow:QuickWindow(TeachCourses.params[id])
    page = self.ui
    table.insert(TeachCourses.pagePackage, page)
end

-- 一键关闭所有教学区页面，慎用
function TeachCourses:TurnOffAllPage()
    for k,v in pairs(TeachCourses.pagePackage) do
        if next(v) ~= nil then
            v:CloseWindow()
        end
    end
end

-- 获取年级列表
function TeachCourses:GetGradeList(page)
    request:get('/coursewares/by-grade'):next(function(response)
        if (response.status == 200) then
            -- 组装年级导图数据
            local data = response.data.data
            for _,v in pairs(data) do
                local grade = v.grade - 1
                local semester = v.semester
                local index
                if semester == 1 then
                    index = grade
                elseif semester == 2 then
                    -- 下学期的index是从7开始，比年级grade大6
                    index = grade + 6
                end
                -- 数据放进对应的年级
                TeachCourses.grade_list[index].count = v.count
                TeachCourses.grade_list[index].grade = grade
                TeachCourses.grade_list[index].semester = semester
            end
            -- 拼完数据刷新页面展示数据
            page:Refresh(0)
        end
    end):catch(function(e)
        LOG.std(nil, "TeachCourses", "GetGradeList", "error_msg: = %s", e)
    end)
end

-- 获取详细课件信息
function TeachCourses:GetCoursewares(grade, semester, subject)
    local path = string.format("/courses/entrance/system?grade=%d&semester=%d&subject=%d", grade, semester, subject)
    request:get(path):next(function(response)
        if (response.status == 200) then
            local data = response.data.data
            -- 当前可见所在的课程包信息,用于单课解锁时的课程包信息
            TeachCourses.coursesPackageinfo = data
            local index = 1
            TeachCourses.subjects[subject].course = {}
            for j,d in pairs(data.wares) do
                TeachCourses.subjects[subject].course[index] = d
                -- 把课件的封面拿到外层放着
                TeachCourses.subjects[subject].course[index].file_url = d.cover_file.file_url
                index = index + 1
            end
            if TeachCourses.TeachCoursesPage then
                TeachCourses.TeachCoursesPage:Refresh(0)
            end
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

-- 清空所有课件信息,关闭学科分类页面时使用
function TeachCourses:CleanAllCoursewares()
    for k,v in pairs(TeachCourses.subjects) do
        TeachCourses.subjects[k].course = {}
    end
end

-- 获取指定id课件的name和keepworkID
function TeachCourses:GetCoursewareUniqueness(id)
    local temp_table = TeachCourses.subjects[TeachCourses.courseware_last_click_index].course
    for k,v in pairs(temp_table) do
        if id == v.id then
            return v.name, v.keepwork_project_id
        end
    end
end

-- 动态获取页码点的相对位置left坐标
-- paras:
-- pointsCount = 页码点数量(页数)
-- distance = 每个页码点之间的距离
-- divWidth = 放置页码点的父级div的width
function TeachCourses:GetPagePoints(pointsCount, distance, divWidth)
    local blocks = math.floor(divWidth/distance)
    local evenSatrtX = math.floor((divWidth - distance*blocks)/2) + math.floor((blocks-pointsCount)/2)*distance
    local oddSatrtX = evenSatrtX + math.floor(distance/2)

    local points = {}
    if pointsCount%2 == 0 then
        for i = 1,pointsCount do
            points[i] = {index=i, x=evenSatrtX+(i-1)*distance}
        end
        return points
    else
        for i = 1,pointsCount do
            points[i] = {index=i, x=oddSatrtX+(i-1)*distance}
        end
        return points
    end
end

-- 获取指定年级学期的所有课程包信息
function TeachCourses:GetCoursesPackage(grade, semester)
    local grade  = grade + 1
    local path = string.format("/courses/entrance/package?grade=%d&semester=%d", grade, semester)
    request:get(path):next(function(response)
        if (response.status == 200) then
            -- 指定年级学期的所有课程包信息,用于解锁课程包
            TeachCourses.allCoursesPackageinfo = response.data.data
            self.ui:Refresh(0)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

-- 购买指定ID的课程包
function TeachCourses:PurchaseCourse(id,type,price)
    local path = "/user-props/unlock-course"
    local courseId  = id and tonumber(id)
    local data = {entity_id=courseId, entity_type=type}
    request:post(path,data):next(function(response)
        if (response.status == 200) then
            -- 指定年级学期的所有课程包信息,用于解锁课程包
            GameLogic.AddBBS("CodeGlobals", response.data.message, 3000, "#00FF00");
            local CommonFunc = commonlib.gettable("Mod.CodePku.Common.CommonFunc")
            CommonFunc.RefreshLocalMoney({{amount=-price,currency_id=2,},}, {TeachCourses.TeachMainPage})
            TeachCourses:GetCoursewares(TeachCourses.Clicked_Grade + 1, TeachCourses.Clicked_Semester, TeachCourses.courseware_last_click_index)
        end
    end):catch(function(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
    end)
end

--判断余额是否足以支付
function TeachCourses:JudgeAford(price)
    local info = System.User.info
    local user_wallets =  info and info.user_wallets
    for _,v in pairs(user_wallets) do
        if v.currency_id == 2 then
            local curMoney = v.amount
            if curMoney >= price then
                return true
            end
        end
    end
    return false
end
