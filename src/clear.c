#include <stdio.h>
#include <stdlib.h>
#include "exports.h"

int clear()
{
#if _WIN64 || __linux__ || __unix__
	printf("\x1b[2J\x1b[H");
#elif _WIN32
	system("cls");
#endif
	return 0;
}

int luaopen_clear(lua_State *L)
{
	lua_pushcfunction(L, clear);
	return 1;
}