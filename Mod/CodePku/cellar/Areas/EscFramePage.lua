local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local CodePkuEscFramePage = NPL.export()
local escFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/escFrameImageData.lua")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")


function CodePkuEscFramePage:GetIcon(type, index)
    if type == 1 then
        return common1ImageData:GetIconUrl(index)
    elseif type == 2 then
        return escFrameImageData:GetIconUrl(index)
    end
end

function CodePkuEscFramePage:ShowPage(bShow)
    local params = {
        url = "Mod/CodePku/cellar/Areas/EscFramePage.html", 
        name = "EscFramePage.ShowPage",
        isShowTitleBar = false,
        DestroyOnClose = true,
        bToggleShowHide=true, 
        style = CommonCtrl.WindowFrame.ContainerStyle,
        allowDrag = false,
        enable_esc_key = true,
        bShow = bShow,
        click_through = false, 
        zorder = 1000,
        app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
        directPosition = true,
        align = "_lt",
        x = 0,
        y = 0,
        width = 1920,
        height = 1080,
    };
    if CodePkuEscFramePage.window then
        CodePkuEscFramePage.window:CloseWindow()
        CodePkuEscFramePage.window = nil
    else
        CodePkuEscFramePage.window = AdaptWindow:QuickWindow(params)
    end
end