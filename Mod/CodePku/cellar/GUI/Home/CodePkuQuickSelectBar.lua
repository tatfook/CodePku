--[[
Author:zouren
Date: 2020-09-24 11:10:53
Des: 定制玩学世界自己的物品快速选择栏
use the lib:
------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Home/CodePkuQuickSelectBar.lua")
local CodePkuQuickSelectBar = commonlib.gettable("Mod.CodePku.GUI.CodePkuQuickSelectBar")
CodePkuQuickSelectBar:ShowPage()
-----------------------------------
]]--
-- local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua")
local AdaptWindow = commonlib.gettable("Mod.CodePku.GUI.Window.AdaptWindow")

local CodePkuQuickSelectBar = commonlib.gettable("Mod.CodePku.GUI.CodePkuQuickSelectBar")

CodePkuQuickSelectBar.ui = nil
CodePkuQuickSelectBar.static_view_len = 9
CodePkuQuickSelectBar.customBtnNodes = {}

for i in range(CodePkuQuickSelectBar.static_view_len) do
    table.insert(CodePkuQuickSelectBar.customBtnNodes, {["index"]=i,["name"]="quickItem"..tostring(i)})
end

CodePkuQuickSelectBar.imagePath = "codepku/image/textures/bag/bag.png"

-- 图片url数据table
CodePkuQuickSelectBar.iconData = {
    [1] = {url=CodePkuQuickSelectBar.imagePath, left=1, top=1, width=1572, height=872, name="background.png", desc="背包北京",},
    [2] = {url=CodePkuQuickSelectBar.imagePath, left=1575, top=377, width=85, height=127, name="bagbtn.png", desc="背包按钮",},
    [3] = {url=CodePkuQuickSelectBar.imagePath, left=1575, top=120, width=160, height=99, name="bluebg.png", desc="蓝色按钮背景",},
    [4] = {url=CodePkuQuickSelectBar.imagePath, left=1731, top=367, width=132, height=131, name="blueitembg.png", desc="蓝色物品背景",},
    [5] = {url=CodePkuQuickSelectBar.imagePath, left=1865, top=400, width=68, height=78, name="exit.png", desc="退出按钮",},
    [6] = {url=CodePkuQuickSelectBar.imagePath, left=1, top=875, width=1523, height=196, name="quickbarbg.png", desc="快捷物品栏背景",},
    [7] = {url=CodePkuQuickSelectBar.imagePath, left=1575, top=1, width=434, height=117, name="title.png", desc="标题背景",},
    [8] = {url=CodePkuQuickSelectBar.imagePath, left=1899, top=120, width=144, height=144, name="whitebordbig.png", desc="大白色边框",},
    [9] = {url=CodePkuQuickSelectBar.imagePath, left=1877, top=266, width=132, height=132, name="whitebordsmall.png", desc="小白色边框",},
    [10] = {url=CodePkuQuickSelectBar.imagePath, left=1737, top=120, width=160, height=99, name="yellowbg.png", desc="黄色按钮背景",},
    [11] = {url=CodePkuQuickSelectBar.imagePath, left=1575, top=221, width=154, height=154, name="yellowbord.png", desc="黄色边框",},
    [12] = {url=CodePkuQuickSelectBar.imagePath, left=1731, top=221, width=144, height=144, name="yellowitembg.png", desc="黄色物品背景",},
}

-- 设置html文件的对应组件的style属性
CodePkuQuickSelectBar.styleData = {
    ["quickbarbg"] = {"position: relative;", "left: 0;", "top: 0;", "width: 1523;", "height: 196;", ["backgroundIndex"]=6},
    ["bagbtn"] = {"position: relative;", "left: 49;", "top: 37;", "width: 85;", "height: 127;", ["backgroundIndex"]=2},
    ["itemblueitembg"] = {"width: 132;", "height: 131;", ["backgroundIndex"]=4},
    ["itemwhitebordsmall"] = {"width: 132;", "height: 132;", ["backgroundIndex"]=9},
    ["itemyellowbord"] = {"width: 154;", "height: 154;", ["backgroundIndex"]=11},
}

