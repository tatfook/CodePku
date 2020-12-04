--[[
-------------------------------------------------------
local StudyStats = NPL.load("(gl)Mod/CodePku/script/apps/Statistics/StudyStats.lua");
StudyStats.StaticInit();
-------------------------------------------------------
]]

local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");    
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
    if System.Codepku and System.Codepku.loadedHouse then
        StudyStats.houseId = System.Codepku.loadedHouse.id;
        StudyStats.houseTemplateId = System.Codepku.loadedHouse.template_kp_id;
        LOG.std(nil, "info", "StudyStats", "House OnWorldLoaded: %s",tostring(StudyStats.houseId));
    else
        local id = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.id;
        StudyStats.worldId = id;
        LOG.std(nil, "info", "StudyStats", "Course OnWorldLoaded: %s",tostring(StudyStats.houseId));
    end
    
    LOG.std(nil, "info", "StudyStats", "OnWorldLoaded @: %s", os.time());
    StudyStats.enterTime = os.date("%Y-%m-%d %H:%M:%S", os.time());
    -- GameLogic.events:AddEventListener("OnWorldUnload", StudyStats.OnWorldUnload, StudyStats, "StudyStats"); -- do not work
end

function StudyStats.OnWorldUnload(self, event)
    LOG.std(nil, "info", "StudyStats", "OnWorldUnload @: worldId: %s, houseId: %s, templateId: %s", StudyStats.worldId, StudyStats.houseId, StudyStats.houseTemplateId);
    StudyStats.leaveTime = os.date("%Y-%m-%d %H:%M:%S", os.time());

    if (StudyStats.worldId ~= nil) then                
        request:post('/courseware-learn-log', {
            courseware_id = StudyStats.worldId,
            entry_at = StudyStats.enterTime,
            leave_at = StudyStats.leaveTime
        }):next(function(response)
            LOG.std("", 'info', 'codepku', 'upload courseware learn log');
        end):catch(function(err)
            LOG.error("ERROR: catched at StudyStats.OnWorldUnload");
            LOG.error(err)
        end);
        StudyStats.worldId = nil;
    end

    if StudyStats.houseId and StudyStats.houseTemplateId then                
        request:post('/house-learn-log', {
            user_house_id = StudyStats.houseId,
            template_id = StudyStats.houseId,
            entry_at = StudyStats.enterTime,
            leave_at = StudyStats.leaveTime
        }):next(function(response)            
            LOG.std("", 'info', 'codepku', 'upload house building learn log');
        end):catch(function(err)
            LOG.error("ERROR: catched at StudyStats.OnWorldUnload");
            LOG.error(err)
        end);
        StudyStats.houseId = nil;
        StudyStats.houseTemplateId = nil;
    end
end
