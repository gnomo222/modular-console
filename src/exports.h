#ifndef EXPORTS_H
#define EXPORTS_H

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#include "lauxlib.h"

EXPORT int luaopen_clear(lua_State *L);
EXPORT int luaopen_formatDate(lua_State *L);
EXPORT int luaopen_getUserInput(lua_State *L);
EXPORT int luaopen_getOS(lua_State *L);

#endif //EXPORTS_H