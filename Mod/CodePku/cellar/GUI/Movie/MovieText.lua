
local CodePkuMovieText = NPL.export()
local MovieText = commonlib.gettable("MyCompany.Aries.Game.Mod.MovieText");


function CodePkuMovieText:ShowPage()
    local params = {
		url = "Mod/CodePku/cellar/GUI/Movie/MovieText.html",
		name = "MovieText.ShowPage", 
		app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
		isShowTitleBar = false,
		DestroyOnClose = true, -- prevent many ViewProfile pages staying in memory
		style = CommonCtrl.WindowFrame.ContainerStyle,
		zorder = 100,
		allowDrag = false,
		click_through = false,
		directPosition = true,
			align = "_fi",
			x = 0,
			y = 0,
			width = 0,
			height = 0,
	};
	-- display a page containing all operations that can apply to current selection, like deletion, extruding, coloring, etc. 
	System.App.Commands.Call("File.MCMLWindowFrame", params);
	params._page.OnClose = function()
		page = nil;
		MovieText.OnClose();
	end 
end