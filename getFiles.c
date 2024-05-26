#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <dirent.h> 
#include <stdbool.h>
#include <sys/stat.h>

#include "lauxlib.h"

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#define MKDIR(path) mkdir(path)
#else
#define EXPORT
#define MKDIR(path) mkdir(path, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH)
#endif

int getFiles(lua_State *L)
{
    char* path = (char*) luaL_checkstring(L, 1);
    char* ext = (char*) luaL_checkstring(L, 2);
    lua_newtable(L);
    struct dirent *de;
    DIR *dr = opendir(path); 
    if (dr == NULL) 
    { 
        int dir_err = MKDIR(path);
        if (dir_err==-1) {
            printf("Error making directory");
            exit(1);
        }
        return 1;
    }
    bool isFile;
    int index = 1;
    size_t extLen = strlen(ext);
    while ((de = readdir(dr)) != NULL) {
        struct stat stbuf;
        size_t len;
        stat(de->d_name, &stbuf);
        isFile = !S_ISDIR(stbuf.st_mode);
        len = strlen(de->d_name);
        if (isFile && (strcmp(de->d_name+len-extLen,ext) == 0)) {
            de->d_name[len-extLen-1]=0;
            lua_pushstring(L, de->d_name);
            lua_rawseti(L, -2, index++);
        }
    }
    closedir(dr);
    return 1;
}

EXPORT int luaopen_getFiles(lua_State *L) 
{ 
    lua_pushcfunction(L, getFiles);
    return 1;
}
