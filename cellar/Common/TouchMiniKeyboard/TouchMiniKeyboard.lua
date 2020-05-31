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

--设计图原始尺寸
local WidthDesign = 1920;
local HeightDesign = 1080;

--屏幕尺寸
local WidthScreen = Screen:GetWidth();
local HeightScreen = Screen:GetHeight();

--设计图与屏幕对比率
local WidthContrast = WidthScreen / WidthDesign;
local HeightContrast = HeightScreen / HeightDesign;

local TouchMiniKeyboard = commonlib.inherit(
        commonlib.gettable("System.Core.ToolBase"),
        commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard")
)
TouchMiniKeyboard:Property("Name", "TouchMiniKeyboard")

TouchMiniKeyboard.hover_press_hold_time = 500

TouchMiniKeyboard.DefaultKeyLayout = {
    {
        name = "up",
        background = "textures/keyboard/up_btn.png",
        left = 100,
        top = 0,
        width = 100,
        height = 100,
        vKey = DIK_SCANCODE.DIK_W,
        flyUpDown = true,
        click_only = true
    },
    {
        name = "down",
        background = "textures/keyboard/down_btn.png",
        left = 100,
        top = 200,
        width = 100,
        height = 100,
        vKey = DIK_SCANCODE.DIK_S,
        flyUpDown = true,
        click_only = true
    },
    {
        name = "left",
        background = "textures/keyboard/left_btn.png",
        left = 0,
        top = 100,
        width = 100,
        height = 100,
        vKey = DIK_SCANCODE.DIK_A,
        flyUpDown = true,
        click_only = true
    },
    {
        name = "right",
        background = "textures/keyboard/right_btn.png",
        left = 200,
        top = 100,
        width = 100,
        height = 100,
        vKey = DIK_SCANCODE.DIK_F,
        flyUpDown = true,
        click_only = true
    },
    {
        name = "center",
        background = "textures/keyboard/center_btn.png",
        left = 105,
        top = 105,
        width = 90,
        height = 90,
        vKey = nil,
        flyUpDown = true,
        click_only = true
    }
}

function TouchMiniKeyboard:ctor()
    self.alignment = "_lt";
    self.zorder = -10;
    self.colors = { normal = "#ffffff", pressed = "#888888" };
    self.finger_size = 10;
    self.transparency = 1;

    self.keylayout = TouchMiniKeyboard.DefaultKeyLayout
end

--单例实例化
local newInstance
function TouchMiniKeyboard.getSingleton()
    if (not newInstance) then
        newInstance = TouchMiniKeyboard:new():init()
    end
    return newInstance
end

--初始化虚拟按钮
function TouchMiniKeyboard:init()
    self:Create();
    return self;
end

function TouchMiniKeyboard.checkShow(show)
    TouchMiniKeyboard.getSingleton():show(show)
end

function TouchMiniKeyboard:show(show)
    local directionContainer = self:getDirectionContainer();
    if (show == nil) then
        show = not directionContainer.visible;
    end
    directionContainer.visible = show;
end

--创建按钮
function TouchMiniKeyboard:create()
    local directionContainer = self:getDirectionContainer();
    directionContainer:RemoveAll();
    directionContainer.visible = false;

    for _, item in ipairs(self.keylayout) do
        if (item.name) then
            item.width = item.width * WidthContrast;
            item.height = item.height * HeightContrast;
            item.left = item.left * WidthContrast;
            item.top = item.top * HeightContrast;

            local button = ParaUI.CreateUIObject(
                    "button",
                    item.name,
                    "_lt",
                    item.left,
                    item.top,
                    item.width,
                    item.height
            )
            button.background = item.background;
            button.enabled = false;
            _guihelper.SetUIColor(button, "#FFFFFF")
            directionContainer:AddChild(button)
        end
    end
end

function TouchMiniKeyboard:Destroy()
    TouchMiniKeyboard._super.Destroy(self)
    ParaUI.Destroy(self.id or self.name)
    self.id = nil
