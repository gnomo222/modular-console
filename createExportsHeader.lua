-- This just makes the exports.h automatically
-- Requires getFiles.dll
local srcdir = "./src"
local bindir = "./bin"
package.cpath = bindir.."/?.dll;./?.dll"
local file = io.open(srcdir.."/exports.h", 'w+')
local source_files = require("getFiles")(srcdir, "c")
local include = {"lauxlib"}
file:write([[
#ifndef FORMATDATE_H
#define FORMATDATE_H

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif
]])
local fmt = "#include \"%s.h\"" 
for i=1, #include do file:write("\n"..fmt:format(include[i])) end
file:write("\n")
fmt = "EXPORT int luaopen_%s(lua_State *L);" 
for i=1, #source_files do file:write("\n"..fmt:format(source_files[i] )) end
file:write('\n\n'.."#endif //FORMATDATE_H")