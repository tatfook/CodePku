--[[
Use Lib:
-------------------------------------------------------
NPL.load("(gl)Mod/CodePku/cellar/GUI/Profile/SkinPageV1.lua");
local SkinPageV1 = commonlib.gettable("Mod.CodePku.GUI.Profile.SkinPage");
SkinPageV1.ShowPage();
-------------------------------------------------------
]]

-- local SkinPageV1 = NPL.export();

NPL.load("(gl)script/apps/Aries/Creator/Game/Entity/PlayerSkins.lua");
NPL.load("(gl)script/apps/Aries/Creator/Game/Entity/EntityManager.lua");
NPL.load("(gl)script/apps/Aries/Creator/Game/Entity/PlayerAssetFile.lua");
local PlayerAssetFile = commonlib.gettable("MyCompany.Aries.Game.EntityManager.PlayerAssetFile")
local EntityManager = commonlib.gettable("MyCompany.Aries.Game.EntityManager");
local PlayerSkins = commonlib.gettable("MyCompany.Aries.Game.EntityManager.PlayerSkins")
local pe_gridview = commonlib.gettable("Map3DSystem.mcml_controls.pe_gridview");


-- local Files = commonlib.gettable("MyCompany.Aries.Game.Common.Files");

local SkinPageV1 = commonlib.gettable("Mod.CodePku.GUI.Profile.SkinPage");

SkinPageV1.cur_filename = nil;
local page;
function SkinPageV1.OnInit()
	page = document:GetPageCtrl();
	SkinPageV1.result = nil;
end

local allFiles;
function SkinPageV1.GetAllFiles()
	if(not allFiles) then
		allFiles = {}
		-- fill local files
		if(PlayerAssetFile:HasCategory('people')) then
			local items = PlayerAssetFile:GetCategoryItems('people');
			local gender = System.User and System.User.info and System.User.info.gender;
			for i, item in ipairs(items) do
				local assetfile = item.filename;
				if (string.find(assetfile, 'paperman') ~= nil) then
					if(assetfile and assetfile~="") then
						local isMale = string.find(assetfile, 'boy..') or string.find(assetfile, 'Male..') or string.find(assetfile, 'xiaolong') or string.find(assetfile, 'zaizai');
						if (tonumber(gender) ~= 2 and isMale) then -- male
							allFiles[#allFiles+1] = {name="commonfile", text=item.displayname or item.filename, filename=item.name or item.filename};
							-- allFiles[#allFiles+1] = {name="commonfile", attr={text=item.displayname or item.filename, filename=item.name or item.filename}};
						elseif (tonumber(gender) == 2 and isMale == nil) then
							allFiles[#allFiles+1] = {name="commonfile", text=item.displayname or item.filename, filename=item.name or item.filename};
							-- allFiles[#allFiles+1] = {name="commonfile", attr={text=item.displayname or item.filename, filename=item.name or item.filename}};
						end
					end
                end
			end
		end
	end
	return allFiles;
end

function SkinPageV1.GetEntity()
	return EntityManager.GetPlayer();
end

function SkinPageV1.SetText(text)
	if(page and text) then
		SkinPageV1.cur_filename = commonlib.Encoding.DefaultToUtf8(text);
		SkinPageV1.UpdateModel(text);
		
		local gridview_node = page:GetNode("gvwSkins");
		pe_gridview.DataBind(gridview_node, "gvwSkins", false);
	end
end

-- @param modelName: filename of the model, if nil, it is SkinPageV1.modelFilename
function SkinPageV1.UpdateModel(modelName)
	local filepath = PlayerAssetFile:GetValidAssetByString(modelName or SkinPageV1.modelFilename);
	if(filepath) then
		local ctl = page:FindControl("AssetPreview");
		if(ctl) then
			local ReplaceableTextures, CCSInfoStr;
			if(PlayerAssetFile:IsCustomModel(filepath)) then
				CCSInfoStr = PlayerAssetFile:GetDefaultCCSString()
			elseif(PlayerSkins:CheckModelHasSkin(filepath)) then
				-- TODO:  hard code worker skin here
				ReplaceableTextures = {[2] = PlayerSkins:GetSkinByID(12)};
			end
			ctl:ShowModel({AssetFile = filepath, IsCharacter=true, x=0, y=0, z=0, ReplaceableTextures=ReplaceableTextures, CCSInfoStr=CCSInfoStr});
			SkinPageV1.RefreshAnims(filepath);
		end
	end	
end

function SkinPageV1.RefreshAnims(filepath, tryCount)
	if(not page) then
		return
	end
	SkinPageV1.curModelAssetFile = filepath;
	local self = SkinPageV1;
	self.tryCount = tryCount;
	local asset = ParaAsset.LoadParaX(filepath, filepath);
	asset:LoadAsset();
	if(asset:IsValid() and asset:IsLoaded())then
		local polyCount = asset:GetAttributeObject():GetField("PolyCount", 0);
		if(page) then
			page:SetUIValue("PolyCount", polyCount);
		end
	elseif(asset:IsValid()) then
		self.curFilePath = filepath;
		if(not tryCount) then
			-- only try 5 times
			self.tryCount = 5;
		end
		self.mytimer = self.mytimer or commonlib.Timer:new({callbackFunc = function(timer)
			if(self.tryCount and self.tryCount > 1) then
				SkinPageV1.RefreshAnims(self.curFilePath, self.tryCount - 1)
			end
		end})
		self.mytimer:Change(500);
	end
end

function SkinPageV1.OnOK()
	if(SkinPageV1.cur_filename) then
		local filepath = PlayerAssetFile:GetValidAssetByString(SkinPageV1.cur_filename);
		SkinPageV1.result = filepath;
		
		local player = SkinPageV1.GetEntity();
		local lastFilepath = player:GetMainAssetPath();

		if(filepath ~= lastFilepath) then
			GameLogic.RunCommand("/avatar "..filepath);
		end
		
		page:CloseWindow();
	end
end

function SkinPageV1.ShowPage(OnClose)
	local params = {
			url = "Mod/CodePku/cellar/GUI/Profile/SkinPageV1.html", 
			name = "SkinPageV1.ShowPage", 
			isShowTitleBar = false,
			DestroyOnClose = true,
			--bToggleShowHide=true, 
			style = CommonCtrl.WindowFrame.ContainerStyle,
			allowDrag = false,
			enable_esc_key = true,
			--bShow = bShow,
			click_through = false, 
			zorder = 21,
			app_key = MyCompany.Aries.Creator.Game.Desktop.App.app_key, 
			directPosition = true,
			align = "_ct",
			x = -830/2,
			y = -480/2,
			width = 830,
			height = 480,
		};
	System.App.Commands.Call("File.MCMLWindowFrame", params);

	params._page.OnClose = function()
		if(OnClose) then
			OnClose(SkinPageV1.result);
		end
	end

	local player = SkinPageV1.GetEntity();
	local lastFilepath = player:GetMainAssetPath();
	SkinPageV1.SetText(lastFilepath);
end