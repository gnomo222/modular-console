local BIN = "./bin"
local LIB = BIN.."/lib.dll"

package.cpath = "./?.dll;"..BIN.."/?.dll;"
package.path = "./modules/?.lua;./?.lua;"

DATE = require("date")

local io = io
local os = os
local date = DATE
local w = io.write
local flush = io.flush
local print = print
local unpack = table.unpack
local loadfile = loadfile
local require = require

local write = function(...)
    w(...)
    flush()
end

local getUserInput = package.loadlib(LIB, "luaopen_getUserInput")()
local formatDate = package.loadlib(LIB, "luaopen_formatDate")()
local getFiles = require("getFiles")

local getUnsynonymized = require("getUnsynonymized")

local COMM_FILES = getFiles("comm", "lua")

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
if commName == "exit" then os.exit() end
commPath = getCommPath(commName)
if commPath then
   loadfile("./comms/"..commPath..".lua")(unpack(comm, 2))
else
    print(commName, unpack(comm, 2))
end
goto LOOP