--[[
Author:zouren
Date: 2020-10-22 19:07:23
Des:
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/ChooseBranch.lua")
local ChooseBranch = commonlib.gettable("Mod.CodePku.GUI.ChooseBranch")
ChooseBranch:ShowPage()
-----------------------------------
]]--
NPL.load("(gl)Mod/CodePku/cellar/GUI/Branch/BranchData.lua")
NPL.load("(gl)script/ide/UIAnim/UIAnimManager.lua")

local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local branchImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/branchImageData.lua")
local common1ImageData = NPL.load("(gl)Mod/CodePku/cellar/imageLuaTable/common1ImageData.lua")

local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")
local ChooseBranch = commonlib.gettable("Mod.CodePku.GUI.ChooseBranch")

ChooseBranch.ui = nil

ChooseBranch.branchStateTable = {}

ChooseBranch.currChooseBranch = 1
ChooseBranch.currChooseServer = 2

-- 弃用了
-- ChooseBranch.branchNameTalbe = {
--     "甲子线","乙丑线","丙寅线","丁卯线","戊辰线",
--     "已巳线","庚午线","辛未线","壬申线","癸酉线",
--     "甲戌线","乙亥线","丙子线","丁丑线","戊寅线",
--     "已卯线","庚辰线","辛巳线","壬午线","癸未线",
--     "甲申线","乙酉线","丙戌线","丁亥线","戊子线",
--     "己丑线","庚寅线","辛卯线","壬辰线","癸巳线",
--     "甲午线","乙未线","丙申线","丁酉线","戊戌线",
--     "已亥线","庚子线","辛丑线","壬寅线","癸卯线",
--     "甲辰线","乙巳线","丙午线","丁未线","戊申线",
--     "已酉线","庚戌线","辛亥线","壬子线","癸丑线",
--     "甲寅线","乙卯线","丙辰线","丁巳线","戊午线",
--     "已未线","庚申线","辛酉线","壬戌线","癸亥线",
-- }

ChooseBranch.HTMLStyleData = {
    [1] = { ["desc"] = "背景图片", ["position"] = "absolute", ["left"] = 624, ["top"] = 18, ["width"] = 699, ["height"] = 1000, ["background"] = "url("..branchImageData:GetIconUrl("branch_boot_01.png")..")",},
    [2] = { ["desc"] = "退出按钮", ["position"] = "absolute", ["left"] = 1213, ["top"] = 4, ["width"] = 77, ["height"] = 123, ["background"] = "url("..common1ImageData:GetIconUrl("comm_btn_close.png")..")",},
    [3] = { ["desc"] = "切换分线按钮", ["position"] = "absolute", ["left"] = 830, ["top"] = 957, ["width"] = 298, ["height"] = 101, ["background"] = "url("..common1ImageData:GetIconUrl("common_btn_green01.png")..")",},
    [4] = { ["desc"] = "爆满图标", ["position"] = "relative", ["left"] = 89, ["top"] = 186, ["width"] = 52, ["height"] = 52, ["background"] = "url("..branchImageData:GetIconUrl("branch_icon_r.png")..")",},
    [5] = { ["desc"] = "爆满文字", ["position"] = "relative", ["left"] = 161, ["top"] = 194, ["width"] = 104, ["height"] = 52, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "40px",},
    [6] = { ["desc"] = "繁忙图标", ["position"] = "relative", ["left"] = 278, ["top"] = 186, ["width"] = 52, ["height"] = 52, ["background"] = "url("..branchImageData:GetIconUrl("branch_icon_y.png")..")",},
    [7] = { ["desc"] = "繁忙文字", ["position"] = "relative", ["left"] = 350, ["top"] = 194, ["width"] = 104, ["height"] = 52, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "40px",},
    [8] = { ["desc"] = "流畅图标", ["position"] = "relative", ["left"] = 467, ["top"] = 186, ["width"] = 52, ["height"] = 52, ["background"] = "url("..branchImageData:GetIconUrl("branch_icon_g.png")..")",},
    [9] = { ["desc"] = "流畅文字", ["position"] = "relative", ["left"] = 539, ["top"] = 194, ["width"] = 104, ["height"] = 52, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "40px",},
    [10] = { ["desc"] = "标题文字", ["position"] = "relative", ["left"] = 210, ["top"] = 31, ["width"] = 400, ["height"] = 120, ["color"] = "#9e6c5e", ["font-family"] = "zkklt", ["font-size"] = "65px",},
    [11] = { ["desc"] = "滚动区域", ["position"] = "relative", ["left"] = 80, ["top"] = 256, ["width"] = 535, ["height"] = 670,},
    [12] = { ["desc"] = "分线栏背景(未选择)", ["width"] = 535, ["height"] = 106, ["top"] = 30,["background"] = "url("..branchImageData:GetIconUrl("branch_boot_g.png")..")",},
    [13] = { ["desc"] = "分线栏背景(选中)", ["width"] = 535, ["height"] = 107, ["top"] = 30,["background"] = "url("..branchImageData:GetIconUrl("branch_boot_w.png")..")",},
    [14] = { ["desc"] = "分线栏状态标签(流畅)", ["position"] = "relative", ["left"] = 24, ["top"] = 30, ["width"] = 52, ["height"] = 52,["background"] = "url("..branchImageData:GetIconUrl("branch_icon_g.png")..")",},
    [15] = { ["desc"] = "分线栏文字",  ["position"] = "relative", ["left"] = 80, ["top"] = 32, ["width"] = 440, ["height"] = 60, ["color"] = "#813010", ["font-family"] = "zkklt", ["font-size"] = "48",},
    [16] = { ["desc"] = "切换分线按钮文字",  ["position"] = "relative", ["left"] = 49, ["top"] = 26, ["width"] = 199, ["height"] = 41,["background"] = "url("..branchImageData:GetIconUrl("branch_icon_g_mat.png")..")",},
    [17] = { ["desc"] = "分线栏状态标签(繁忙)", ["position"] = "relative", ["left"] = 24, ["top"] = 30, ["width"] = 52, ["height"] = 52,["background"] = "url("..branchImageData:GetIconUrl("branch_icon_y.png")..")",},
    [18] = { ["desc"] = "分线栏状态标签(爆满)", ["position"] = "relative", ["left"] = 24, ["top"] = 30, ["width"] = 52, ["height"] = 52,["background"] = "url("..branchImageData:GetIconUrl("branch_icon_r.png")..")",},
    [19] = { ["desc"] = "服务器标签背景", ["position"] = "relative", ["left"] = 394, ["top"] = -90, ["width"] = 143, ["height"] = 38,["background"] = "url("..branchImageData:GetIconUrl("branch_boot_f.png")..")",},
    [20] = { ["desc"] = "服务器标签文字", ["position"] = "relative", ["left"] = 19, ["top"] = 5, ["width"] = 125, ["height"] = 38, ["color"] = "#813010", ["font-family"] = "zkklt", ["font-size"] = "30",},
    [21] = { ["desc"] = "滚动栏item大小", ["width"] = 535, ["height"] = 140,},
}

