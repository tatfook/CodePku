-- title: 日志输出封装
-- author: John Mai
-- date: 2020-05-27 17:42:28
-- desc: 
-- use case: [[
    -- local Log = NPL.load("(gl)Mod/CodePku/util/Log.lua");
    -- Log.trace("trace log info");
    -- Log.debug("debug log info");
    -- Log.info("info log info");
    -- Log.warn("warn log info");
    -- Log.error("error log info");
    -- Log.fatal("fatal log info");
-- ]]

local Log = NPL.export();

Log.usecolor = true
Log.outfile = nil
Log.level = "trace"


local modes = {
  { name = "trace", color = "\27[34m", },
  { name = "debug", color = "\27[36m", },
  { name = "info",  color = "\27[32m", },
  { name = "warn",  color = "\27[33m", },
  { name = "error", color = "\27[31m", },
  { name = "fatal", color = "\27[35m", },
}


local levels = {}
for i, v in ipairs(modes) do
  levels[v.name] = i
end


local round = function(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
end


local _tostring = tostring

local tostring = function(...)
  local t = {}
  for i = 1, select('#', ...) do
    local x = select(i, ...)
    if type(x) == "number" then
      x = round(x, .01)
    end
    t[#t + 1] = _tostring(x)
  end
  return table.concat(t, " ")
end


for i, x in ipairs(modes) do
  local nameupper = x.name:upper()
  Log[x.name] = function(...)
    
    if i < levels[Log.level] then
      return
    end

    local msg = tostring(...)
    local info = debug.getinfo(2, "Sl")
    local lineinfo = info.short_src .. ":" .. info.currentline

    print(string.format("%s[%-6s%s]%s %s: %s",
                        Log.usecolor and x.color or "",
                        nameupper,
                        os.date("%Y-%m-%d %H:%M:%S"),
                        Log.usecolor and "\27[0m" or "",
                        lineinfo,
                        msg))

    if Log.outfile then
      local fp = io.open(Log.outfile, "a")
      local str = string.format("[%-6s%s] %s: %s\n",
                                nameupper, os.date(), lineinfo, msg)
      fp:write(str)
      fp:close()
    end

  end
end