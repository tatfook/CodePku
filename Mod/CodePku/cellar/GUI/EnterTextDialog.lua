--[[
Title: Enter Text Dialog
Author(s): LiXizhi
Date: 2014/3/17
Desc: Display a dialog with text that let user to enter some input text. 
This is usually used by the /set -p name=prompt_msg command
use the lib:
------------------------------------------------------------
NPL.load("(gl)script/apps/Aries/Creator/Game/GUI/EnterTextDialog.lua");
local EnterTextDialog = commonlib.gettable("MyCompany.Aries.Game.GUI.EnterTextDialog");
EnterTextDialog.ShowPage("Please enter text", function(result)
	echo(result);
end)
EnterTextDialog.ShowPage("select buttons", function(result)
	echo(result);
end, nil, "buttons", {"button1", "button2", "button3", "button4"})
-------------------------------------------------------
]]
local EnterTextDialog = commonlib.gettable("MyCompany.Aries.Game.GUI.EnterTextDialog");
local CodePkuEnterTextDialog = NPL.export();

-- @param default_text: default text to be displayed. 
-- @param type_: if true, it is multi-line text. otherwise it is nil|text|multiline|select|buttons.
-- @param options: only used when type is "select" or "buttons". 
-- when type_ is "select": it is {{value="0", text="zero"},{value="1"}}
-- when type_ is "buttons": it is {"text1", "text2", "text3"}, result is button Index 
-- @param showParams: nil or {align="_ct", x, y, width, height}
function CodePkuEnterTextDialog.PageParams(showParams)
	local params = {
			url = "Mod/CodePku/cellar/GUI/EnterTextDialog.html", 
			name = "EnterTextDialog.ShowPage",
			isShowTitleBar = false,
			DestroyOnClose = true,
			bToggleShowHide=false, 
			style = CommonCtrl.WindowFrame.ContainerStyle,
			allowDrag = true,
			click_through = false, 
			enable_esc_key = true,
			bShow = true,
			isTopLevel = true,
			---app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
            directPosition = true,
			align = "_ctt",
			x = 0,
			y = 20,
			width = 640,
			height = 280,
			-- align = showParams.align or "_ct",
			-- x = showParams.x or -588/2,
			-- y = showParams.y or -374/2,
			-- width = showParams.width or 600,
			-- height = showParams.height or 374,
        };
    return params;
end