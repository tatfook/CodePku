local GameLogicDownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")

local DownloadWorld = NPL.export()

-- show page
function DownloadWorld:ShowPage(url)
	LOG.std(nil, "debug", "DownloadWorld", "show for url: %s", url);
    GameLogicDownloadWorld.url = url;
    local width, height=512, 300;
    System.App.Commands.Call("File.MCMLWindowFrame", {
        url = "Mod/CodePku/cellar/World/DownloadWorld.html", 
        name = "paracraft.DownloadWorld", 
        isShowTitleBar = false,
        DestroyOnClose = true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        zorder = 10,
        allowDrag = true,
        isTopLevel = true,
        directPosition = true,
            align = "_ct",
            x = -width/2,
            y = -height/2,
            width = width,
            height = height,
        cancelShowAnimation = true,
    });	
end

function DownloadWorld:ShowPrestrainPage()
    LOG.std(nil, "debug", "DownloadWorld", "prestrain");
    local width, height=512, 300;
    System.App.Commands.Call("File.MCMLWindowFrame", {
        url = "Mod/CodePku/cellar/World/PrestrainImage.html",
        name = "paracraft.DownloadWorld",
        isShowTitleBar = false,
        DestroyOnClose = true,
        style = CommonCtrl.WindowFrame.ContainerStyle,
        zorder = 10,
        allowDrag = true,
        isTopLevel = true,
        directPosition = true,
            align = "_ct",
            x = -width/2,
            y = -height/2,
            width = width,
            height = height,
        cancelShowAnimation = true,
    });
end