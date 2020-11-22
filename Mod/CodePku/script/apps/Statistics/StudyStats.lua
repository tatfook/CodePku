--[[
-------------------------------------------------------
local StudyStats = NPL.load("(gl)Mod/CodePku/script/apps/Statistics/StudyStats.lua");
StudyStats.StaticInit();
-------------------------------------------------------
]]


local StudyStats = NPL.export();

StudyStats.worldId = nil;
StudyStats.enterTime = nil;
StudyStats.leaveTime = nil;

local init = false;
function StudyStats.StaticInit()
    if (init) then return end
    init = true;
    -- GameLogic.GetFilters():add_filter("OnCodepkuStatsin", StudyStats.OnCodepkuStatsin_Callback);
    -- GameLogic.GetFilters():add_filter("OnCodepkuStatsout", StudyStats.OnCodepkuStatsout_Callback);
    
	GameLogic:Connect("WorldLoaded", StudyStats, StudyStats.OnWorldLoaded, "UniqueConnection");
    GameLogic:Connect("WorldUnloaded", StudyStats, StudyStats.OnWorldUnload, "UniqueConnection");
end

function StudyStats.OnWorldLoaded()
    local id = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
    StudyStats.worldId = id;
    
    echo("StudyStats.OnWorldLoaded: System.Codepku.MyHouse: ");
    echo(System.Codepku.MyHouse);
    if System.Codepku and System.Codepku.MyHouse then
        StudyStats.myHouseId = System.Codepku.MyHouse.id;
        StudyStats.myHouseTemplateId = System.Codepku.MyHouse.template_kp_id;
    end
    LOG.std(nil, "info", "StudyStats", "OnWorldLoaded: %s",tostring(StudyStats.worldId));
    LOG.std(nil, "info", "StudyStats", "OnWorldLoaded @: %s", os.time());
    StudyStats.enterTime = os.date("%Y-%m-%d %H:%M:%S", os.time());
    -- GameLogic.events:AddEventListener("OnWorldUnload", StudyStats.OnWorldUnload, StudyStats, "StudyStats"); -- do not work
end

function StudyStats.OnWorldUnload(self, event)
    LOG.std(nil, "info", "StudyStats", "OnWorldUnload @: worldId: %s, houseId: %s, templateId: %s", StudyStats.worldId, StudyStats.myHouseId, StudyStats.myHouseTemplateId);
    
    if (StudyStats.worldId ~= nil) then
        StudyStats.leaveTime = os.date("%Y-%m-%d %H:%M:%S", os.time());
        local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");    
        request:post('/courseware-learn-log', {
            courseware_id = StudyStats.worldId,
            entry_at = StudyStats.enterTime,
            leave_at = StudyStats.leaveTime
        }):next(function(response)
            echo(response)
        end):catch(function(err)
            LOG.error("ERROR: catched at StudyStats.OnWorldUnload");
            LOG.error(err)
        end);
        StudyStats.worldId = nil;
    end

    if StudyStats.myHouseId and StudyStats.myHouseTemplateId then
        StudyStats.leaveTime = os.date("%Y-%m-%d %H:%M:%S", os.time());
        local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");    
        request:post('/house-learn-log', {
            user_house_id = StudyStats.myHouseId,
            template_id = StudyStats.myHouseTemplateId,
            entry_at = StudyStats.enterTime,
            leave_at = StudyStats.leaveTime
        }):next(function(response)            
            echo(response)
        end):catch(function(err)
            LOG.error("ERROR: catched at StudyStats.OnWorldUnload");
            LOG.error(err)
        end);
        StudyStats.myHouseId = nil;
        StudyStats.myHouseTemplateId = nil;
    end
end

-- function StudyStats.OnExitApp()
--     LOG.std(nil, "info", "StudyStats", "OnExitApp");
-- end

-- function StudyStats.OnCodepkuStatsin_Callback()
--     LOG.std(nil, "info", "StudyStats", "OnCodepkuStatsin_Callback: %s",tostring(CodepkuChatChannel.worldId));
--     if (StudyStats.worldId ~= nil) then
--         StudyStats.OnWorldLoaded();
--     end
-- end

-- function StudyStats.OnCodepkuStatsout_Callback()
--     if (CodepkuChatChannel.worldId) then
--     end
-- end