end

function TouchMiniKeyboard:SetTransparency(alpha)
    if (self.transparency ~= alpha) then
        self.transparency = alpha
        local _parent = self:GetUIControl()
        _guihelper.SetColorMask(_parent, format("255 255 255 %d", math.floor(alpha * 255)))
        _parent:ApplyAnim()
    end
    return self
end

TouchMiniKeyboard.DirectionName = "DIRECTION";

--方向键容器
function TouchMiniKeyboard:getDirectionContainer()

    local container = ParaUI.GetUIObject(self.directionId or self.DirectionName);

    local left = WidthContrast * 100;
    local top = HeightScreen - (HeightContrast * 400);
    local width = WidthContrast * 300;
    local height = HeightContrast * 300;

    if (not container:IsValid()) then
        container = ParaUI.CreateUIObject("container", self.DirectionName, self.alignment, left, top, width, height);
        container.background = "";
        container:AttachToRoot();
        container.zorder = self.zorder;

        container:SetScript(
                "ontouch",
                function()
                    self:OnTouch(msg)
                end
        )
        container:SetScript(
                "onmousedown",
                function()
                    self:OnMouseDown()
                end
        )
        container:SetScript(
                "onmouseup",
                function()
                    self:OnMouseUp()
                end
        )
        container:SetScript(
                "onmousemove",
                function()
                    self:OnMouseMove()
                end
        )
        self.directionId = container.id;
    else
        container:Reposition(self.alignment, left, top, width, height);
    end

    return container;
end

function TouchMiniKeyboard:GetUIControl()
    local _parent = ParaUI.GetUIObject(self.id or self.name)

    if (not _parent:IsValid()) then
        _parent = ParaUI.CreateUIObject("container", self.name, self.alignment, self.left, self.top, self.width, self.height)
        _parent.background = ""
        _parent:AttachToRoot()
        _parent.zorder = self.zorder
        _parent:SetScript(
                "ontouch",
                function()
                    self:OnTouch(msg)
                end
        )
        _parent:SetScript(
                "onmousedown",
                function()
                    self:OnMouseDown()
                end
        )
        _parent:SetScript(
                "onmouseup",
                function()
                    self:OnMouseUp()
                end
        )
        _parent:SetScript(
                "onmousemove",
                function()
                    self:OnMouseMove()
                end
        )

        self.id = _parent.id
    else
        _parent:Reposition(self.alignment, 0, 0, WidthScreen, HeightScreen)
    end
    return _parent
end

