local args = ...

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = date.new()
local fullpath = ""
local file

ldate:fromargs(args)
local day, mon, year = ldate:get()

fullpath = ENTRIES_PATH..("/%.4d/%.2d/%.2d.txt"):format(year, mon, day)
file = io.open(fullpath,"r")
if not file then write("No entry on date\n") return end
local txt = file:read("*a")
if not txt then write("File is empty\n") end
for k, v in txt:gmatch("([^=]+)=(%g+)\n") do
	local values = {}
	for v in v:gmatch("(%d+)") do
		values[#values+1]=v
	end
	write(("%d set(s) of %s: "..("%d"):rep(#values, " ")):format(#values, k, table.unpack(values)))
	write("\n")
end
file:close()
