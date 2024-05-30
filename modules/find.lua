local function find(tbl, value, position)
	local i=1
	local len=#tbl
	if position then
		if position > len then return end
		i=position
	end
	while i<=len do
		if (tbl[i]==value) then return i end
		i=i+1
	end
end

return find