function ChooseBranch:StaticInit()
    LOG.std("", "info", "ChooseBranch", "StaticInit");

    GameLogic:Connect("WorldLoaded", ChooseBranch, ChooseBranch.OnWorldLoaded, "UniqueConnection");
    GameLogic:Connect("WorldUnloaded", ChooseBranch, ChooseBranch.OnWorldUnloaded, "UniqueConnection");
end

function ChooseBranch:GetServerData()
    --todo
    request:get("/online/servers?type=2", nil, nil):next(function (response)
        --body
        if response and response.data and response.data.code == 200 then
            ChooseBranch.serverData = {}
            local data = response.data.data
            for i,j in pairs(data) do
                local server = {}
                server.ip = j.host
                server.port = j.port
                server.id = j.id
                server.type = j.type
                server.name = j.name
                server.status = j.status
                if j.type == 2 then
                    ChooseBranch.serverData[j.id] = server
                end
            end
            -- echo("===zr===")
            -- echo("ChooseBranch.serverData:")
            -- echo(ChooseBranch.serverData)
        end
    end):catch(function (e)
        --body
    end)
end

function ChooseBranch:GetBranchStateIconHTML(branchId, ip, port)
    local serverId = ChooseBranch:GetServerId(ip, port)
    
    for k,v in pairs(ChooseBranch.branchStateTable) do
        if v["serverId"] == serverId and v["branchId"] == branchId then
            local percentage = v["playerNum"] / v["maxPlayerNum"]
            if percentage < 0.25 then
                return ChooseBranch:GetHTMLStyleStr(14)
            elseif percentage < 0.75 then
                return ChooseBranch:GetHTMLStyleStr(17)
            else
                return ChooseBranch:GetHTMLStyleStr(18)
            end
        end
    end
end

function ChooseBranch:GetServerId(ip, port)
    --todo
    for k,v in pairs(ChooseBranch.serverData) do
        if v.ip == tostring(ip) and v.port == tostring(port) then
            return v.id
        end
    end
end

function ChooseBranch:GetServerName(serverId)
	return "服务器"..tostring(serverId)
end

