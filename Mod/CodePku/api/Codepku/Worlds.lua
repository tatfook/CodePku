--[[
Title: Codepku Worlds API
Author(s):  huangjunm
Date:  2020.05.31
use the lib:
------------------------------------------------------------
local KeepworkWorldsApi = NPL.load("(gl)Mod/CodePku/api/Keepwork/Worlds.lua")
------------------------------------------------------------
]]

local CodePkuBaseApi = NPL.load('./BaseApi.lua')

local CodePkuWorldsApi = NPL.export()

function CodePkuWorldsApi:GetByKeepworkProjectId(keepworkProjectId, success, error)
    CodePkuBaseApi:Get("/worlds/keepwork/"..keepworkProjectId, nil, { notTokenRequest = false }, success, error)
end

function CodePkuWorldsApi:GetCourseEntryWorld(success, error)
    LOG.std(nil, "info", "codepku", "worlds api getCourseEntryWorld")
    CodePkuBaseApi:Get("/worlds/course-entry", nil, { notTokenRequest = false }, success, error, {503, 404, 500})
end