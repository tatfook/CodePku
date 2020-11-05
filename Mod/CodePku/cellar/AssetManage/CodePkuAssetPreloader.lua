--[[
Author:zouren
Date: 2020-10-10 15:50:41
Des: 资源预加载 防止后期游戏卡顿 使用paracraft原生了AssetPreloader来实现
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/AssetManage/CodePkuAssetPreloader.lua")
local CodePkuAssetPreloader = commonlib.gettable("Mod.CodePku.AssetManage.CodePkuAssetPreloader")
CodePkuAssetPreloader.getSingleTon():PreloadAsset()

NPL.activate("(gl)Mod/CodePku/cellar/AssetManage/CodePkuAssetPreloader.lua")
-----------------------------------
]]--
NPL.load("(gl)script/ide/AssetPreloader.lua")
local CodePkuAssetPreloader = commonlib.inherit(nil, commonlib.gettable("Mod.CodePku.AssetManage.CodePkuAssetPreloader"))

function CodePkuAssetPreloader:ctor()
end

-- 单例模式
local newInstance
function CodePkuAssetPreloader.getSingleTon()
    if (not newInstance) then
        newInstance = CodePkuAssetPreloader:new():init()
    end
    return newInstance
end

--[[
    @desc 初始化
    time:2020-10-12 11:25:12
    return 
]]
function CodePkuAssetPreloader:init()
    self.xmlFile = "Mod/CodePku/cellar/AssetManage/CodePkuPreloadAssets.xml"

    self.loader = commonlib.AssetPreloader:new({
        callbackFunc = function(nItemsLeft, loader)
            log(nItemsLeft.." assets remaining\n")
            if(nItemsLeft <= 0) then
                local DownloadWorld = commonlib.gettable("MyCompany.Aries.Game.MainLogin.DownloadWorld")
                DownloadWorld.Close()
                log("all finished \n")
            end
        end
    });

    local xmlRoot = ParaXML.LuaXML_ParseFile(self.xmlFile)

    self.textureList = {}
    for node in commonlib.XPath.eachNode(xmlRoot, "//assets/textures") do
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
function CodePkuAssetPreloader:PreloadAsset()
    LOG.std(nil, "CodePkuAssetPreloader", "PreloadAsset", "Enter")
    GameLogic.options:EnableAsyncAssetLoader(true)
    self:AddTextures()
    
    self.loader:Start()
end

--[[
    @desc 预加载所有需要加载的图片
    time:2020-10-12 09:26:49
    return 
]]
function CodePkuAssetPreloader:AddTextures()
    for _i,_v in pairs(self.textureList) do
        echo(_v)
        self.loader:AddAssets(ParaAsset.LoadTexture("",_v,1))
    end
end

local function activate()
    CodePkuAssetPreloader.getSingleTon():PreloadAsset()
end

NPL.this(activate)