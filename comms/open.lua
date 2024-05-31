local args = {...}

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local find = find
local ldate = date.new()
local cdflag = find(args, "-cd") or find(args, "--current-dir")
local fullpath = ""
local file

ldate:fromargs(args)
local day, mon, year = ldate:get()


if cdflag then
	fullpath = "."
else
	fullpath = ENTRIES_PATH..("/%.4d/%.2d/%.2d.txt"):format(year, mon, day)
	file = io.open(fullpath,"r")
	if not file then io.write("No entry on date\n") return end
	file:close()
end
if OS:sub(1,3)=="WIN" then os.execute(("start \"\" %q"):format(fullpath))
else os.execute(("xdg-open %q"):format(fullpath)) end