NPL.load("./DirectionKeyboard.lua");
NPL.load("./FeatKeyboard.lua");
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");

local DirectionKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionKeyboard");
local FeatKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard");

local TouchMiniKeyboard = NPL.export();

function TouchMiniKeyboard:show(show)
    -- if tonumber(currentkpId) == 18656 then return end
    DirectionKeyboard.getSingleton():show(show);
    FeatKeyboard.getSingleton():show(show);
end

function TouchMiniKeyboard.CheckShow(show)
    local visible = true;
    local currentkpId = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.keepwork_project_id
    local beginnerGuideId = Mod.CodePku.BasicConfig.beginner_guide_world_id or 18656;
    
    if tonumber(currentkpId) == beginnerGuideId then 
        visible = false;
    end
    
    DirectionKeyboard.getSingleton():show(visible);
    FeatKeyboard.getSingleton():show(visible);
end