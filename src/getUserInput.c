#include "exports.h"
#include "words.h"

#ifdef _WIN64
    #include <wchar.h>
    #include <windows.h>
    #if !ENABLE_VIRTUAL_TERMINAL_PROCESSING
        #define ENABLE_VIRTUAL_TERMINAL_PROCESSING 0x0004
    #endif
#endif

char input[1024];

int getInput(lua_State *L)
{
    fgets(input, 1024, stdin);
    input[strlen(input)-1]=0;
    WordArray comm = parse_wordarray(input);
    lua_newtable(L);
    for (int i=0; i<comm.word_count; i++) {
        lua_pushstring(L, comm.words[i]);
        lua_rawseti(L, -2, i+1);
    }
    free_wordarray(comm);
    return 1;
}

int luaopen_getUserInput(lua_State *L)
{
    #if _WIN64
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD mode = 0;
    GetConsoleMode(hConsole, &mode);
    SetConsoleMode(hConsole, mode | ENABLE_VIRTUAL_TERMINAL_PROCESSING | ENABLE_PROCESSED_OUTPUT);
    #endif
    lua_pushcfunction(L, getInput);
    return 1;
}