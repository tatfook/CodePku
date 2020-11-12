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
    -- DirectionKeyboard.getSingleton():show(show);
    DirectionRocker.getSingleton():show(show);
    FeatKeyboard.getSingleton():show(show);
end

function TouchMiniKeyboard.CheckShow(show,isDirectionKeyboard )
    -- GameLogic.GetPlayerController():SaveLocalData('isDirectionKeyboard',true,true)
    local isShow = GameLogic.GetPlayerController():LoadLocalData('isDirectionKeyboard',false,true);
    echo("isShow")
    echo(isShow)
    if isShow then
        DirectionKeyboard.getSingleton():show(show);
        DirectionRocker.getSingleton():show(not show);
    else
        DirectionKeyboard.getSingleton():show(not show);
        DirectionRocker.getSingleton():show(show);
    end

    if System.Codepku then
        if HomeManage:IsMyHome() and show then
            FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
        else
            if System.Codepku and System.Codepku.Coursewares then
                echo("System.Codepku.Coursewares.category"..System.Codepku.Coursewares.category)
                local category = System.Codepku.Coursewares.category;
                if category == 2 then
                    echo(category)
                    FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
                elseif category == 3 then
                    echo(category)

                    FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                elseif category == 4 then
                    echo(category)

                    FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                elseif category == 5 then
                    echo(category)

                    FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                elseif category == 6 then
                    echo(category)

                    FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                -- elseif category == 7 then
                    -- FeatKeyboard.getSingleton():show(show, true, false, false, true);
                elseif category == 8 then
                    echo(category)

                    FeatKeyboard.getSingleton():show(show, true, false, false, false, false);
                    -- TouchVirtualKeyboardIcon:Show(false)
                    -- TouchVirtualKeyboardIcon:ShowKeyboard(false)
                else
                    echo(category)

                    FeatKeyboard.getSingleton():show(show, true, false, false, true, false);
                end
            end
        end
    else
        FeatKeyboard.getSingleton():show(show, true, true, true, true, false);
    end
    -- FeatKeyboard.getSingleton():show(show);

    -- local TouchVirtualKeyboardIcon = GameLogic.GetFilters():apply_filters("TouchVirtualKeyboardIcon");
end