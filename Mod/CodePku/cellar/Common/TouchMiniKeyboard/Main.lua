NPL.load("./DirectionKeyboard.lua");
NPL.load("./DirectionRocker.lua");
NPL.load("./FeatKeyboard.lua");
NPL.load("./TouchVirtualKeyboardIcon.lua");
local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");

local DirectionKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionKeyboard");
local DirectionRocker = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.DirectionRocker");
local FeatKeyboard = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.FeatKeyboard");
local TouchVirtualKeyboardIcon = commonlib.gettable("Mod.CodePku.Common.TouchMiniKeyboard.TouchVirtualKeyboardIcon");

local TouchMiniKeyboard = NPL.export();

function TouchMiniKeyboard:show(show)
    if show then
        local isShow = GameLogic.GetPlayerController():LoadLocalData('isDirectionKeyboard',false,true);
        if isShow then
            DirectionKeyboard.getSingleton():show(show);
            DirectionRocker.getSingleton():show(not show);
        else
            DirectionKeyboard.getSingleton():show(not show);
            DirectionRocker.getSingleton():show(show);
        end
        GameLogic.RunCommand("/show keyboard");
        if System.Codepku then
            if System.Codepku.isLoadingHome then
                FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
            else
                if System.Codepku and System.Codepku.Coursewares then
                    local category = System.Codepku.Coursewares.category;
                    if category == 2 then
                        FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
                    elseif category == 3 then
                        FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                    elseif category == 4 then
                        FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                    elseif category == 5 then
                        FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                    elseif category == 6 then
                        FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                    -- elseif category == 7 then
                        -- FeatKeyboard.getSingleton():show(show, true, false, false, true);
                    elseif category == 8 then
                        FeatKeyboard.getSingleton():show(show, true, false, false, false, false);
                        GameLogic.RunCommand("/hide keyboard");
                        local icon = TouchVirtualKeyboardIcon.GetSingleton();
                        icon:ShowKeyboard(false)
                    else
                        FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                    end
                else

                end
            end
        else
            FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
        end
    end
end

function TouchMiniKeyboard.CheckShow(show,isDirectionKeyboard )
    -- GameLogic.GetPlayerController():SaveLocalData('isDirectionKeyboard',true,true)
    if show then
        local isShow = GameLogic.GetPlayerController():LoadLocalData('isDirectionKeyboard',false,true);
        local isEmployee = System.User and System.User.info and System.User.info.is_employee;
        
        if isShow then
            DirectionKeyboard.getSingleton():show(show);
            DirectionRocker.getSingleton():show(not show);
        else
            DirectionKeyboard.getSingleton():show(not show);
            DirectionRocker.getSingleton():show(show);
        end
        GameLogic.RunCommand("/show keyboard");
        if isEmployee ~= 1 then    
            if System.Codepku then
                if System.Codepku.isLoadingHome then
                    FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
                else
                    if System.Codepku and System.Codepku.Coursewares then
                        local category = System.Codepku.Coursewares.category;
                        if category == 2 then
                            FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
                        elseif category == 3 then
                            FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                        elseif category == 4 then
                            FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                        elseif category == 5 then
                            FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                        elseif category == 6 then
                            FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                        -- elseif category == 7 then
                            -- FeatKeyboard.getSingleton():show(show, true, false, false, true);
                        elseif category == 8 then
                            FeatKeyboard.getSingleton():show(show, true, false, false, false, false);
                            -- GameLogic.RunCommand("/hide keyboard");
                            local icon = TouchVirtualKeyboardIcon.GetSingleton();
                            icon:GetUIControl():GetChild("text").visitor = false
                            icon:ShowKeyboard(false)
                        else
                            FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                        end
                    else

                    end
                end
            else
                FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
            end
        else
            FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
        end
    end
end