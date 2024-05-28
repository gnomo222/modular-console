local LIB =  "./bin/lib.dll"

package.cpath = "./bin/?.dll;./?.dll;"
package.path = "./modules/?.lua;./?.lua;"

DATE = require("date")

local io = io
local os = os
local table = table
local date = DATE
local w = io.write
local flush = io.flush
local print = print
local unpack = table.unpack
local concat = table.concat
local loadfile = loadfile
local require = require
local assert = assert

local write = function(...)
    w(...)
    flush()
end

local getUserInput = assert(package.loadlib(LIB, "luaopen_getUserInput"))()
local formatDate = assert(package.loadlib(LIB, "luaopen_formatDate"))()
local getFiles = require("getFiles")

local getUnsynonymized = require("getUnsynonymized")

local COMM_FILES = getFiles("comms", "lua")

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
if commName == "exit" then os.exit() end
commPath = getCommPath(commName)
if commPath then loadfile("./comms/"..commPath..".lua")(unpack(comm, 2))
else print("Couldn't find command") end
goto LOOP
