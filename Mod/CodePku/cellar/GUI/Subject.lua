local SubjectPage = commonlib.gettable("Mod.CodePku.SubjectPage")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
local page;

function SubjectPage.OnInit()
	SubjectPage.OneTimeInit();
	page = document:GetPageCtrl();
end

function SubjectPage.OneTimeInit()
	if(SubjectPage.is_inited) then
		return;
	end
	SubjectPage.is_inited = true;
end

function SubjectPage.OnInitSubject()
    SubjectPage.subject_list = {}
    local const_subject = {
        [1] = {'chinese', '语文', 'codepku/image/textures/profile_32bits.png#1700 164 104 106',1},
        [2] = {'math', '数学', 'codepku/image/textures/profile_32bits.png#1700 281 104 106',2},
        [3] = {'english', '英语', 'codepku/image/textures/profile_32bits.png#1702 398 104 106',3},
        -- [4] = {'physics', '物理', 'codepku/image/textures/profile_32bits.png#1576 280 104 106'},
        -- [5] = {'chemistry', '化学', 'codepku/image/textures/profile_32bits.png#1576 397 104 106'},
        -- [6] = {'biology', '生物', 'codepku/image/textures/profile_32bits.png#1579 164 104 106'},
        [4] = {'science', '科学', 'codepku/image/textures/profile_32bits.png#1700 164 104 106',13},
        [5] = {'programming', '编程', 'codepku/image/textures/profile_32bits.png#1700 281 104 106',10},
        [6] = {'literature_history', '文史', 'codepku/image/textures/profile_32bits.png#1702 398 104 106',12}
    }
    -- SubjectPage.subject_list = {
    --     {name: 'chinese', chname: '语文', icon: 'codepku/image/textures/profile_32bits.png#1700 164 104 106'},
    --     {name: 'math', chname: '数学', icon: 'codepku/image/textures/profile_32bits.png#1700 281 104 106'},
    --     {name: 'english', chname: '英语', icon: 'codepku/image/textures/profile_32bits.png#1702 398 104 106'},
    --     {name: 'physics', chname: '物理', icon: 'codepku/image/textures/profile_32bits.png#1576 280 104 106'},
    --     {name: 'chemistry', chname: '化学', icon: 'codepku/image/textures/profile_32bits.png#1576 397 104 106'},
    --     {name: 'biology', chname: '生物', icon: 'codepku/image/textures/profile_32bits.png#1579 164 104 106'},
    -- };

    for i = 1,6 do
        -- local trow = math.floor((i-1)/2)
        -- local tcol = math.floor((i-1)%2)
        table.insert(SubjectPage.subject_list,{
            index = i,
            -- row = trow,
            -- col = tcol,
            level = '1级',
            percent = 0,
            current_exp = 0,
            next_exp = 30,
            progress = 0,
            total_exp = 0,
            name = const_subject[i][1],
            chname = const_subject[i][2],
            icon = const_subject[i][3],
            subject_id = const_subject[i][4]
        })                            
    end
end

function GetSubjectIndex(level_type)
    -- level_type ==> subject_list Index
    for k,v in ipairs(SubjectPage.subject_list) do
        if v['subject_id'] == level_type then
            return k
        end
    end
    return nil
end

function SubjectPage.GetLevels()
    SubjectPage.OnInitSubject();

    request:get('/users/levels'):next(function(response)
        if (response.status == 200) then
            local data = response.data.data;
            for i = 1, #data do
                if data[i].level_type and data[i].level_type ~= 11 then
                    SubjectPage.subject_list[GetSubjectIndex(data[i].level_type)].level = data[i].current_level .. "级";
                    SubjectPage.subject_list[GetSubjectIndex(data[i].level_type)].percent = data[i].current_exp / data[i].next_exp;
                    SubjectPage.subject_list[GetSubjectIndex(data[i].level_type)].current_exp = data[i].current_exp;
                    SubjectPage.subject_list[GetSubjectIndex(data[i].level_type)].next_exp = data[i].next_exp; -- means total
                end                                       
            end
            SubjectPage:InitWindow();                                           
        end
    end):catch(function(e)
        echo("ERROR: catched at SubjectPage.GetLevels")
        echo(e)
        GameLogic.AddBBS("CodeGlobals", e.data.message or L"获取学科等级详情失败", 3000, "#00FF00");
        SubjectPage:InitWindow();
    end);
end

-- clicked a block
function SubjectPage.OnClickBlock(block_id)

end

function SubjectPage:ShowPage()
    SubjectPage.GetLevels();
end

function SubjectPage:InitWindow()
    SubjectPage.bForceHide = bShow == false;
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/Subject.html", 
    alignment="_fi", left = 0, top = 0, width = 0, height = 0,zorder = 21});
end