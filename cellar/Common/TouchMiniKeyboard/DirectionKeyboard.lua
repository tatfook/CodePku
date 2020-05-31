--方向控制键盘
--author: John Mai
--date: 2020-05-29 10:19:30

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

local DirectionKeyboard = commonlib.inherit(
        commonlib.gettable("System.Core.ToolBase"),
        commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionKeyboard")
);

DirectionKeyboard.name = "DIRECTION_KEYBOARD";
DirectionKeyboard.clickRate = 500;
DirectionKeyboard.align = "_lt";
DirectionKeyboard.zorder = -10;
DirectionKeyboard.colors = { normal = "#ffffff", pressed = "#888888" };

--默认键盘布局
DirectionKeyboard.defaultKeyLayout = {
    {
        name = "up",
        background = "textures/up_btn.png",
        left = 100,
        top = 0,
        width = 100,
        height = 100,
        key = DIK_SCANCODE.DIK_W,
    },
    {
        name = "down",
        background = "textures/down_btn.png",
        left = 100,
        top = 200,
        width = 100,
        height = 100,
        key = DIK_SCANCODE.DIK_S,
    },
    {
        name = "left",
        background = "textures/left_btn.png",
        left = 0,
        top = 100,
        width = 100,
        height = 100,
        key = DIK_SCANCODE.DIK_A,
    },
    {
        name = "right",
        background = "textures/right_btn.png",
        left = 200,
        top = 100,
        width = 100,
        height = 100,
        key = DIK_SCANCODE.DIK_D,
    },
    {
        name = "center",
        background = "textures/center_btn.png",
        left = 105,
        top = 105,
        width = 90,
        height = 90,
        key = nil,
    }
}

function DirectionKeyboard:ctor()

end

--单例实例化
local newInstance;
function DirectionKeyboard.getSingleton()
    if (not newInstance) then
        newInstance = DirectionKeyboard:new():init()
    end
    return newInstance
end

--初始化渲染键盘
function DirectionKeyboard:init()
    local container = self:getContainer();
    container:RemoveAll();
    container.visible = false;
    for _, item in ipairs(self.defaultKeyLayout) do
        if item.name then
            item.width = Design:adapterWidth(item.width);
            item.height = Design:adapterHeight(item.height);

            item.left = Design:adapterWidth(item.left);
            item.right = item.width + item.left;

            item.top = Design:adapterHeight(item.top);
            item.bottom = item.height + item.top;

            local button = ParaUI.CreateUIObject(
                    "button",
                    item.name,
                    "_lt",
                    item.left,
                    item.top,
                    item.width,
                    item.height
            );

            button.background = item.background;
            button.enabled = false;
            _guihelper.SetUIColor(button, "#FFFFFF");
            container:AddChild(button);
        end
    end

    return self;
end

function DirectionKeyboard:checkShow()
    DirectionKeyboard.getSingleton():show(show)
end

--控制显示方向键盘
function DirectionKeyboard:show(show)
    local container = self:getContainer();
    if show == nil then
        show = not container.visible;
    end
    container.visible = show;
end

--获取键盘容器
function DirectionKeyboard:getContainer()
    local container = ParaUI.GetUIObject(self.id or self.name);
    self.left = Design:adapterWidth(100);
    self.top = Screen:GetHeight() - Design:adapterHeight(400);
    self.width = Design:adapterWidth(300);
    self.height = Design:adapterHeight(300);

    if not container:IsValid() then
        container = ParaUI.CreateUIObject("container", self.name, self.align, self.left, self.top, self.width, self.height);
        container.background = "";
        container:AttachToRoot();

        container.zorder = self.zorder;

        container:SetScript(
                "ontouch",
                function()
                    self:handleTouch();
                end
        )
        container:SetScript(
                "onmousedown",
                function()
                    self:handleMouseDown();
                end
        )
        container:SetScript(
                "onmouseup",
                function()
                    self:handleMouseUp();
                end
        )
        container:SetScript(
                "onmousemove",
                function()
                    self:handleMouseMove();
                end
        )

        self.id = container.id;
    else
        container:Reposition(self.align, self.left, self.top, self.width, self.height);
    end

    return container;
end

--处理鼠标移动事件
function DirectionKeyboard:handleMouseMove()
    local touch = { type = "WM_POINTERUPDATE", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理鼠标点击事件
function DirectionKeyboard:handleMouseDown()
    local touch = { type = "WM_POINTERDOWN", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理鼠标弹起事件
function DirectionKeyboard:handleMouseUp()
    local touch = { type = "WM_POINTERUP", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理触摸事件
function DirectionKeyboard:handleTouch(touch)
    local touchSession = TouchSession.GetTouchSession(touch);
    local button = self:getButtonItem(touch.x, touch.y);

    if touch.type == "WM_POINTERDOWN" then
        if button then
            touchSession:SetField("keydownBtn", button);
            self:updateButtonState(button, true);
        end
    elseif touch.type == "WM_POINTERUP" then
        local keydownBtn = touchSession:GetField("keydownBtn");
        if keydownBtn then
            self:updateButtonState(button, false);
        end
    end
end

--获取当前坐标的按钮对象
function DirectionKeyboard:getButtonItem(x, y)
    x = x - self.left;
    y = y - self.top;
    for _, item in ipairs(self.defaultKeyLayout) do
        if (item.top and item.top <= y and y <= item.bottom and item.left <= x and x <= item.right) then
            return item;
        end
    end
end

--更新 & 发送键盘指令
function DirectionKeyboard:updateButtonState(button, isPressed)
    local container = self:getContainer();
    local buttonUI = container:GetChild(button.name);
    button.isPressed = isPressed;
    if isPressed then
        _guihelper.SetUIColor(buttonUI, self.colors.pressed);
    else
        _guihelper.SetUIColor(buttonUI, self.colors.normal);
    end

    if button.onlyClick then
        if not isPressed then
            self:emitKeyEvent(button, true);
            self:emitKeyEvent(button, false);
        end
    else
        self:emitKeyEvent(button, isPressed);
    end
end

--发送键盘指令
function DirectionKeyboard:emitKeyEvent(button, isPressed)
    if button.key then
        Keyboard:SendKeyEvent(isPressed and "keyDownEvent" or "keyUpEvent", button.key);
    end
end