-- init default value
function CodePkuQuickSelectBar:OnInit()
    GameLogic.events:AddEventListener("game_mode_change", CodePkuQuickSelectBar.OnGameModeChanged, CodePkuQuickSelectBar, "CodePkuQuickSelectBar");
	GameLogic.events:AddEventListener("OnHandToolIndexChanged", CodePkuQuickSelectBar.OnHandToolIndexChanged, QuickSeCodePkuQuickSelectBarlectBar, "CodePkuQuickSelectBar");
end

function CodePkuQuickSelectBar.Refresh(nDelayTime)
	if(CodePkuQuickSelectBar.ui) then
		CodePkuQuickSelectBar.ui:Refresh(nDelayTime or 0.01);
	end
end

--[[
    @desc 游戏模式更改是触发的事件
    time:2020-09-27 10:06:21
    return 
]]
function CodePkuQuickSelectBar:OnGameModeChanged()
	if(CodePkuQuickSelectBar.ui) then
		if(CodePkuQuickSelectBar.ui:IsVisible()) then 
			if(not GameLogic.GameMode:IsEditor()) then
				CodePkuQuickSelectBar.ShowPage(false);
				return;
			end
		else
			if(GameLogic.GameMode:IsEditor()) then
				CodePkuQuickSelectBar.ShowPage(true);
				return;
			end
		end
	end
	CodePkuQuickSelectBar.Refresh();
end

function CodePkuQuickSelectBar:OnHandToolIndexChanged(event)
    if(CodePkuQuickSelectBar.ui) then
        -- todo 按照自己的逻辑修改高亮的框框位置
		-- local ctl = CodePkuQuickSelectBar.ui:FindControl("handtool_highlight_bg");
	end
end

--[[
    @desc 获取HTML文件中组件的对应style属性str
    time:2020-09-25 11:41:40
    @divName: 组件对应名字
    return 最终的HTML的组件style字符串
]]
function CodePkuQuickSelectBar:GetHTMLDivStyle(divName)
    local style = ""
    local styleTable = CodePkuQuickSelectBar.styleData[divName]
    if styleTable then
        style = table.concat(styleTable)
        if styleTable["backgroundIndex"] then
            style = style.."background: url("..CodePkuQuickSelectBar:GetIconUrl(styleTable["backgroundIndex"])..");"
        end
    end
    LOG.std(nil, "CodePkuQuickSelectBar", "GetIconUrl", "style = %s", style)
    -- GameLogic.AddBBS("nil", style, 3000, "#ff0000");
    return style
end

--[[
    @desc 获取HTML文件里边的图片URL
    time:2020-09-25 11:13:18
    @index:对应iconData里边的index
    return 
]]
function CodePkuQuickSelectBar:GetIconUrl(index)
	local path = ""
    index = tonumber(index)
    path = path..CodePkuQuickSelectBar.iconData[index].url
    if CodePkuQuickSelectBar.iconData[index].left then
      path = path..'#'
      path = path..tostring(CodePkuQuickSelectBar.iconData[index].left)
      path = path..' '..tostring(CodePkuQuickSelectBar.iconData[index].top)
      path = path..' '..tostring(CodePkuQuickSelectBar.iconData[index].width)
      path = path..' '..tostring(CodePkuQuickSelectBar.iconData[index].height)
    end
    LOG.std(nil, "CodePkuQuickSelectBar", "GetIconUrl", "path = %s", path)
    return path
end

-- 当且仅当bShow为false时为关闭页面
function CodePkuQuickSelectBar:ShowPage(bShow)
    --body
    if CodePkuQuickSelectBar.ui then
        CodePkuQuickSelectBar.ui:CloseWindow()
        CodePkuQuickSelectBar.ui = nil
    end
    if bShow==false then
        return
    end
    params = {
        url = "Mod/CodePku/cellar/GUI/Home/CodePkuQuickSelectBar.html",
        alignment="_lt",
        left = 199,
        top = 884,
        width = 1523,
        height = 196,
        zorder = 20,
    }

    CodePkuQuickSelectBar.ui = AdaptWindow:QuickWindow(params)
end
