--[[
Author:zouren
Date: 2020-10-10 15:50:41
Des: 资源预加载 防止后期游戏卡顿 使用paracraft原生了AssertPreloader来实现
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/AssertManage/CodePkuAssertPreloader.lua")
local CodePkuAssertPreloader = commonlib.gettable("Mod.CodePku.AssertManage.CodePkuAssertPreloader")
CodePkuAssertPreloader.getSingleTon():PreloadAssert()

NPL.activate("(gl)Mod/CodePku/cellar/AssertManage/CodePkuAssertPreloader.lua")
-----------------------------------
]]--
NPL.load("(gl)script/ide/AssetPreloader.lua")
local CodePkuAssertPreloader = commonlib.inherit(nil, commonlib.gettable("Mod.CodePku.AssertManage.CodePkuAssertPreloader"))

function CodePkuAssertPreloader:ctor()
end

-- 单例模式
local newInstance
function CodePkuAssertPreloader.getSingleTon()
    if (not newInstance) then
        newInstance = CodePkuAssertPreloader:new():init()
    end
    return newInstance
end

--[[
    @desc 初始化
    time:2020-10-12 11:25:12
    return 
]]
function CodePkuAssertPreloader:init()
    self.xmlFile = "Mod/CodePku/cellar/AssertManage/CodePkuPreloadAsserts.xml"

    self.loader = commonlib.AssetPreloader:new({
        callbackFunc = function(nItemsLeft, loader)
            log(nItemsLeft.." assets remaining\n")
            if(nItemsLeft <= 0) then
                log("all finished \n")
            end
        end
    });

    local xmlRoot = ParaXML.LuaXML_ParseFile(self.xmlFile)

    self.textureList = {}
    for node in commonlib.XPath.eachNode(xmlRoot, "//asserts/textures") do
        if node.attr and node.attr.name == "gameStart" then
            for itemNode in commonlib.XPath.eachNode(node, "/item") do
                -- echo(itemNode[1])
                table.insert(self.textureList, itemNode[1])
            end
        end
    end
    
    return self
end

--[[
    @desc 预加载所有需要的资源
    time:2020-10-12 09:25:12
    return 
]]
function CodePkuAssertPreloader:PreloadAssert()
    LOG.std(nil, "CodePkuAssertPreloader", "PreloadAssert", "Enter")
    GameLogic.options:EnableAsyncAssetLoader(true)
    self:AddTextures()
    
    self.loader:Start()
end

--[[
    @desc 预加载所有需要加载的图片
    time:2020-10-12 09:26:49
    return 
]]
function CodePkuAssertPreloader:AddTextures()
    for _i,_v in pairs(self.textureList) do
        echo(_v)
        self.loader:AddAssets(ParaAsset.LoadTexture("",_v,1))
    end
end

local function activate()
    CodePkuAssertPreloader.getSingleTon():PreloadAssert()
end

NPL.this(activate)