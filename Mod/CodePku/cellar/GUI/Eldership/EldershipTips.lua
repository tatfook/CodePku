--[[
NPL.load("(gl)Mod/CodePku/cellar/GUI/Eldership/EldershipTips.lua")
local EldershipTips = commonlib.gettable("Mod.CodePku.EldershipTips")
]]
NPL.load("(gl)Mod/CodePku/cellar/GUI/Eldership/Eldership.lua")

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow");

local EldershipTips = commonlib.gettable("Mod.CodePku.EldershipTips")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")

EldershipTips.ui = nil

function EldershipTips.OnSureBtnClicked()
    if EldershipTips.ui then
        EldershipTips.ui:CloseWindow()
    end
    local Eldership = NPL.load("(gl)Mod/CodePku/cellar/GUI/Eldership/Eldership.lua");
    Eldership:ShowPage(31);
end

function EldershipTips.OnCancelBtnClicked()
    if EldershipTips.ui then
        EldershipTips.ui:CloseWindow()
    end
end

-- 获取图片
function EldershipTips:GetIconPath(index)
    return common1ImageData:GetIconUrl(index)
end

-- 权限不足绑定微信弹窗
function EldershipTips:ShowEditNameTips()
    local params = {
        url = "Mod/CodePku/cellar/GUI/Eldership/EditNameEldershipTips.html",
        name = "EditNameEldershipTips",
        DestroyOnClose = true,
        allowDrag = false,
        enable_esc_key = true,
        alignment="_ct",
        left = -960,
        top = -510,
        width = 1920,
        height = 1080,
        zorder = 31,
    }
    if EldershipTips.ui then
        EldershipTips.ui:CloseWindow()
    end
    EldershipTips.ui = AdaptWindow:QuickWindow(params)
    
end