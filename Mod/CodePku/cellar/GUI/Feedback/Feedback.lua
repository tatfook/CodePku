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
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

function Feedback:ShowPage(bShow)  

    params = {
      url="Mod/CodePku/cellar/GUI/Feedback/SubmitFeedback.html", 
      alignment="_lt", left = 0, top = 0, width = 1920 , height = 1080, zorder = 30
    };
    AdaptWindow:QuickWindow(params)
end

function Feedback:submit(params)
  -- 判断参数齐全
  if type(params) == 'table' then 
    if params.category == 7 then
      GameLogic.AddBBS("CodeGlobals", L"请选择反馈的类型", 3000, "#FF0000");
      return false
    elseif params.content == nil or string.gsub(params.content, "%s+", "") == "" then
      GameLogic.AddBBS("CodeGlobals", L"请输入反馈内容", 3000, "#FF0000");
      return false
    end
  else 
    return false
  end

  -- 判断参数合法性
  if params.category < 1 or params.category > 6 then
    GameLogic.AddBBS("CodeGlobals", L"提交失败，请重试", 3000, "#FF0000");
    return false
  end

  if commonlib.utf8.len(params.content) > 100 then
    GameLogic.AddBBS("CodeGlobals", L"提交失败，字数超过限制", 3000, "#FF0000");
    return false
  end

  -- 校验通过，发送数据给后台
  ---[[
  request:post('/feedback',params):next(function(response)
    GameLogic.AddBBS("CodeGlobals", L"提交成功，感谢您的反馈", 3000, "#00FF00");
  end):catch(function(e)
    GameLogic.AddBBS("CodeGlobals", e.data.message, 3000, "#FF0000");
  end);
  return true
  --]]
end