-- simulate the touch event with id=-1
function TouchMiniKeyboard:OnMouseDown()
    local touch = { type = "WM_POINTERDOWN", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:OnTouch(touch)
end

-- simulate the touch event
function TouchMiniKeyboard:OnMouseUp()
    local touch = { type = "WM_POINTERUP", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:OnTouch(touch)
end

-- simulate the touch event
function TouchMiniKeyboard:OnMouseMove()
    local touch = { type = "WM_POINTERUPDATE", x = mouse_x, y = mouse_y, id = -1, time = 0 }
    self:OnTouch(touch)
end

-- handleTouchEvent
function TouchMiniKeyboard:OnTouch(touch)
    -- handle the touch
    local touch_session = TouchSession.GetTouchSession(touch)

    local btnItem = self:GetButtonItem(touch.x, touch.y)
    -- let us track it with an item.
    if (touch.type == "WM_POINTERDOWN") then
        if (btnItem) then
            touch_session:SetField("keydownBtn", btnItem)
            self:SetKeyState(btnItem, true)
            btnItem.isDragged = nil
            if (btnItem.camera_zoom) then
                touch_session:SetField("cameraDist", GameLogic.options:GetCameraObjectDistance())
            elseif (btnItem.flyUpDown) then
                local focus_entity = EntityManager.GetFocus()
                if (focus_entity) then
                    local x, y, z = focus_entity:GetPosition()
                    touch_session:SetField("cameraPosY", y)
                end
            end
        end
    elseif (touch.type == "WM_POINTERUPDATE") then
        local keydownBtn = touch_session:GetField("keydownBtn")
        if (keydownBtn and touch_session:IsDragging()) then
            keydownBtn.isDragged = true
            local dx, dy = touch_session:GetOffsetFromStartLocation()

            if (keydownBtn.camera_zoom) then
                local cameraStartDist = touch_session:GetField("cameraDist")
                if (cameraStartDist) then
                    local delta
                    local fingerSize = touch_session:GetFingerSize()
                    if (dy >= 0) then
                        delta = (dy + fingerSize * 5) / (fingerSize * 5)
                    else
                        delta = (fingerSize * 5) / (-dy + fingerSize * 5)
                    end
                    GameLogic.options:SetCameraObjectDistance(cameraStartDist * delta)
                end
            elseif (keydownBtn.flyUpDown) then
                local cameraPosY = touch_session:GetField("cameraPosY")
                if (cameraPosY) then
                    local fingerSize = touch_session:GetFingerSize()
                    local delta = dy / fingerSize
                    local focus_entity = EntityManager.GetFocus()
                    if (focus_entity and not focus_entity:IsControlledExternally()) then
                        keydownBtn.delta = delta
                        if (not keydownBtn.timer) then
                            keydownBtn.timer = commonlib.Timer:new(
                                    {
                                        callbackFunc = function(timer)
                                            focus_entity:MoveEntityByDisplacement(0, -keydownBtn.delta * 0.02, 0)
                                        end
                                    }
                            )
                            keydownBtn.timer:Change(0, 30)
                        end
                    end
                end
            end
            keydownBtn.hover_testing_btn = btnItem
            -- finger is hovering another button instead of the initial button.
            if (btnItem and btnItem ~= keydownBtn) then
                if (not keydownBtn.auto_mouseup and btnItem.allow_hover_press and not btnItem.isKeyDown) then
                    if (not btnItem.hover_press_start) then
                        btnItem.hover_press_start = true
                        if (not btnItem.timer) then
                            btnItem.timer = commonlib.Timer:new(
                                    {
                                        callbackFunc = function(timer)
                                            if (keydownBtn.isKeyDown and keydownBtn.hover_testing_btn == btnItem) then
                                                keydownBtn.hover_press_btns = keydownBtn.hover_press_btns or {}
                                                keydownBtn.hover_press_btns[btnItem] = true
                                                self:SetKeyState(btnItem, true)
                                            end
                                        end
                                    }
                            )
                            btnItem.timer:Change(self.hover_press_hold_time)
                        end
                    end
                elseif (keydownBtn.auto_mouseup and btnItem.auto_mouseup) then
                    if (keydownBtn.isKeyDown) then
                        self:SetKeyState(keydownBtn, false)
                        touch_session:SetField("keydownBtn", btnItem)
                        self:SetKeyState(btnItem, true)
                    end
                end
            end
        end
    elseif (touch.type == "WM_POINTERUP") then
        local keydownBtn = touch_session:GetField("keydownBtn")
        if (keydownBtn) then
            if (keydownBtn.name == "Ctrl" and btnItem and btnItem.ctrl_name) then
                -- do a combo key.
                -- TODO: find a better way to send the actual key, instead of calling command directly.

                NPL.load("(gl)script/apps/Aries/Creator/Game/Tasks/UndoManager.lua")
                local UndoManager = commonlib.gettable("MyCompany.Aries.Game.UndoManager")
                local GameLogic = commonlib.gettable("MyCompany.Aries.Game.GameLogic")
                local GameMode = commonlib.gettable("MyCompany.Aries.Game.GameLogic.GameMode")

                if (btnItem.ctrl_name == "S") then
                    GameLogic.QuickSave()
                elseif (btnItem.ctrl_name == "Y") then
                    if (GameMode:IsAllowGlobalEditorKey()) then
                        UndoManager.Redo()
                    end
                elseif (btnItem.ctrl_name == "Z") then
                    if (GameMode:IsAllowGlobalEditorKey()) then
                        UndoManager.Undo()
                    end
                end
            end
            self:SetKeyState(keydownBtn, false)
        end
    end
end

function TouchMiniKeyboard:GetRightMouseButtonItem()
    return self.keylayout[1]
end

function TouchMiniKeyboard:GetCtrlKey()
    return self.keylayout[1]
end

function TouchMiniKeyboard:SetKeyState(btnItem, isDown)
    local parent = self:GetUIControl()
    local keyBtn = parent:GetChild(btnItem.name)
    btnItem.isKeyDown = isDown
    if (isDown) then
        -- key down event
        _guihelper.SetUIColor(keyBtn, self.colors[btnItem.colorid or 1].pressed)
    else
        -- key up event
        _guihelper.SetUIColor(keyBtn, self.colors[btnItem.colorid or 1].normal)
        btnItem.hover_press_start = nil

        local hover_press_btns = btnItem.hover_press_btns
        if (hover_press_btns) then
            btnItem.hover_press_btns = nil
            -- fire mouse up for all hover press btns
            for btn, _ in pairs(hover_press_btns) do
                self:SetKeyState(btn, false)
            end
        end

        if (btnItem.timer) then
            btnItem.timer:Change()
            btnItem.timer = nil
        end
        btnItem.hover_testing_btn = nil
    end

    if (btnItem.name == "Ctrl") then

        for _, item in ipairs(self.keylayout) do
            if (item.ctrl_name) then
                local keyBtn = parent:GetChild(item.name)
                if (isDown) then
                    keyBtn.text = item.ctrl_name
                    _guihelper.SetUIColor(keyBtn, self.colors[3].normal)
                else
                    keyBtn.text = self:GetItemDisplayText(item)
                    _guihelper.SetUIColor(keyBtn, self.colors[item.colorid or 1].normal)
                end
            end
        end

    end

    if (btnItem.toggleRightMouseButton) then
        local toggleMouseBtn = self:GetRightMouseButtonItem()
        if (toggleMouseBtn and toggleMouseBtn ~= btnItem) then
            local keyBtn = parent:GetChild(toggleMouseBtn.name)
            if (isDown) then
                _guihelper.SetUIColor(keyBtn, self.colors[toggleMouseBtn.colorid or 1].pressed)
            else
                _guihelper.SetUIColor(keyBtn, self.colors[toggleMouseBtn.colorid or 1].normal)
            end
        end
        Mouse:SetTouchButtonSwapped(isDown)
    end

    if (btnItem.click_only) then
        -- only send click event
        if (not isDown and not btnItem.isDragged) then
            self:SendRawKeyEvent(btnItem, true)
            self:SendRawKeyEvent(btnItem, false)
        end
    else
        self:SendRawKeyEvent(btnItem, isDown)
    end
end

function TouchMiniKeyboard:SendRawKeyEvent(btnItem, isDown)
    if (btnItem.vKey) then
        Keyboard:SendKeyEvent(isDown and "keyDownEvent" or "keyUpEvent", btnItem.vKey)
    end
end

function TouchMiniKeyboard:GetItemDisplayText(item, bFnPressed, bShiftPressed)
    if (item.name) then
        if (item.name2) then
            return format("%s\n%s", item.name2, item.name)
        else
            return item.name
        end
    end
    return
end

-- get button item by global touch screen position.
function TouchMiniKeyboard:GetButtonItem(x, y)
    x = x - self.left
    y = y - self.top
    for _, item in ipairs(self.keylayout) do
        if (item.top and item.top <= y and y <= item.bottom and item.left <= x and x <= item.right) then
            return item
        end
    end
end

function TouchMiniKeyboard:getDirectionBtn(x, y)

end


