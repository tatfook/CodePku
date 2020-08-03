-- Port of https://github.com/rhysbrettbowen/promise_impl/blob/master/promise.js
-- and https://github.com/rhysbrettbowen/Aplus
--

local Promise = commonlib.inherit({}, NPL.export());
local promise = {};

promise.is_promise = true;
Promise.is_promise = true;

-- next replacer
--  1) replace standard .then() when promised
local PENDING = {}
local nil_promise = {}

local function promised(value, action)
	local ok, result = pcall(action, value)
	return ok and Promise.resolve(result) or Promise.reject(result) -- .. '.\n' .. debug.traceback())
end

local function promised_s(self, onFulfilled)
	return onFulfilled and promised(self, onFulfilled) or self
end

local function promised_y(self, onFulfilled)
	return onFulfilled and promised(self[1], onFulfilled) or self
end

local function promised_n(self, _, onRejected)
	return onRejected and promised(self[1], onRejected) or self
end

-- inext() list all elementys in array
--	*) next() will list all members for table without order
--	*) @see iter(): http://www.lua.org/pil/7.3.html
local inext = ipairs{}

-- put resolved value to p[1], or push lazyed calls/object to p[]
--	1) if resolved a no pending promise, direct call promise.next()
local function resolver(this, resolved, sure)
	local typ = type(resolved)
	if (typ == 'table' and resolved.next) then
		local lazy = {this,
			function(value) return resolver(this, value, true) end,
			function(reason) return resolver(this, reason, false) end}
		if resolved[1] == PENDING then
			table.insert(resolved, lazy) -- lazy again
		else -- deep resolve for promise instance, until non-promise
			resolved:next(lazy[2], lazy[3])
		end
	else -- resolve as value
		if this[1] == PENDING then -- put value once only
			this[1], this.next = resolved, sure and promised_y or promised_n
		end
		for i, lazy, action in inext, this, 1 do -- extract 2..n
			action = (sure and lazy[2]) or (not sure and lazy[3])
			pcall(resolver, lazy[1], action and promised(resolved, action) or
				(sure and Promise.resolve or Promise.reject)(resolved), sure)
			this[i] = nil
		end
	end
end

-- for Promise.all/race, ding coroutine again and again
local function coroutine_push(co, promises)
	-- push once
	coroutine.resume(co)

	-- and try push all
	--	1) resume a dead coroutine is safe always.
	-- 	2) if promises[i] promised, skip it
	local resume_y = function(value) coroutine.resume(co, true, value) end
	local resume_n = function(reason) coroutine.resume(co, false, reason) end
	for i = 1, #promises do
		if promises[i][1] == PENDING then
			promises[i]:next(resume_y, resume_n)
		end
	end
end

-- promise as meta_table of all instances
promise.__index = promise
-- reset __len meta-method
--	1) lua 5.2 or LuaJIT 2 with LUAJIT_ENABLE_LUA52COMPAT enabled
--	2) need table-len patch in 5.1x, @see http://lua-users.org/wiki/LuaPowerPatches
-- promise.__len = function() return 0 end

-- promise for basetype
local number_promise = setmetatable({next = promised_y}, promise)
local true_promise   = setmetatable({next = promised_y, true}, promise)
local false_promise  = setmetatable({next = promised_y, false}, promise)
number_promise.__index = number_promise
nil_promise.next = promised_y
getmetatable('').__index.next = promised_s
getmetatable('').__index.catch = function(self) return self end
setmetatable(nil_promise, promise)

------------------------------------------------------------------------------------------
-- instnace method
--	1) promise:next(onFulfilled, onRejected)
--	2) promise:catch(onRejected)
------------------------------------------------------------------------------------------

function promise:next(onFulfilled, onRejected)
	local lazy = {{PENDING}, onFulfilled, onRejected}
	table.insert(self, lazy)
	return setmetatable(lazy[1], promise) -- <lazy[1]> is promise2
end

function promise:catch(onRejected)
	return self:next(nil, onRejected)
