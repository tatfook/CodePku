--[[
Title: Feedback
Author: loujiayu
Date: 2020/8/12
-----------------------------------------------

local Feedback = NPL.load("(gl)Mod/CodePku/cellar/GUI/Feedback/Feedback.lua");
Feedback:ShowPage();
-----------------------------------------------
]]

local Feedback = NPL.export();

function Feedback:GetWord()
    return "请输入反馈的内容，如需我们主动联系，请留下联系方式"
end

function Feedback:ShowPage(bShow)
    -- Feedback.GetWord();   
    NPL.load("(gl)script/ide/System/Windows/Window.lua");
	local Window = commonlib.gettable("System.Windows.Window");
    local window = Window:new();
    window:Show({
		url="Mod/CodePku/cellar/GUI/Feedback/SubmitFeedback.html", 
		alignment="_ct", left = -1158/2, top = -588/2, width = 1158 , height = 588, zorder = 30
    });
    window:SetMinimumScreenSize(1920, 1080);
end
