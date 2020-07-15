NPL.load("Mod/GeneralGameServerMod/Core/Client/NetClientHandler.lua");
local NetClientHandler = commonlib.inherit(commonlib.gettable("Mod.GeneralGameServerMod.Core.Client.NetClientHandler"), commonlib.gettable("Mod.CodePku.Online.NetClientHandler"));

local moduleName = "Mod.CodePku.Online.NetClientHandler";

-- 构造函数
function NetClientHandler:ctor()
end

function NetClientHandler:GetUserInfo()
    return System.User;
end