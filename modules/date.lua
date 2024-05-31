local d = os.date

local M = {}
local rawset = rawset
local rawget = rawget

function M.new()
	return setmetatable({day=tonumber(d("%d")), month=tonumber(d("%m")), year=tonumber(d("%Y"))}, {__index=M})
end

local function isLeapYear(year) 
	return year%4==0 and (year%100~=0 or year%400==0) 
end
local mdays = {31, nil, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
local function daysInMonth(month, year)
	if month==2 then return isLeapYear(year) and 29 or 28 end
	return mdays[month] 
end

function M.reset(self, tbl)
	if not tbl then return end
	if tbl.day   then rawset(self, "day",   tonumber(d("%d"))) end
	if tbl.month then rawset(self, "month", tonumber(d("%m"))) end
	if tbl.year  then rawset(self, "year",  tonumber(d("%Y"))) end
end
function M.change(self, tbl)
	local day, month, year
	local sd, sm, sy = self:get()
	if tbl.day==tbl.month and tbl.month==tbl.year and tbl.year==nil then
		M:reset{day=true, month=true, year=true}
		return 
	end
	if tbl.month==-1 then 
		self.month = tonumber(d("%m"))
	elseif tbl.month then month = ((tbl.month-1)%12)+1 end
	if tbl.year==-1 then 
		self.year = tonumber(d("%Y"))
	elseif tbl.year then year = math.max((tbl.year%3001), 1970) end
	if tbl.day==-1 then 
		self.day = tonumber(d("%d"))
	elseif tbl.day then day = (tbl.day-1)%daysInMonth(month or sm, year or sy)+1 end
	
	rawset(self, "month", month or sm)
	rawset(self, "day",   day   or sd)
	rawset(self, "year",  year  or sy)
end
function M.get(self)
	return rawget(self, "day") or tonumber(d("%d")), rawget(self, "month") or tonumber(d("%m")), rawget(self, "year") or tonumber(d("%Y"))
end
function M.fromargs(self, args)
	local dflag = find(args, "-d")
	local mflag = find(args, "-m")
	local yflag = find(args, "-y")
	local chtbl = {}
	
	local function assertisnumber(name, val)
		local tn = tonumber(val)
		if not tn then write(("Number expected as $s, got %s\n"):format(name, type(val)))
		else chtbl[name]=tn end
	end
	
	if dflag then assertisnumber("day",   args[dflag+1]) end
	if mflag then assertisnumber("month", args[mflag+1]) end
	if yflag then assertisnumber("year",  args[yflag+1]) end
	self:change(chtbl)
end
function M.time(self)
	local day, month, year = self:get()
	return os.time{day=day,month=month,year=year}
end
M.isleapyear = isLeapYear
M.nmondays = daysInMonth
return setmetatable({day=tonumber(d("%d")), month=tonumber(d("%m")), year=tonumber(d("%Y"))}, {__index=M})