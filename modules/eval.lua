local functions = {}
local G = {}
local specialwords = {
	";", "for", "if", "while", "do", "repeat", "local"
}
G.find=find
G.type=type
G.tonumber=tonumber
G.tostring=tostring
G.time=os.time
G.system=os.execute
G.date=os.date
G.math=math
G.string=string
G.table=table
G.print=print
G.next=next
G.pairs=pairs
G.ipairs=ipairs
G.write=io.write
G.flush=io.flush
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
	for k, _ in G.pairs(evalenv) do evalenv[k]=nil end
end
function G.printenv()
	for k, v in G.pairs(evalenv) do G.print(k..'='..v) end
end

function G.eval(expression, addtoenv)
	if not G.find(specialwords, expression:gmatch("(%g+)")()) then expression = "return "..expression end
	local res = {assert(load(expression, nil, "t", evalenv))()}
	if #res==1 and type(res[1])=='table' and #res[1]>0 then res=res[1] end
	local ret = {}
	for i=1, #res do ret[i]=G.tostring(res[i]) end
	return ret
end

return G.eval