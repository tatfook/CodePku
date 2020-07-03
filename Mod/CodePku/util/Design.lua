local Design = NPL.export();
local Screen = commonlib.gettable("System.Windows.Screen")

--设计图大小
Design.width = 1920;
Design.height = 1080;

--获取当前屏幕宽度与设计图宽度比
--@param width 自定义设计图宽度
function Design:getWidthRate(width)
    if not width then
        width = Design.width
    end
    return Screen:GetWidth() / width;
end

--获取当前屏幕高度与设计图宽度比
--@param height 自定义设计图高度
function Design:getHeightRate(height)
    if not height then
        height = Design.height
    end
    return Screen:GetHeight() / height;
end

--获取适配当前屏幕的宽度
--@param width 宽度
function Design:adapterWidth(width)
    return width * Design.getWidthRate();
end

--获取适配当前屏幕的高度
--@param height 高度
function Design:adapterHeight(height)
    return height * Design.getHeightRate();
end