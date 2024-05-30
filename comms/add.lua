local args = {...}

local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local io=io
local write = io.write
local find = find
local ldate = require("date")
local name = args[1]
local values = {}
local dflag = find(args, "-d", 3)
local mflag = find(args, "-m", 3)
local yflag = find(args, "-y", 3)
local fullpath = ""
local file

local day, mon, year = date.get()
ldate.change{day=day, month=mon, year=year}

if not name or name:sub(1,1)=='-' then 
	write("Name expected\n")
	goto EOF 
end
if not args[2] or args[2]:sub(1,1)=='-' then
	write("Values expected\n")
	goto EOF 
end

for v in args[2]:gmatch("(%d+)") do
	values[#values+1]=v
end

if (dflag) then day  = tonumber(args[dflag+1]) dflag=nil end
if (mflag) then mon  = tonumber(args[mflag+1]) mflag=nil end
if (yflag) then year = tonumber(args[yflag+1]) yflag=nil end
ldate.change{day=day, month=mon, year=year}

day, mon, year = ldate.get()
fullpath = ENTRIES_PATH..("/%.4d/%.2d"):format(year, mon)

gnomofs.mkdir(fullpath)
file = io.open(fullpath.."/"..day..".txt", "a+")
if not file then file = io.open(fullpath.."/"..day..".txt", "w") end
if not file then write("Error creating file "..fullpath.."/"..day..".txt") goto EOF end
file:write(("%s=%s\n"):format(name, table.concat(values, ",")))
write("Added to file successfully\n")
file:close()
::EOF::
io.flush()