#ifndef FORMATDATE_H
#define FORMATDATE_H

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#include "lauxlib.h"

EXPORT int luaopen_formatDate(lua_State *L);
EXPORT int luaopen_getUserInput(lua_State *L);

#endif //FORMATDATE_H