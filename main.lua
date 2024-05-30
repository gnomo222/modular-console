local LIB =  "./bin/lib.dll"
local GNOMOFS = "./bin/gnomofs.dll"

package.cpath = "./bin/?.dll;./?.dll;"
package.path = "./modules/?.lua;./?.lua;"

local require = require
local crequire = function(lib, name) 
	return assert(package.loadlib(lib, "luaopen_"..name))() 
end
CONFIGS = require("configs")
date = require("date")
getUnsynonymized = require("getUnsynonymized")
find = require("find")
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
::LOOP::
write(formatDate(date.get()))
local comm = getUserInput()
commName = getUnsynonymized(comm[1])
if not commName then goto LOOP end
if commName == "exit" then os.exit()
elseif commName == "clear" then clear() goto LOOP end
commPath = getCommPath(commName)
if commPath then assert(loadfile("./comms/"..commPath..".lua"))(unpack(comm, 2))
else print("Couldn't find command") end
goto LOOP
