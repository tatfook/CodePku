--[[
Title: 摇杆 
Author(s): John Mai
Date: 2020-08-18 09:59:40
Desc: 摇杆
Example:
------------------------------------------------------------
NPL.load("(gl)Mod/CodePku/celler/Common/TouchMiniKeyboard/TouchDirectionKeyboard.lua");
local TouchDirectionKeyboard = commonlib.gettable("Mod.CodePku.Celler.Common.TouchMiniKeyboard.TouchDirectionKeyboard");
TouchDirectionKeyboard:init();
-------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Core/ToolBase.lua")
NPL.load("(gl)script/apps/Aries/Creator/Game/Common/TouchButton.lua")

local PlayerController = commonlib.gettable("MyCompany.Aries.Game.PlayerController")
local TouchButton = commonlib.gettable("MyCompany.Aries.Game.Common.TouchButton")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager")
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua")

local TouchDirectionKeyboard =
    commonlib.inherit(
    commonlib.gettable("System.Core.ToolBase"),
    commonlib.gettable("Mod.CodePku.Celler.Common.TouchMiniKeyboard.TouchDirectionKeyboard")
)

function TouchDirectionKeyboard.Init()
    Log.info("TouchDirectionKeyboard.Init")
end

function TouchDirectionKeyboard.OnTouchMove(name, mcmlNode, touch)
    echo("TouchDirectionKeyboard.OnTouchMove")
    echo(touch)
    echo(mcmlNode)
    echo(name)
    if not TouchDirectionKeyboard.TouchButtonMove then
        TouchDirectionKeyboard.TouchButtonMove =
            TouchButton:new(
            {
                OnTouchClick = function(self)
                    echo("OnTouchClick")
                    echo(touch)
                    echo(mcmlNode)
                    echo(name)
                    echo(self)
                end,
                OnTouchDown = function(self)
                    echo("OnTouchDown")
                    echo(touch)
                    echo(mcmlNode)
                    echo(name)
                    echo(self)
                end,
                OnTouchMove = function(self)
                    echo("OnTouchMove")
                    echo(touch)
                    echo(mcmlNode)
                    echo(name)
                    echo(self)
                end,
                OnTick = function(self)
                    echo("OnTick")
                    echo(touch)
                    echo(mcmlNode)
                    echo(name)
                    echo(self)
                end,
                OnTouchUp = function(self)
                    echo("OnTouchUp")
                    echo(touch)
                    echo(mcmlNode)
                    echo(name)
                    echo(self)
                end
            }
        )
    end
end
