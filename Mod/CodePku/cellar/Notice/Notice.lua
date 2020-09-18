--[[
Title: Page
Author(s): NieXX
Date: 2020/9/11
Desc:
use the lib:
virtual functions:
    Notice:ShowPage()
    Notice:IsNew(NoticeTime)
    Notice:GetStatus(flag,time)
    Notice:GetNoticeList()
    Notice:HandleNotice(content)
    Notice:GetArticleByID(id)
    Notice:HandleTitle(title)
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Notice/Notice.lua")
local Notice = commonlib.gettable("Mod.CodePku.celler.Notice")
------------------------------------------------------------
]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
Notice = commonlib.gettable("Mod.CodePku.celler.Notice");

Notice.content = {}
Notice.noticeList = {}

Notice.Status = {
    [0] = {style = ""},
    [1] = {title = "火热",style = "position:relative;width: 82;height:60;left:10;top:-110;font-size:42;line-height: 110;background:url(codepku/image/textures/notice_system/detail_32bits.png#99 420 82 60)"},
    [2] = {title = "限时",style = "position:relative;width: 68;height:72;left:10;top:-105;font-size:42;line-height: 110;background:url(codepku/image/textures/notice_system/detail_32bits.png#100 552 68 72)"},
    [3] = {title = "新",style = "position:relative;width: 82;height:53;left:15;top:-95;font-size:42;line-height: 110;background:url(codepku/image/textures/notice_system/detail_32bits.png#105 179 82 53)"},
}

function Notice:ShowPage(PageIndex, bShow, id, mainasset)
    self:GetNoticeList()

    local params = {
		url = "Mod/CodePku/cellar/Notice/Notice.html",
		alignment="_lt", left = 0, top = 0, width = 1920, height = 1080, zorder = 30,
		click_through = false,
	}
	return AdaptWindow:QuickWindow(params)
end

-- Judge whether the interval between the given time and the current time is less than 7 days
-- @param NoticeTime: the given time
-- @return true if it is less than or equal to 7
function Notice:IsNew(NoticeTime)
    local strDate = NoticeTime
    local _, _, y, m, d, _hour, _min, _sec = string.find(strDate, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)");
    -- print(y, m, d, _hour, _min, _sec);
    local timestamp = os.time({year=y, month = m, day = d, hour = _hour, min = _min, sec = _sec});
    local nowDate = os.time();
    local res = math.abs(nowDate - timestamp) / (24*60*60);
    return res<=7
end

-- Get notice status
-- @param flag: 0-无 1-火热 2-限时
-- @param time: announcement time
-- @return background image of the state
function Notice:GetStatus(flag,time)
    if flag == 1 or flag == 2 then
        return self.Status[flag].style
    else
        if Notice:IsNew(time) then
            return self.Status[3].style
        else
            return self.Status[0].style
        end
    end
end

function Notice:GetNoticeList()
    local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");
    local response = request:get('/game-announcements',{},{sync = true});
	if response.status == 200 then
        self.noticeList = response.data.data or {};
	end
    return self.noticeList
end

function Notice:HandleNotice(content)
    -- 对内容做分段处理，以\n为分割符
    Notice.content = commonlib.split(content, "\n");
    local new_content = {};
    for i,j in ipairs(Notice.content) do
        table.insert(new_content,{pContent=j});
    end
    return new_content
end

function Notice:GetArticleByID(id)
    local notice_data = self.noticeList;
    local value = {};
    for k, v in ipairs(notice_data) do
        if v.id == id then
            value = v;
        end
    end
    return value
end

function Notice:HandleTitle(title)
    if commonlib.utf8.len(title) > 6 then 
        return commonlib.utf8.sub(title,1,6).."..."
    else
      return title  
    end
end