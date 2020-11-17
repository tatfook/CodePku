--[[usage:
local InviteCode = NPL.load("(gl)Mod/CodePku/cellar/GUI/InviteCode/InviteCode.lua")
--]]
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");
local InviteCode = NPL.export();

local inviteImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/inviteImageData.lua")
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")

function InviteCode.GetIconUrl(iconName)
    if iconName == 'main_icon_coin_1.png' or iconName == 'main_icon_coin_2.png' or iconName == 'main_friends_call.png' then
        return mainFrameImageData:GetIconUrl(iconName)
    else
        echo(string.format("InviteCode.GetIconUrl: %s",inviteImageData:GetIconUrl(iconName)))
        return inviteImageData:GetIconUrl(iconName)
    end
end

function InviteCode:ShowPage()
    local params = {
        url = "Mod/CodePku/cellar/GUI/InviteCode/InviteCodePage.html",
        alignment = "_ct",
        x = -960,
        y = -540,
        width = 1920,
        height = 1080,
        zorder = 31,
        }

    AdaptWindow:QuickWindow(params)
end
