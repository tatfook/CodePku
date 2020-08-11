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
        [1] = {'chinese','语文'},
        [2] = {'math','数学'},
        [3] = {'english','英语'},
        [4] = {'physics','物理'},
        [5] = {'chemistry','化学'},
        [6] = {'biology','生物'},
    }

    for i = 1,6 do
        local trow = math.floor((i-1)/2)
        local tcol = math.floor((i-1)%2)
        table.insert(SubjectPage.subject_list,{
            index = i,
            row = trow,
            col = tcol,
            level = '0级',
            progress = 0,
            total_exp = 30,
            name = const_subject[i][1],
            chname = const_subject[i][2],
        })                            
    end
end

function SubjectPage.GetLevels()
    SubjectPage.OnInitSubject()
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
	response = request:get('/users/levels',nil,{sync = true})
	local subject_names = {
        [1] = {'chinese','语文'},
        [2] = {'math','数学'},
        [3] = {'english','英语'},
        [4] = {'physics','物理'},
        [5] = {'chemistry','化学'},
        [6] = {'biology','生物'},
        [7] = {'politics','政治'},
        [8] = {'history','历史'},
        [9] = {'geography ','地理'},
        [10] = {'programming','编程'},
    }

    if response.status == 200 then
        data = response.data.data	
        for i = 1,#data do
            if data[i].level_type < 7 then
                echo(data[i].level_type)
                SubjectPage.subject_list[data[i].level_type].level = data[i].current_level .. "级"
                SubjectPage.subject_list[data[i].level_type].progress = data[i].current_exp
                SubjectPage.subject_list[data[i].level_type].total_exp = data[i].next_exp

            end                                       
        end
    end
end

-- clicked a block
function SubjectPage.OnClickBlock(block_id)

end

function SubjectPage:ShowPage(bShow)
	SubjectPage.GetLevels()
    SubjectPage.bForceHide = bShow == false;
    NPL.load("(gl)Mod/CodePku/cellar/GUI/Window/AdaptWindow.lua");
    local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
    AdaptWindow:QuickWindow({url="Mod/CodePku/cellar/GUI/Subject.html", 
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =21})
end