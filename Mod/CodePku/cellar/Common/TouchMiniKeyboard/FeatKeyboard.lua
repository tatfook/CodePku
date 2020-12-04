--功能按钮
--author:John mai
--date: 2020-05-29 15:55:40
NPL.load("(gl)script/ide/System/Windows/Screen.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchSession.lua")
NPL.load("(gl)script/ide/System/Windows/Keyboard.lua")
NPL.load("(gl)script/ide/System/Windows/Mouse.lua")
local Mouse = commonlib.gettable("System.Windows.Mouse")
local Keyboard = commonlib.gettable("System.Windows.Keyboard")
local TouchSession = commonlib.gettable("MyCompany.Aries.Game.Common.TouchSession")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local Screen = commonlib.gettable("System.Windows.Screen")

local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");
local Table = NPL.load("(gl)Mod/CodePku/util/Table.lua");
local Design = NPL.load("(gl)Mod/CodePku/util/Design.lua");
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")

local FeatKeyboard = commonlib.inherit(
        commonlib.gettable("System.Core.ToolBase"),
        commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard")
);

FeatKeyboard.align = "_lt";
FeatKeyboard.zorder = -10;
FeatKeyboard.colors = { normal = "#ffffff", pressed = "#888888" };

function FeatKeyboard:ctor()

end

--单例实例化
local newInstance;
function FeatKeyboard.getSingleton()
    if (not newInstance) then
        newInstance = FeatKeyboard:new():init()
    end
    return newInstance
end

function FeatKeyboard:init()
    local jumpBtn = self:getJumpBtn();
    local fBtn = self:getFlyBtn();
    local xBtn = self:getAltBtn();
    local shiftBtn = self:getShiftBtn();
    local chatBtn = self:getChatBtn();

    jumpBtn.visible = false;
    fBtn.visible = false;
    xBtn.visible = false;
    shiftBtn.visible = false;
    chatBtn.visible = false;

    return self;
end

function FeatKeyboard:show(show, jumpBtnShow, fBtnShow, xBtnShow, shiftBtnShow, chatBtnShow)
    local jumpBtn = self:getJumpBtn();
    local fBtn = self:getFlyBtn();
    local xBtn = self:getAltBtn();
    local shiftBtn = self:getShiftBtn();
    -- local zoomBtn = self:getZoomBtn();
    local chatBtn = self:getChatBtn();

    show = not not show;

    jumpBtn.visible = false;
    fBtn.visible = false;
    xBtn.visible = false;
    shiftBtn.visible = false;
    chatBtn.visible = false;

    ParaUI.GetUIObject("jump").visible = false;
    ParaUI.GetUIObject("FLY").visible = false;
    ParaUI.GetUIObject("AltBtn").visible = false;
    ParaUI.GetUIObject("ShiftBtn").visible = false;
    ParaUI.GetUIObject("Chat").visible = false;

    if show then
        jumpBtn.visible = jumpBtnShow;
        fBtn.visible = fBtnShow;
        xBtn.visible = xBtnShow;
        shiftBtn.visible = shiftBtnShow;
        -- zoomBtn.visible = zoomBtnShow;
        chatBtn.visible = chatBtnShow;
        -- ParaUI.GetUIObject

        ParaUI.GetUIObject("jump").visible = jumpBtnShow;
        ParaUI.GetUIObject("FLY").visible = fBtnShow;
        ParaUI.GetUIObject("AltBtn").visible = xBtnShow;
        ParaUI.GetUIObject("ShiftBtn").visible = shiftBtnShow;
        ParaUI.GetUIObject("Chat").visible = chatBtnShow;
    end
end

--创建跳跃按钮
function FeatKeyboard:getJumpBtn()

    local name = "jump";

    local button = ParaUI.GetUIObject(name);

    local left = Design:adapterWidth(1594);
    local top = Design:adapterHeight(845);
    local width = Design:adapterWidth(134);
    local height = Design:adapterWidth(134);

    if not button:IsValid() then
        button = ParaUI.CreateUIObject(
                "button",
                name,
                self.align,
                left,
                top,
                width,
                height
        );

        button.background = mainFrameImageData:GetIconUrl("main_icon_tiao.png");
        _guihelper.SetUIColor(button, self.colors.normal);
        button.enabled = true;
        button.zorder = self.zorder;
        button:SetScript("ontouch", function()
            Keyboard:SendKeyEvent("keyDownEvent", DIK_SCANCODE.DIK_SPACE);
            _guihelper.SetUIColor(button, self.colors.pressed);

            commonlib.TimerManager.SetTimeout(function()
                Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_SPACE);
                _guihelper.SetUIColor(button, self.colors.normal);
            end, 300)
        end)
        button:SetScript("ontouch", function() self:handleTouch(msg) end)
		button:SetScript("onmousedown", function() self:handleMouseDown() end)
		button:SetScript("onmouseup", function() self:handleMouseUp() end)
		button:SetScript("onmousemove", function() self:handleMouseMove() end)

        button:AttachToRoot();
    else
        button:Reposition(self.align, left, top, width, height);
    end

    return button;
end

--创建 F(飞行) 按钮
function FeatKeyboard:getFlyBtn()
    local name = "FLY";

    local button = ParaUI.GetUIObject(name);

    local left = Design:adapterWidth(1711);
    local top = Design:adapterHeight(649);
    local width = Design:adapterWidth(134);
    local height = Design:adapterWidth(134);

    if not button:IsValid() then
        button = ParaUI.CreateUIObject(
                "button",
                name,
                self.align,
                left,
                top,
                width,
                height
        );

        button.background = mainFrameImageData:GetIconUrl("main_icon_fly.png");
        _guihelper.SetUIColor(button, self.colors.normal);
        button.enabled = true;
        button.zorder = self.zorder;
        button:SetScript("onclick", function()
            Keyboard:SendKeyEvent("keyDownEvent", DIK_SCANCODE.DIK_F);
            _guihelper.SetUIColor(button, self.colors.pressed);

            commonlib.TimerManager.SetTimeout(function()
                Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_F);
                _guihelper.SetUIColor(button, self.colors.normal);
            end, 300)
        end)

        button:AttachToRoot();
    else
        button:Reposition(self.align, left, top, width, height);
    end

    return button;
end

function FeatKeyboard:Destroy()
    FeatKeyboard._super.Destroy(self)
    ParaUI.Destroy("zoom-container")
    ParaUI.Destroy("Shift")
    ParaUI.Destroy("X")
    ParaUI.Destroy("F")
    ParaUI.Destroy("jump")
end
