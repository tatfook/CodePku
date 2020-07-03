--[[
Title: store
Author(s):  big
Date:  2018.6.20
City: Foshan 
use the lib:
------------------------------------------------------------
local Store = NPL.load("(gl)Mod/WorldShare/store/Store.lua")
------------------------------------------------------------
]]
NPL.load("./UserStore.lua")
NPL.load("./PageStore.lua")
NPL.load("./WorldStore.lua")

local UserStore = commonlib.gettable("Mod.CodePku.store.User")
local PageStore = commonlib.gettable("Mod.CodePku.store.Page")
local WorldStore = commonlib.gettable("Mod.CodePku.store.World")
local LessonStore = commonlib.gettable("Mod.CodePku.store.Lesson")

local Store = NPL.export()

Store.storeList = {
    user = UserStore,
    world = WorldStore,
    lesson = LessonStore
}

function Store:Set(key, value)
    if (not key) then
        return false
    end

    local storeType = self:GetStoreType(key)
    local storeKey = self:GetStoreKey(key)

    if storeType == "page" then
        PageStore[storeKey] = value
        return true
    end

    if self.storeList[storeType] then
        self.storeList[storeType][storeKey] = commonlib.copy(value)
    end
end

function Store:Get(key)
    if (not key) then
        return false
    end

    local storeType = self:GetStoreType(key)
    local storeKey = self:GetStoreKey(key)

    if storeType == "page" then
        return PageStore[storeKey]
    end

    if self.storeList[storeType] then
        return commonlib.copy(self.storeList[storeType][storeKey])
    end

    return nil
end

function Store:Action(key)
    if (not key) then
        return false
    end

    local storeType = self:GetStoreType(key)
    local storeKey = self:GetStoreKey(key)

    if self.storeList[storeType] then
        local CurStore = self.storeList[storeType]
        local CurFun = CurStore:Action()[storeKey]

        if type(CurFun) == 'function' then
            return CurFun
        end
    end
end

function Store:Getter(key)
    if (not key) then
        return false
    end

    local storeType = self:GetStoreType(key)
    local storeKey = self:GetStoreKey(key)

    if self.storeList[storeType] then
        local CurStore = self.storeList[storeType]
        local CurFun = CurStore:Getter()[storeKey]

        if type(CurFun) == 'function' then
            return CurFun()
        end
    end
end

function Store:Remove(key)
    self:Set(key, nil)
end

function Store:GetStorePath(key)
    if (type(key) ~= "string") then
        return false
    end

    local keyTable = {}

    for item in string.gmatch(key, "[^/]+") do
        keyTable[#keyTable + 1] = item
    end

    return keyTable
end

function Store:GetStoreType(key)
    local keyTable = self:GetStorePath(key)

    if (keyTable[1]) then
        return keyTable[1]
    else
        return nil
    end
end

function Store:GetStoreKey(key)
    local keyTable = self:GetStorePath(key)

    if (keyTable[2]) then
        return keyTable[2]
    else
        return nil
    end
end
