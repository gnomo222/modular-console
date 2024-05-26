local M = {}
local DATE = {}

local function isLeapYear(year) 
    return year%4==0 and (year%100~=0 or year%400==0) 
end
local mdays = {31, nil, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
local function daysInMonth(month, year)
    if month==2 then return isLeapYear(year) and 29 or 28 end
    return mdays[month] 
end

function M.reset(tbl)
    if tbl.day then DATE.day = nil end
    if tbl.month then DATE.month = nil end
    if tbl.year then DATE.month = nil end
end
function M.change(tbl)
    if tbl.day==tbl.month and tbl.month==tbl.year and tbl.year==nil then
        DATE={}
        DATE_CHANGED=false 
        return
    end
    local month = tbl.month and tbl.month%12 or DATE.month
    local year = tbl.year and tbl.year%9999 or DATE.year
    local day = tbl.day and ((tbl.day-1)%daysInMonth(month, year))+1 or DATE.day
    DATE={month=month, day=day, year=year}
end
function M.get()
    return DATE.day or 0, DATE.month or 0, DATE.year or 0
end
return M