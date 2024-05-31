local LIB =  "./bin/lib.dll"
local GNOMOFS = "./bin/gnomofs.dll"

package.cpath = "./bin/?.dll;./?.dll;./bin/?.so;./?.so;"
package.path = "./modules/?.lua;./?.lua;"

local require = require
local crequire = function(lib, name) 
	return assert(package.loadlib(lib, "luaopen_"..name))() 
end
eval = require("eval")
CONFIGS = require("configs")
date = require("date")
getUnsynonymized = require("getUnsynonymized")
find = require("find")
OS = crequire(LIB, "getOS")
supportsVTProcessing = OS == "WIN64" or OS == "LINUX"
getUserInput = crequire(LIB, "getUserInput")
formatDate = crequire(LIB, "formatDate")
clear = crequire(LIB, "clear")
gnomofs =  crequire(GNOMOFS, "gnomofs")
LIB, GNOMOFS = nil

local io = io
local os = os
local table = table
local configs = configs
local getUnsynonymized = getUnsynonymized
local getUserInput = getUserInput
local formatDate = formatDate
local gnomofs = gnomofs
local date = date
local find = find
local eval = eval
local w = io.write
local flush = io.flush
local print = print
local unpack = table.unpack
local concat = table.concat
local loadfile = loadfile
local write = function(...) w(...) flush() end
local clear = function() clear() flush() end

local COMM_FILES = gnomofs.getfiles("comms", "lua")
gnomofs=nil

local function getCommPath(commName)
    for i=1, #COMM_FILES do
        if COMM_FILES[i]==commName then return COMM_FILES[i] end 
    end
end

local commPath = ""
local commName = ""
local stts, err
::LOOP::
write(formatDate(date:get()))
local comm = getUserInput()
if not comm[1] then goto LOOP end
if comm[1]:sub(1,1) == "$" then
	local stts, res = pcall(eval, comm[1]:sub(2,#comm[1])..concat({unpack(comm, 2)},' '))
	if not stts then 
		write(res)
		write("\n")
	end
	goto LOOP
end
commName = getUnsynonymized(comm[1])
if not commName then goto LOOP end
if commName == "exit" then os.exit()
elseif commName == "clear" then clear() goto LOOP end
commPath = getCommPath(commName)
if commPath then
	do
	local arg, func, expr = "", "", ""
	for i=2, #comm do
		arg=comm[i]
		len = arg:len()
		if arg:sub(1, 1) == '$'then
			table.remove(comm, i)
			table.remove(comm, i)
			local stts, res = pcall(eval, arg:sub(2,#arg))
			if not stts then 
				write(res)
				write("\n")
			break end
			if res then
				table.insert(comm, i, concat(res, ","))
			end
		end
	end 
	end
	stts, err = pcall(assert(loadfile("./comms/"..commPath..".lua")), unpack(comm, 2))
	if not stts then 
		write(err) 
		write("\n") 
	end
else write("Couldn't find command\n") end
goto LOOP