end

------------------------------------------------------------------------------------------
-- class method
--	1) Promise.resolve(value)
--	2) Promise.reject(reason)
--	3) Promise.all()
------------------------------------------------------------------------------------------

-- resolve() rules:
--	1) promise object will direct return
-- 	2) thenable (with/without string) object
-- 		- case 1: direct return, or
--		- case 2: warp as resolved promise object, it's current selected.
-- 	3) warp other(nil/boolean/number/table/...) as resolved promise object
function Promise.resolve(value)
	local valueType = type(value)
	if valueType == 'nil' then
		return nil_promise
	elseif valueType == 'boolean' then
		return value and true_promise or false_promise
	elseif valueType == 'number' then
		return setmetatable({(value)}, number_promise)
	elseif valueType == 'string' then
		return value
	elseif (valueType == 'table') and (value.next ~= nil) then
		return value.catch ~= nil and value -- or, we can direct return value
			or setmetatable({catch=promise.catch}, {__index=value})
	else
		return setmetatable({next=promised_y, value}, promise)
	end
end

function Promise.reject(reason)
	return setmetatable({next=promised_n, reason}, promise)
end

function Promise.all(arr)
	local this, promises, count = setmetatable({PENDING}, promise), {}, #arr
	local co = coroutine.create(function()
		local i, result, sure, last = 1, {}, true, 0
		while i <= count do
			local promise, typ, reason, resolved = promises[i], type(promises[i])
			if typ == 'table' and promise.next and promise[1] == PENDING then
				sure, reason = coroutine.yield()
				if not sure then
					return resolver(this, {index = i, reason = reason}, sure)
				end
				-- dont inc <i>, continue and try pick again
			else
				-- check reject/resolve of promsied instance
				--	*) TODO: dont access promise[1] or promised_n
				sure = (typ == 'string') or (typ == 'table' and promise.next ~= promised_n)
				resolved = (typ == 'string') and promise or promise[1]
				if not sure then
					return resolver(this, {index = i, reason = resolved}, sure)
				end
				-- pick result from promise, and push once
				result[i] = resolved
				if result[i] ~= nil then last = i end
				i = i + 1
			end
		end
		-- becuse 'result[x]=nil' will reset length to first invalid, so need reset it to last
		-- 	1) invalid: setmetatable(result, {__len=function() retun count end})
		-- 	2) obsoleted: table.setn(result, count)
		resolver(this, sure and {unpack(result, 1, last)} or result, sure)
	end)

	-- init promises and push
	for i, item in ipairs(arr) do promises[i] = Promise.resolve(item) end
	coroutine_push(co, promises)
	return this
end

function Promise.race(arr)
	local this, result, count = setmetatable({PENDING}, promise), {}, #arr
	local co = coroutine.create(function()
		local i, sure, resolved = 1
		while i < count do
			local promise, typ = result[i], type(result[i])
			if typ == 'table' and promise.next and promise[1] == PENDING then
				sure, resolved = coroutine.yield()
			else
				-- check reject/resolve of promsied instance
				--	*) TODO: dont access promise[1] or promised_n
				sure = (typ == 'string') or (typ == 'table' and promise.next ~= promised_n)
				resolved = typ == 'string' and promise or promise[1]
			end
			-- pick resolved once only
			break
		end
		resolver(this, resolved, sure)
	end)

	-- init promises and push
	for i, item in ipairs(arr) do promises[i] = Promise.resolve(item) end
	coroutine_push(co, promises)
	return this
end

------------------------------------------------------------------------------------------
-- constructor method
--	1) Promise.new(func)
--		(*) new() will try execute <func>, but next() is lazyed.
------------------------------------------------------------------------------------------
function Promise.new(func)
	local this = setmetatable({PENDING}, promise)
	local ok, result = pcall(func,
		function(value) return resolver(this, value, true) end,
		function(reason) return resolver(this, reason, false) end)
	return ok and this or Promise.reject(result) -- .. '.\n' .. debug.traceback())
end