local args = ...

local fileflag = args["--file"] or args["-f"]
if #args == 0 and not fileflag then
	io.write("Usage: remove [--file/-f] or (<name> [--all/-a])\n")
	return
end

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = date.new()
local allflag = args["--all"] or args["-a"]
local fullpath = ""

ldate:fromargs(args, 2)
local day, mon, year = ldate:get()

fullpath = ENTRIES_PATH..("/%.4d/%.2d/%.2d.txt"):format(year, mon, day)
local function removefile()
	if os.remove(fullpath) then write("File removed successfully\n")
	else write("Couldn't remove file\n") end
end

if fileflag then removefile()
else 
	local file = io.open(fullpath, "r")
	local found = false
	if not file then write("No entry on date\n") return end
	local tbl = {}
	local str = ""
	local hastxt
	for line in file:lines() do
		hastxt=true
		if (found and not allflag) or line:gmatch("([^=]+)")()~=args[1] then str=str..line.."\n"
		else found = true end 
	end
	if not found then
		write("Couldn't find exercise named "..args[1])
		write("\n")
		return
	end
	file:close()
	if str=="" then removefile() return end
	file = io.open(fullpath, "w")
	if not file then write("Couldn't open file for writing\n") return end
	file:write(str)
	file:close()
	write("Removed from file successfully\n")
end
