#include "gnomofs.h"

int luaopen_gnomofs(lua_State *L)
{
	lua_createtable(L, 0, 2);
	lua_pushcfunction(L, getfiles);
	lua_setfield(L, -2, "getfiles");
	lua_pushcfunction(L, lua_mkdir);
	lua_setfield(L, -2, "mkdir");
	return 1;
}