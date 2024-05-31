local args = {...}

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = date.new()
local name = args[1]
local values = {}
local fullpath = ""
local file

if not name or name=="" then write("Name cannot be empty\n") return end
for v in args[2]:gmatch("(%d+)") do
	values[#values+1]=v
end
if #values==0 then write("Expected integer list as 2nd argument\n") return end

ldate:fromargs(args)
local day, mon, year = ldate:get()

fullpath = ENTRIES_PATH..("/%.4d/%.2d"):format(year, mon)
gnomofs.mkdir(fullpath)
file = io.open(fullpath.."/"..day..".txt", "a+")
if not file then file = io.open(fullpath.."/"..day..".txt", "w") end
if not file then write("Error creating file "..fullpath.."/"..day..".txt") return end
file:write(("%s=%s\n"):format(name, table.concat(values, ",")))
write("Added to file successfully\n")
file:close()
io.flush()