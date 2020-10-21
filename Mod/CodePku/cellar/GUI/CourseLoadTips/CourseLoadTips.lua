--[[
create by zouren at 2020.08.20
进入教学世界mod后自动判定是有有存档，然后弹出该界面让用户选择是否读取存档
不用在别的地方单独调用，直接在main.lua文件的init函数中初始化绑定信号接口
]]
NPL.load("(gl)script/apps/Aries/Creator/Game/block_engine.lua");
local BlockEngine = commonlib.gettable("MyCompany.Aries.Game.BlockEngine")

local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");


local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local GameLogic = commonlib.gettable("MyCompany.Aries.Game.GameLogic")
local CourseLoadTips = commonlib.gettable("Mod.CodePku.GUI.CourseLoadTips")

CourseLoadTips.vars = {}
CourseLoadTips.popui = nil
CourseLoadTips.world_position = nil

CourseLoadTips.params={
    url="Mod/CodePku/cellar/GUI/CourseLoadTips/CourseLoadTips.html",
    alignment="_ct", left = -960, top = -540, width = 1920, height = 1080,zorder =30
}

function CourseLoadTips.StaticInit()
    --body
    GameLogic:Connect("WorldLoaded", CourseLoadTips, CourseLoadTips.OnWorldLoaded, "UniqueConnection");
end

function CourseLoadTips.OnWorldLoaded()
    -- body
    -- 获取世界类型 然后判定是否是教案 如果是的话则拉取世界存档数据并判断是否有存档
    local category = System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.category
    LOG.std(nil, "info", "CourseLoadTips", "OnWorldLoaded Category = %s", tostring(category))
    if category and (category == 1 or category == 2) then

        -- 进入一个课程世界,初始化结算累计的奖励
        local TaskSettlement = NPL.load("(gl)Mod/CodePku/cellar/GUI/TaskSettlement/TaskSettlement.lua")
        TaskSettlement.allAward = nil --初始化统计的奖励
        TaskSettlement.allProps = nil --初始化统计的奖励
        ----

        local courseware_id = System.Codepku.Coursewares.id
        LOG.std(nil, "info", "CourseLoadTips", "OnWorldLoaded CourseId = %s", tostring(courseware_id))
        request:get('/learn-records/last/' .. courseware_id):next(function(response)
            -- body
            local data = response.data.data
            if next(data) then
                CourseLoadTips.vars["world_position"] = data.world_position,
                CourseLoadTips:ShowPage()
            end
        end):catch(function()
            -- body
        end)
    end
end

--讲服务器传过来的世界坐标转换成玩家坐标，然后执行人物传送才正确
function CourseLoadTips:ConvertWorldPosToPlayerPos(world_x, world_y, world_z)
    --body
    local blocksize = BlockEngine.blocksize;
    local region_size = BlockEngine.region_size;
    local region_width = BlockEngine.region_width;
    local offset_y = BlockEngine.offset_y;

    local x, y, z

    x = math.floor(world_x/region_width)
    z = math.floor(world_z/region_width)
    local x_orgin = x*region_size
    local z_orgin = z*region_size
    local bx = world_x - x*region_width
    local bz = world_z - z*region_width
    x = bx/blocksize - 0.5 + x_orgin
    z = bz/blocksize - 0.5 + z_orgin
    y = (world_y - offset_y)/blocksize - 0.5

    return x, y, z
end

function CourseLoadTips:ShowPage()
    echo("open CourseLoadTips page, code file is CourseLoadTips.lua and CourseLoadTips.html")
    CourseLoadTips:CloseWindow()
    CourseLoadTips.popui = AdaptWindow:QuickWindow(CourseLoadTips.params)
end

function CourseLoadTips:CloseWindow()
    -- body
    if CourseLoadTips.popui ~= nil then
        CourseLoadTips.popui:CloseWindow()
    end
end