--方向控制摇杆
--author: NieXX

--local DirectionRocker = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionRocker");
-- local DirectionRocker = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionRocker");

NPL.load("(gl)script/ide/System/Windows/Screen.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchSession.lua")
NPL.load("(gl)script/ide/System/Windows/Keyboard.lua")
NPL.load("(gl)script/ide/System/Windows/Mouse.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Commands/CommandManager.lua");
NPL.load("(gl)script/ide/UIAnim/UIAnimManager.lua");
local CommandManager = commonlib.gettable("MyCompany.Aries.Game.CommandManager");   
local Mouse = commonlib.gettable("System.Windows.Mouse")
local Keyboard = commonlib.gettable("System.Windows.Keyboard")
local TouchSession = commonlib.gettable("MyCompany.Aries.Game.Common.TouchSession")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local Screen = commonlib.gettable("System.Windows.Screen")

local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");
local Table = NPL.load("(gl)Mod/CodePku/util/Table.lua");
local Design = NPL.load("(gl)Mod/CodePku/util/Design.lua");

local DirectionRocker = commonlib.inherit(commonlib.gettable("System.Core.ToolBase"),
    commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionRocker"));
local mainFrameImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/mainFrameImageData.lua")

DirectionRocker.isMovable = false;
DirectionRocker.name = "DIRECTION_KEYBOARD_ROCKER";
DirectionRocker.clickRate = 500;
DirectionRocker.align = "_lt";
DirectionRocker.zorder = -10;
DirectionRocker.colors = { normal = "#ffffff", pressed = "#888888" };
DirectionRocker.outterRadius = Design:adapterWidth(222);-- 最外圈半径
DirectionRocker.middleRadius = Design:adapterWidth(147);-- 中间圈半径 TODO
DirectionRocker.innerRadius = 67; -- 可拖动块的半径
DirectionRocker.containerLeft = Design:adapterWidth(222)
DirectionRocker.containerTop = Screen:GetHeight() - Design:adapterWidth(479)
-- DirectionRocker.containerTop = Design:adapterWidth(601)
-- DirectionRocker.originX = Design:adapterWidth(100) + DirectionRocker.outterRadius;
-- DirectionRocker.originY = Screen:GetHeight() - Design:adapterWidth(400) + DirectionRocker.outterRadius;
DirectionRocker.originX = DirectionRocker.containerLeft + DirectionRocker.outterRadius;
DirectionRocker.originY = DirectionRocker.containerTop + DirectionRocker.outterRadius;
DirectionRocker.startX = 0
DirectionRocker.startY = 0


--默认键盘布局
DirectionRocker.defaultKeyLayout = {
    {
        name = "center",
        background = mainFrameImageData:GetIconUrl("main_wheel.png"),
        left = 222-67,
        top = 222-67,
        width = 134,
        height = 134,
        key = nil,
    }
}

function DirectionRocker:ctor()
end

--单例实例化
local newInstance;
function DirectionRocker.getSingleton()
    if (not newInstance) then
        newInstance = DirectionRocker:new():init()
    end
    return newInstance
end

--初始化渲染键盘
function DirectionRocker:init()
    local container = self:getContainer();
    container:RemoveAll();
    container.visible = false;
    for _, item in ipairs(self.defaultKeyLayout) do
        if item.name then
            item.width = Design:adapterWidth(item.width);
            item.height = Design:adapterWidth(item.height);

            item.left = Design:adapterWidth(item.left);
            item.right = item.width + item.left;

            item.top = Design:adapterWidth(item.top);
            item.bottom = item.height + item.top;

            local button = ParaUI.CreateUIObject("button",
                item.name,
                "_lt",
                item.left,
                item.top,
                item.width,
                item.height);

            button.background = item.background;
            button.enabled = false;
            _guihelper.SetUIColor(button, "#FFFFFF");
            container:AddChild(button);
        end
    end

    return self;
end

function DirectionRocker:checkShow()
    DirectionRocker.getSingleton():show(show)
end

--控制显示方向键盘
function DirectionRocker:show(show)
    local container = self:getContainer();
    if show == nil then
        show = not container.visible;
    end
    container.visible = show;
end

--获取键盘容器
function DirectionRocker:getContainer()
    local container = ParaUI.GetUIObject(self.id or self.name);
    -- self.left = Design:adapterWidth(100);
    -- self.top = Screen:GetHeight() - Design:adapterWidth(400);
    self.left = DirectionRocker.containerLeft;
    self.top = DirectionRocker.containerTop;
    -- self.width = Design:adapterWidth(300);
    -- self.height = Design:adapterWidth(300);
    self.width = DirectionRocker.outterRadius * 2;
    self.height = DirectionRocker.outterRadius * 2;

    if not container:IsValid() then
        container = ParaUI.CreateUIObject("container", self.name, self.align, self.left, self.top, self.width, self.height);
        container.background = mainFrameImageData:GetIconUrl("main_wheel_bot.png");
        container:AttachToRoot();

        container.zorder = self.zorder;

        container:SetScript("ontouch",
            function()
                self:handleTouch(msg);
            end);

        container:SetScript("onmousedown",
            function()
                self:handleMouseDown();
            end);

        container:SetScript("onmouseup",
            function()
                self:handleMouseUp();
            end);

        container:SetScript("onmousemove",
            function()
                self:handleMouseMove();
            end);

        self.id = container.id;
    else
        container:Reposition(self.align, self.left, self.top, self.width, self.height);
    end

    return container;
end

--处理鼠标移动事件
function DirectionRocker:handleMouseMove()
    local touch = { type = "WM_POINTERUPDATE", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理鼠标点击事件
function DirectionRocker:handleMouseDown()
    local touch = { type = "WM_POINTERDOWN", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理鼠标弹起事件
function DirectionRocker:handleMouseUp()
    local touch = { type = "WM_POINTERUP", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理鼠标其他事件
function DirectionRocker:handleOther()
    local touch = { type = "OTHER", x = mouse_x, y = mouse_y, id = -1, time = 0 };
    self:handleTouch(touch);
end

--处理触摸事件
function DirectionRocker:handleTouch(touch)
    local touchSession = TouchSession.GetTouchSession(touch);
    local button = self:getButtonItem(touch.x, touch.y);
    -- echo(touch)
    if touch.type == "WM_POINTERDOWN" then
        if button then
            touchSession:SetField("keydownBtn", button);
            self:updateButtonState(button, true);
            self:HandleAnim(button, touch, touch.type)
            button.isDragged = nil;
        end
    elseif touch.type == "WM_POINTERUP" then
        local keydownBtn = touchSession:GetField("keydownBtn");
        if keydownBtn then
            self:updateButtonState(keydownBtn, false);
            self:HandleAnim(keydownBtn, touch, touch.type)
        end
    elseif touch.type == "WM_POINTERUPDATE" then
        local keydownBtn = touchSession:GetField("keydownBtn");

        if keydownBtn then
            keydownBtn.isDragged = true;

            if button and button ~= keydownBtn then
                if keydownBtn.isPressed then
                    self:updateButtonState(keydownBtn, false);
                end

                touchSession:SetField("keydownBtn", button);
                self:updateButtonState(button, true);
            end
            self:HandleAnim(keydownBtn, touch, touch.type) 
        else
            if button then
                touchSession:SetField("keydownBtn", button);
                self:updateButtonState(button, true);
            end
        end
    end
end


--获取当前坐标的按钮对象
function DirectionRocker:getButtonItem(x, y)
    x = x - self.left;
    y = y - self.top;
    for _, item in ipairs(self.defaultKeyLayout) do
        if (item.top and item.top <= y and y <= item.bottom and item.left <= x and x <= item.right) then
            return item;
        end
    end
end

function DirectionRocker:HandleAnim(button, touch, touchtype)
    local buttonObj = ParaUI.GetUIObject(button.name);
    -- echo(buttonObj)

    local block = UIDirectAnimBlock:new();
    block:SetUIObject(buttonObj);
    block:SetTime(0);

    if(touchtype == "WM_POINTERUP") then
        DirectionRocker.isMovable = false
        CommandManager:Init();
        CommandManager:RunCommand("/speedscale 1");
        echo("----isMovable in up-----")
        echo(DirectionRocker.isMovable)
        -- block:SetXRange(0, Design:adapterWidth(300)*0.5-button.width*0.5);
        -- block:SetYRange(0, Design:adapterWidth(300)*0.5-button.width*0.5);
        block:SetXRange(0, DirectionRocker.outterRadius-button.width*0.5);
        block:SetYRange(0, DirectionRocker.outterRadius-button.width*0.5);
        DirectionRocker:ReleaseKey()
    elseif(touchtype == "WM_POINTERDOWN") then
        DirectionRocker.isMovable = true
        DirectionRocker.buttonObj = buttonObj
        DirectionRocker.startX = touch.x
        DirectionRocker.startY = touch.y
        echo("----isMovable in down-----")
        echo(DirectionRocker.isMovable)
        -- DirectionRocker.getSingleton():show(true);
        -- block:SetRotationRange(0, 0.6)
        -- block:SetXRange(0, touch.x-Design:adapterWidth(100) - button.width*0.5);
        -- block:SetYRange(0, touch.y-(Screen:GetHeight() - Design:adapterWidth(400)) - button.height*0.5);
        block:SetXRange(0, touch.x-DirectionRocker.containerLeft - button.width*0.5);
        block:SetYRange(0, touch.y-DirectionRocker.containerTop - button.height*0.5);
        DirectionRocker:GetRadious(touch, touchtype);
    else
        if(self.isMovable) then
            -- block:SetRotationRange(0, 0.6)
            -- buttonObj.rotation =0.6
            local result = math.sqrt(math.pow((touch.x-DirectionRocker.originX), 2)+math.pow((touch.y-DirectionRocker.originY), 2))
			if DirectionRocker.isMovable then
				if result < DirectionRocker.outterRadius then
                    echo("内")
                    -- echo("touch")
                    -- echo(touch)
                    
                    -- echo("Design:adapterWidth(100)"..Design:adapterWidth(100))
                    -- echo("x=="..touch.x-Design:adapterWidth(100) - button.width*0.5)
                    -- echo("y=="..touch.y-(Screen:GetHeight() - Design:adapterWidth(400)) - button.height*0.5)

                    -- block:SetXRange(0, touch.x-Design:adapterWidth(100) - button.width*0.5);
                    -- block:SetYRange(0, touch.y-(Screen:GetHeight() - Design:adapterWidth(400)) - button.height*0.5);
                    block:SetXRange(0, touch.x - DirectionRocker.containerLeft - button.width*0.5);
                    block:SetYRange(0, touch.y - DirectionRocker.containerTop - button.height*0.5);
                    DirectionRocker:GetRadious(touch, touchtype)
                    if result > DirectionRocker.middleRadius then
                        CommandManager:Init();
                        CommandManager:RunCommand("/speedscale 1.5");
                    else
                        CommandManager:Init();
                        CommandManager:RunCommand("/speedscale 1");
                    end
				elseif result > DirectionRocker.outterRadius then
                    echo("外")
                    CommandManager:Init();
                    CommandManager:RunCommand("/speedscale 1.5");
					local point = DirectionRocker:getPoint(touch.x,touch.y,result)
                    -- echo("point")
                    -- echo(point)
                    -- echo("touch")
                    -- echo(touch)
                    -- echo("Design:adapterWidth(100)"..Design:adapterWidth(100))
                    -- echo("x=="..point.x-Design:adapterWidth(100) - button.width*0.5)
                    -- echo("y=="..point.y-(Screen:GetHeight() - Design:adapterWidth(400)) - button.width*0.5)
                    block:SetXRange(0, point.x - DirectionRocker.containerLeft-button.width*0.5);
                    block:SetYRange(0, point.y - DirectionRocker.containerTop- button.height*0.5);
                    DirectionRocker:GetRadious(touch, touchtype);
				end
			end
        end
    end

    block:SetApplyAnim(true); 
    UIAnimManager.PlayDirectUIAnimation(block);
end

function DirectionRocker:GetRadious(touch, touchtype)
    -- local angle = (DirectionRocker.originY - touch.y)/(touch.x - DirectionRocker.originX)
    local angle = math.atan2(DirectionRocker.originY - touch.y, touch.x - DirectionRocker.originX)
    -- echo("----------GetRadious")
    -- echo("angle===="..angle)
    DirectionRocker:ReleaseKey()
    -- echo(Keyboard:HasKeyFocus())
    if angle > math.pi*3/8 and angle < math.pi*5/8 then
        -- echo("上")
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_W);
    elseif angle > math.pi*1/8 and angle < math.pi*3/8 then
        -- echo("“右上”")
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_W);
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_D);
    elseif angle > -math.pi*1/8 and angle < math.pi*1/8 then
        -- echo("“右”")
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_D);
    elseif angle > -math.pi*3/8 and angle < -math.pi*1/8 then
        -- echo("“右下”")
        if System.os.IsMobilePlatform() then
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_S);
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_A);
        else
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_S);
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_D);
        end
    elseif angle > -math.pi*5/8 and angle < -math.pi*3/8 then
        -- echo("“下”")
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_S);
    elseif angle > -math.pi*7/8 and angle < -math.pi*5/8 then
        -- echo("“左下”")
        if System.os.IsMobilePlatform() then
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_S);
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_D); 
        else
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_S);
            Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_A); 
        end
        
    elseif (angle > math.pi*7/8 and angle < math.pi) or (angle > -math.pi and angle < -math.pi*7/8) then
        -- echo("“左”")
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_A);
    elseif angle > math.pi*5/8 and angle < math.pi*7/8 then
        -- echo("“左上”")
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_A);
        Keyboard:SendKeyEvent(touchtype == "WM_POINTERUPDATE" and "keyDownEvent" or "keyUpEvent", DIK_SCANCODE.DIK_W);
    end