function ChooseBranch.OnWorldLoaded()
    -- 向GGS服务器请求数据
    GameLogic.RunCommand("/wanxueshijie worldInfo")

    -- 处理数据的计时器  因为GGS是异步获取的数据  这里弄个计时器看是否获取到了数据
    ChooseBranch.timerNum = 0
    ChooseBranch.dealDataTimer = commonlib.Timer:new({callbackFunc = function(timer)
        commonlib.log({"ontimer", timer.id, timer.delta, timer.lastTick})
        ChooseBranch.timerNum = ChooseBranch.timerNum + 1
        if ChooseBranch.timerNum > 10 and ChooseBranch.dealDataTimer then
            --拉取10次后还是没有获取数据就直接终止，当前世界没有分线
            ChooseBranch.dealDataTimer:Change()
            return
        end
        ChooseBranch:DealBranchStateData()
        if ChooseBranch.timerNum == 3 then
            GameLogic.RunCommand("/wanxueshijie worldInfo")
        end
        if ChooseBranch.branchStateTable and ChooseBranch.dealDataTimer then
            if #ChooseBranch.branchStateTable > 1 then
                -- local MainUIButtons = NPL.load("(gl)Mod/CodePku/cellar/Common/TouchMiniButtons/Main.lua")
                -- MainUIButtons.ShowPage()
            end
            ChooseBranch.dealDataTimer:Change()
        end
    end})

    ChooseBranch.dealDataTimer:Change(0, 1000)
end

function ChooseBranch.OnWorldUnloaded()
    if ChooseBranch.dealDataTimer then
        ChooseBranch.dealDataTimer:Change()
        ChooseBranch.dealDataTimer = nil
    end

    -- 清空原始分线数据缓存
    ChooseBranch.branchStateTable = nil
    ChooseBranch.currBranchData = nil
    commonlib.setfield("System.Codepku.branch", nil)
end

function ChooseBranch:DealBranchStateData()
    -- todo   一堆逻辑要写
    local currWorldName = System and System.Codepku and System.Codepku.Coursewares and System.Codepku.Coursewares.name
    if System.Codepku and System.Codepku.branch and System.Codepku.branch.worldInfo and System.Codepku.branch.currWorld and System.Codepku.branch.currServer then
        -- 当前所在世界的worldkey  用来判定当前ggs的服务器数据
        -- todo 记得这个数据来判定当前世界的分支数据
        ChooseBranch.currBranchData = {}
        ChooseBranch.branchStateTable = {}

        local currWorld = System.Codepku.branch.currWorld
        local worldKey = currWorld and currWorld.worldKey
        local currInfo = {}
        for each in string.gmatch(worldKey, "%d+") do
            table.insert( currInfo, each )
        end
        ChooseBranch.currBranchData["worldId"] = tonumber(currInfo[1])
        ChooseBranch.currBranchData["worldName"] = currInfo[2]
        ChooseBranch.currBranchData["branchId"] = tonumber(currInfo[3])
        ChooseBranch.currBranchData["currWorldName"] = currWorldName
        ChooseBranch.currBranchData["serverId"] = ChooseBranch:GetServerId(System.Codepku.branch.currServer["outerIp"], System.Codepku.branch.currServer["outerPort"])
        ChooseBranch.currBranchData["ip"] = System.Codepku.branch.currServer["outerIp"]
        ChooseBranch.currBranchData["port"] = System.Codepku.branch.currServer["outerPort"]

        ChooseBranch.currChooseBranch = tonumber(ChooseBranch.currBranchData["branchId"])
        ChooseBranch.currChooseServer = tonumber(ChooseBranch.currBranchData["serverId"])


        local worldInfo = System.Codepku.branch.worldInfo
        for key,value in pairs(worldInfo) do
            for k,v in pairs(value.worlds) do
                local refInfo = {}
                for each in string.gmatch(k, "%d+") do
                    table.insert( refInfo, each )
                end
                local worldId = tonumber(refInfo[1])
                local worldName = refInfo[2]
                local branchId = tonumber(refInfo[3])
                local playerNum = v and tonumber(v.online_client_count)
                local maxPlayerNum = v and tonumber(v.max_client_count)
                if worldId == tonumber(ChooseBranch.currBranchData["worldId"]) and worldName == ChooseBranch.currBranchData["worldName"] and playerNum > 0 then
                    table.insert( ChooseBranch.branchStateTable,
                        {   
                            ["worldId"] = tonumber(worldId),
                            ["worldName"] = worldName,
                            ["branchId"] = tonumber(branchId),
                            ["playerNum"] = tonumber(playerNum),
                            ["maxPlayerNum"] = tonumber(maxPlayerNum),
                            -- ["maxPlayerNum"] = 5,
                            ["serverId"] = ChooseBranch:GetServerId(value["outerIp"], value["outerPort"]),
                            ["ip"] = value["outerIp"],
                            ["port"] = value["outerPort"],
                        } 
                    )
                end
            end
        end
        if ChooseBranch.jumpToWorldKey and ChooseBranch.jumpToWorldKey ~= System.Codepku.branch.currWorld.worldKey then
            ChooseBranch.jumpToWorldKey = nil
            GameLogic.AddBBS(nil, string.format("你选择的分线已满，你已进入%s", ChooseBranch:getBranchNameByWorldKey(System.Codepku.branch.currWorld.worldKey)), 3000, "255 0 0")
        end
    end
