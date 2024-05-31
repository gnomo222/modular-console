#include "exports.h"

int luaopen_getOS(lua_State *L)
{
	char *os;
#ifdef _WIN64
	os="WIN64";
#elif _WIN32
	os="WIN32";
#elif __linux__
	os="LINUX";
#else
	os="UNSUPPORTED";
#endif
	lua_pushstring(L, os);
	return 1;
}