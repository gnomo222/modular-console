#ifndef GNOMOFS_H
#define GNOMOFS_H

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#include "lauxlib.h"

EXPORT int getfiles(lua_State *L);
EXPORT int lua_mkdir(lua_State *L);
EXPORT int luaopen_gnomofs(lua_State *L);

#endif