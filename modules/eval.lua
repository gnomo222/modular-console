local functions = {}
local G = {}
G.type=type
G.tonumber=tonumber
G.tostring=tostring
G.time=os.time
G.date=os.date
G.math=math
G.string=string
G.table=table
G.print=print
local evalenv = setmetatable({}, {
	__index=function(self, k)
		return rawget(self, k) or G[k]
	end,
	__newindex=function(self, k, v)
		if type(k) ~= "string" then error("String expected as var name") end
		rawset(self, k, v)
	end
})

function G.sum(...)
	local s = 0
	local args={...}
	for i=1, #args do s=s+args[i] end
	return s
end
function G.avg(...)
	local s = 0
	local args={...}
	for i=1, #args do s=s+args[i] end
	return s/#args
end
function G.assign(k, v) 
	evalenv[k]=v
end
function G.clearenv()
	for k, _ in pairs(evalenv) do evalenv[k]=nil end
end

function G.eval(expression)
	local res = {assert(load("return "..expression, nil, "t", evalenv))()}
	local ret = {}
	for i=1, #res do ret[i]=tostring(res[i]) end
	return ret
end

return G.eval