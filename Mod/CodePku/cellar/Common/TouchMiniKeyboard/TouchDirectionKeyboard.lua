--[[
Title: 摇杆 
Author(s): John Mai
Date: 2020-08-18 09:59:40
Desc: 摇杆
Example:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchDirectionKeyboard.lua");
local TouchDirectionKeyboard = commonlib.gettable("Mod.CodePku.Cellar.Common.TouchMiniKeyboard.TouchDirectionKeyboard");
TouchDirectionKeyboard:init();
-------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Core/ToolBase.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchButton.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Tools/ToolManager.lua");

local PlayerController = commonlib.gettable("MyCompany.Aries.Game.PlayerController")
local TouchButton = commonlib.gettable("MyCompany.Aries.Game.Common.TouchButton")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua")
local ToolManager = commonlib.gettable("MyCompany.Aries.Game.Tools.ToolManager");
local page;

local TouchDirectionKeyboard =
commonlib.inherit(commonlib.gettable("System.Core.ToolBase"),
    commonlib.gettable("Mod.CodePku.Cellar.Common.TouchMiniKeyboard.TouchDirectionKeyboard"))

function TouchDirectionKeyboard:ctor()
    Log.info("TouchDirectionKeyboard:ctor")
    ToolManager:InitSingleton();

    self.Connect(ToolManager, ToolManager.SelectedToolChanged, self, self.SetSelectedTool);
end

function TouchDirectionKeyboard.Init()
    Log.info("TouchDirectionKeyboard.Init")
    TouchDirectionKeyboard:InitSingleton();
    page = document:GetPageCtrl();
end

function TouchDirectionKeyboard:SetSelectedTool(tool)
    if (self.selectedTool == tool) then
        return;
    end

    if (tool) then
        self.selectedTool = tool;
    end
end

function TouchDirectionKeyboard:GetCurrentTool()
    return self.selectedTool;
end

function TouchDirectionKeyboard.OnTouchScene(name, mcmlNode, touch)
    local tool = TouchDirectionKeyboard:GetCurrentTool();
    if (tool) then
        tool:OnTouchScene(touch);
    end
end



function TouchDirectionKeyboard.Show(isShow)

    PlayerController:SetFlyUsingCameraDir(not isShow);

        local params = {
            url = "Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchDirectionKeyboard.html",
            name = "TouchDirectionKeyboard",
            isShowTitleBar = false,
            DestroyOnClose = true,
            bToggleShowHide=false,
            style = CommonCtrl.WindowFrame.ContainerStyle,
            allowDrag = false,
            enable_esc_key = false,
            bShow = isShow,
            zorder = -10,
            click_through = true,
            cancelShowAnimation = true,
            directPosition = true,
            align = "_fi",
            x = 101,
            y = 330,
            width = 0,
            height = 0,
        };
        System.App.Commands.Call("File.MCMLWindowFrame", params);

end

function TouchDirectionKeyboard.UpdateTouchPad(name, bIsPressed)
    if (page) then
        local ctl = page:FindUIControl(name);
        if (ctl) then
            local btnColor;
            if (bIsPressed) then
                btnColor = "255 255 255 90";
                ctl.canDrag = true;
            else
                btnColor = "255 255 255";
                ctl.canDrag = false;
            end
            _guihelper.SetUIColor(ctl, btnColor);
            for i = 0, ctl:GetChildCount() do
                local child = ctl:GetChildAt(i);
                _guihelper.SetUIColor(child, btnColor);
            end
        end
    end
end

function TouchDirectionKeyboard.OnTouchMove(name, mcmlNode, touch)
    echo("TouchDirectionKeyboard.OnTouchMove")
    echo(touch)
    --    echo(mcmlNode)
    echo(name)
    if not TouchDirectionKeyboard.TouchButtonMove then
        TouchDirectionKeyboard.TouchButtonMove =
        TouchButton:new({
            OnTouchDown = function(self)
                TouchDirectionKeyboard.UpdateTouchPad("touch_direction_keyboard", true);

                local player = EntityManager.GetFocus();
                if (player) then
                    player:BeginTouchMove();
                end

                if (page) then
                    local TouchDirectionKeyboardUI = page:FindControl("touch_direction_keyboard");
                    if (TouchDirectionKeyboardUI) then
                        local touch = self:GetStartTouch();
                        local finger_size = 30;
                        local x, y, width, height = TouchDirectionKeyboardUI:GetAbsPosition();
                        local cx, cy = x + width * 0.5, y + height * 0.5;
                        if (math.abs(touch.x - cx) > math.abs(touch.y - cy)) then
                            if (touch.x > cx) then
                                touch.x = math.max(cx, touch.x - finger_size);
                            else
                                touch.x = math.min(cx, touch.x + finger_size);
                            end
                        else
                            if (touch.y > cy) then
                                touch.y = math.max(cy, touch.y - finger_size);
                            else
                                touch.y = math.min(cy, touch.y + finger_size);
                            end
                        end
                    end
                end
            end,
            OnTick = function(self)
                local player = EntityManager.GetFocus();
                if (player) then
                    local dx, dy = self:GetOffsetFromStartLocation();

--                    local TouchDirectionKeyboardPointUI = page:FindControl("touch_direction_keyboard_point");
--                    echo(66666)
--                    echo(TouchDirectionKeyboardPointUI)
--                    if TouchDirectionKeyboardPointUI then
--                        echo(TouchDirectionKeyboardPointUI)
--                        TouchDirectionKeyboardPointUI:reposition(touch.x,touch.y);
--                    end

                    if ((math.abs(dx) + math.abs(dy)) > 10) then
                        local pos_angle = 0;
                        if (dx == 0) then
                            if (dy == 0) then
                                return;
                            end
                            if (dy > 0) then
                                pos_angle = math.pi;
                            else
                                pos_angle = 0;
                            end
                        else
                            pos_angle = math.pi * 0.5 + math.atan(dy / dx);
                            if (dx < 0) then
                                pos_angle = pos_angle + math.pi;
                            end
                        end
                        player:TouchMove(pos_angle);
                    end
                end
            end,
            OnTouchUp = function(self)
                TouchDirectionKeyboard.UpdateTouchPad("touch_direction_keyboard", false);

                local player = EntityManager.GetFocus();
                if (player) then
                    player:EndTouchMove();
                end
            end
        })
    end

    TouchDirectionKeyboard.TouchButtonMove:OnTouchEvent(touch);
end
