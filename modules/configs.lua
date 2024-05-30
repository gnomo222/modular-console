local configs = {}

function char(str, pos) return str:sub(pos, pos) end 
local CONFIG_FILE = io.open("./configs", "r")
if not CONFIG_FILE then goto RETURN end

for line in CONFIG_FILE:lines() do
	if char(line, 1) == '#' then goto CONTINUE end
	local name, value = line:gmatch("%s*(%g+)%s*=%s*(%g+)")()
	if not name or name == "" then goto CONTINUE end
	if tonumber(value) then CONFIGS[name]=tonumber(value)
	else configs[name]=value end
	::CONTINUE::
end

::RETURN::
return configs