end

function DirectionRocker:ReleaseKey()
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_A);
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_W);
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_S);
    Keyboard:SendKeyEvent("keyUpEvent", DIK_SCANCODE.DIK_D);
end

--更新 & 发送键盘指令
function DirectionRocker:updateButtonState(button, isPressed)
    -- echo("------- DirectionRocker:updateButtonState-------")
    -- echo(button)
    local container = self:getContainer();
    local buttonUI = container:GetChild(button.name);
    button.isPressed = isPressed;
    if isPressed then
        _guihelper.SetUIColor(buttonUI, self.colors.pressed);
    else
        _guihelper.SetUIColor(buttonUI, self.colors.normal);
    end

    self:emitKeyEvent(button, isPressed);

    Mouse:SetTouchButtonSwapped(isPressed);
end

--发送键盘指令
function DirectionRocker:emitKeyEvent(button, isPressed)
    if button.key then
        Keyboard:SendKeyEvent(isPressed and "keyDownEvent" or "keyUpEvent", button.key);
    end
end

function DirectionRocker:Destroy()
    DirectionRocker._super.Destroy(self)
    ParaUI.Destroy(self.id or self.name)
    self.id = nil
end

--[[
@desc   求直线与圆的交点
@param  cx:圆X轴坐标
        cy:圆y轴坐标
        r:圆半径
        stx:起点直线的X轴坐标
        sty:起点直线的轴坐标
        edx:终点直线的X轴坐标
        edy:终点直线的Y轴坐标
@return 交点坐标(x,y)
]]
function DirectionRocker:getPoint(edx,edy,result)
    -- local cx = Design:adapterWidth(100) + DirectionRocker.outterRadius
    -- local cy = Screen:GetHeight() - Design:adapterWidth(400) + DirectionRocker.outterRadius
    local cx = DirectionRocker.containerLeft + DirectionRocker.outterRadius
    local cy = DirectionRocker.containerTop + DirectionRocker.outterRadius
    local r = DirectionRocker.outterRadius
    local stx = cx
    local sty = cy

    local point ={}

    local k = (edy - sty) / (edx - stx);
    local b = edy - k*edx;

    -- (1 + k^2)*x^2 - 2*x*(cx -k*(b -cy) ) + cx*cx + ( b - cy)*(b - cy) - r*r = 0
    local c = cx*cx + (b - cy)*(b- cy) -r*r;
    local a = (1 + k*k);
    local b1 = -2*cx + 2*k*(b - cy);

    local tmp = math.sqrt(b1*b1 - 4*a*c);
    local x1 = ( -b1 + tmp )/(2*a);
    local y1 = k*x1 + b;
    local x2 = ( -b1 - tmp)/(2*a);
    local y2 = k*x2 + b;
    echo("k="..k.."b="..b.."a="..a.."b1="..b1.."c="..c)
    echo("x1="..x1.."y1="..y1.."x2="..x2.."y2="..y2)
    if math.abs(edx-x1) > math.abs(edx-x2) then
        point.x = x2
        point.y = y2
    else
        point.x = x1
        point.y = y1
    end
    return point
end