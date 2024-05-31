local args = {...}

local supportsVTProcessing = supportsVTProcessing
local ENTRIES_PATH = CONFIGS.ENTRIES_PATH
local write = io.write
local ldate = date.new()
ldate:change{day=1}
ldate:fromargs(args)
local day, month, year = ldate:get()
local ndays = ldate.nmondays(month, year)
local cday = 1
local time = ldate:time()
local startingwday=tonumber(os.date("%w", time))+1
local pathfmt = ENTRIES_PATH..("/%.4d/%.2d"):format(year, month).."/%.2d.txt"
local fullpath = ""
local RED = function(str) 
	if supportsVTProcessing then
		return ("\x1b[38;5;161m%s\x1b[0m"):format(str) end
	return str
end

local fmt_simple = "| %.2d |"
local fmt_special
if supportsVTProcessing then 
	fmt_special = "\x1b[38;5;165m| %.2d*|\x1b[0m"
else fmt_special = "| %.2d*|" end

write(RED("/~---------------={ %.2d }=---------------~\\\n"):format(month))
write(RED("| Su || Mo || Tu || We || Th || Fr || Sa |\n"))
write(RED("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n"))
for i=1, 42 do
	if cday>ndays or (cday==1 and i~=startingwday) then write("|    |") goto CONTINUE end
	do
	fullpath=pathfmt:format(cday)
	local file = io.open(fullpath)
	if file then 
		write(fmt_special:format(cday)) 
		file:close()
	else write(fmt_simple:format(cday)) end
	cday=cday+1
	end
	::CONTINUE::
	if i%7==0 then write("\n") end
end