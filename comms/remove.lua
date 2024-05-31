local args = {...}

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = date.new()
local fileflag = find(args, "--file") or find(args, "-f")
local allflag = find(args, "--all") or find(args, "-a")
local fullpath = ""

ldate:fromargs(args)
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
		if (found and not allflag) or not line:sub(1, #args[1])==args[1] then str=str..line.."\n"
		else found = true end 
	end
	file:close()
	if str=="" then removefile() return end
	file = io.open(fullpath, "w")
	if not file then write("Couldn't open file for writing\n") return end
	file:write(str)
	file:close()
	write("Removed from file successfully\n")
end