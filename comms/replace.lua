local args = ...

local allflag = args["--all"] or args["-a"]
if #args < 2 and not allflag then
	io.write("Usage: replace <old> <new> [--all/-a]\n")
	return
end

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = date.new()
local old = args[1]
local new = args[2]
local fullpath = ""

ldate:fromargs(args, 2)
local day, mon, year = ldate:get()

fullpath = ENTRIES_PATH..("/%.4d/%.2d/%.2d.txt"):format(year, mon, day)

local file = io.open(fullpath, "r")
local found = false
if not file then write("No entry on date\n") return end
local tbl = {}
local str = ""
local hastxt
for line in file:lines() do
	hastxt=true
	if (found and not allflag) or not line:gmatch("([^=]+)")()==old then str=str..line.."\n"
	else found = true str=str..new..line:sub(#old+1,#line).."\n" end
end
file:close()
if str=="" then removefile() return end
file = io.open(fullpath, "w")
if not file then write("Couldn't open file for writing\n") return end
file:write(str)
file:close()
write("Replace successful\n")
