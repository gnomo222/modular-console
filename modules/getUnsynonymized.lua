local function getUnsynonymized(name)
    local synonyms_file = io.open("synonyms", "r")
    if not synonyms_file then
        synonyms_file=io.open("synonyms","w")
        synonyms_file:close()
        return name
    end
    local unsyn = ""
    local x, y = 0, 0
    for line in synonyms_file:lines() do
        unsyn, vals = line:gmatch("(%g+)[:=](.+)")()
	if not unsyn or not vals then goto CONTINUE end
        if name==unsyn then
            synonyms_file:close()
            return unsyn
        end
        for v in vals:gmatch("([^,%s;]+)") do
		if v==name then 
			synonyms_file:close()
			return unsyn
		end
	end
        ::CONTINUE::
    end
    synonyms_file:close()
    return name
end

return getUnsynonymized