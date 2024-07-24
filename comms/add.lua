local args = ...

if #args<2 then
	io.write("Usage: add <name> <values: int1,int2,int3...>")
	return
end

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = date.new()
local name = args[1]
local values = {}
local fullpath = ""
local file

ldate:fromargs(args, 2)
if not name or name=="" then write("Name cannot be empty\n") return end
for v in args[2]:gmatch("(%d+)") do
	values[#values+1]=v
end
if #values==0 then write("Expected integer list as 2nd argument\n") return end

local day, mon, year = ldate:get()

monthpath = ENTRIES_PATH..("/%.4d/%.2d/"):format(year, mon)
fullpath = monthpath .. day .. ".txt"
file = io.open(fullpath, "a+")
if not file then file = io.open(fullpath, "w") end
if not file then 
	gnomofs.mkdir(monthpath) 
	file=io.open(fullpath, "w") 
end
if not file then write("Error creating file "..fullpath.."\n") return end
file:write(("%s=%s\n"):format(name, table.concat(values, ",")))
write("Added to file successfully\n")
file:close()
io.flush()
