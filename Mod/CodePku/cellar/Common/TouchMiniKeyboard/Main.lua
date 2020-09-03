NPL.load("./DirectionKeyboard.lua");
NPL.load("./FeatKeyboard.lua");
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");

local DirectionKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionKeyboard");
local FeatKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard");

local TouchMiniKeyboard = NPL.export();
local currentkpId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.keepwork_project_id

function TouchMiniKeyboard:show(show)
    if tonumber(currentkpId) == 18656 then return
    DirectionKeyboard.getSingleton():show(show);
    FeatKeyboard.getSingleton():show(show);
end

function TouchMiniKeyboard.CheckShow(show)
    if tonumber(currentkpId) == 18656 then return
    DirectionKeyboard.getSingleton():show(show);
    FeatKeyboard.getSingleton():show(show);
end