local DialogMessages = commonlib.gettable("Mod.CodePku.Common.MainUIButtons.DialogMessages")
local request = NPL.load("(gl)Mod/CodePku/api/BaseRequest.lua");

-- 测试数据
DialogMessages.messages = {
    [1] = {speakerIsMe=0, dialog='你好啊',avatar='codepku/image/textures/tmp_icon.jpg', nickname='54'},
    [2] = {speakerIsMe=1, dialog='你谁？',avatar='codepku/image/textures/userinfo/wanjiatouxiang.png', nickname='67'},
}