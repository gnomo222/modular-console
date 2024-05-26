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
        unsyn = line:gmatch("([^:%s]*)")()
        if name==unsyn then
            synonyms_file:close()
            return unsyn
        end
        x, y = line:find(name)
        if x==y and x==nil then goto CONTINUE end
        if line:sub(x-1, y+1):match(" %g+[ ;]") then
            synonyms_file:close()
            return unsyn
        end
        ::CONTINUE::
    end
    synonyms_file:close()
    return name
end

return getUnsynonymized