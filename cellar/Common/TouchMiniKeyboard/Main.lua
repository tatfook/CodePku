NPL.load("./DirectionKeyboard.lua");
NPL.load("./FeatKeyboard.lua");
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");

local DirectionKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionKeyboard");
local FeatKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard");

local TouchMiniKeyboard = NPL.export();

function TouchMiniKeyboard:show(show)
    DirectionKeyboard.getSingleton():show(show);
    FeatKeyboard.getSingleton():show(show);
end