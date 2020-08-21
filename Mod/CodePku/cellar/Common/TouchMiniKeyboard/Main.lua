NPL.load("./DirectionKeyboard.lua")
NPL.load("./FeatKeyboard.lua")
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua")

local DirectionKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionKeyboard")
local FeatKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard")
NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniKeyboard/TouchDirectionKeyboard.lua")
local TouchDirectionKeyboard = commonlib.gettable("Mod.CodePku.Cellar.Common.TouchMiniKeyboard.TouchDirectionKeyboard")
local TouchMiniKeyboard = NPL.export()

function TouchMiniKeyboard:show(show)
    --    DirectionKeyboard.getSingleton():show(show);
    TouchDirectionKeyboard.Show(show)
    FeatKeyboard.getSingleton():show(show)
end

function TouchMiniKeyboard.CheckShow(show)
    TouchDirectionKeyboard.Show(show)
    --    DirectionKeyboard.getSingleton():show(show);
    FeatKeyboard.getSingleton():show(show)
end