end

function ChooseBranch:GetHTMLStyleStr(index)
    local htmlTable = ChooseBranch.HTMLStyleData[index]
    local styleStr = ""
    for k,v in pairs(htmlTable) do
        if k ~= "desc" then
            styleStr = styleStr..k..": "..v.."; "
        end
    end
    return styleStr
end

function ChooseBranch:changeCurrBranch(name)
    local refInfo = {}
    for each in string.gmatch(name, "%d+") do
        table.insert( refInfo, each )
    end
    ChooseBranch.currChooseBranch = tonumber(refInfo[1])
    ChooseBranch.currChooseServer = tonumber(refInfo[2])
end

function ChooseBranch:changeBranch()
    -- echo("ChooseBranch:changeBranch enter")
    -- echo(ChooseBranch.currChooseBranch)
    -- echo(ChooseBranch.currChooseServer)
    for i,j in ipairs(ChooseBranch.branchStateTable) do
        if ChooseBranch.currChooseBranch == j["branchId"] and ChooseBranch.currChooseServer == j["serverId"] then
            if j["playerNum"] >= j["maxPlayerNum"] then
                GameLogic.AddBBS(nil, L"你选择的世界分线已满", 3000, "255 0 0")
                break
            end
            ChooseBranch.jumpToWorldKey = tostring(j["worldId"] or "1").."_"..tostring(j["worldName"] or "1").."_"..tostring(j["branchId"] or "1")
            GameLogic.RunCommand(string.format("/connectCodePku -manual=1 -no=%d -host=%s -port=%s %d %s", j["branchId"], j["ip"], j["port"], j["worldId"], j["worldName"]))
            break
        end
    end
end

function ChooseBranch:getBranchName(branchId, serverId)
    if not branchId or not serverId then
        return "未知世界"
    end
    local branchName = string.format("%03s",tostring(branchId))
    local serverName = string.format("%03s",tostring(serverId + 100))
    -- local serverName = (string.format("%0.1f",tostring(serverId)):gsub("%.",""))
    -- local showName = ChooseBranch.currBranchData["currWorldName"].."-"..ChooseBranch.branchNameTalbe[branchId]
    local showName = ChooseBranch.currBranchData["currWorldName"].."-"..serverName..branchName.."线"
    if commonlib.utf8.len(ChooseBranch.currBranchData["currWorldName"]) > 3 then
        -- showName = commonlib.utf8.sub(showName, 1, 3).."...-"..ChooseBranch.branchNameTalbe[branchId]
        showName = commonlib.utf8.sub(ChooseBranch.currBranchData["currWorldName"], 1, 3).."...-"..serverName..branchName.."线"
    end
    return showName
end

function ChooseBranch:getBranchNameByWorldKey(worldKey)
    local refInfo = {}
    for each in string.gmatch(worldKey, "%d+") do
        table.insert( refInfo, each )
    end
    return ChooseBranch:getBranchName(refInfo[3], ChooseBranch.currChooseServer)
end

-- 当且仅当bShow为false时为关闭页面
function ChooseBranch:ShowPage(bShow)
    --body
    -- 清空原始分线数据缓存
    ChooseBranch.branchStateTable = nil
    ChooseBranch.currBranchData = nil
    commonlib.setfield("System.Codepku.branch", nil)

    if ChooseBranch.ui then
        ChooseBranch.ui:CloseWindow()
        ChooseBranch.ui = nil
    end
    if bShow == false then
        return
    end
    params = {
        name = "branch_choose",
        url = "Mod/CodePku/cellar/GUI/Branch/ChooseBranch.html",
        alignment="_ct",
        left = -960,
        top = -540,
        width = 1920,
        height = 1080,
        zorder = 20,
    }

    ChooseBranch.ui = AdaptWindow:QuickWindow(params)

    -- 点开界面的时候拉取一遍最新的数据，先显示老数据界面，等待数据回调刷新界面
    GameLogic.RunCommand("/wanxueshijie worldInfo")

end