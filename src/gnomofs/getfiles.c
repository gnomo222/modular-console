#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <dirent.h> 
#include <stdbool.h>
#include <sys/stat.h>

#include "gnomofs.h"

#ifdef _WIN32
#define MKDIR(path) mkdir(path)
#else
#define MKDIR(path) mkdir(path, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH)
#endif

int getfiles(lua_State *L)
{
	const char* path = luaL_checkstring(L, 1);
	const char* ext = luaL_checkstring(L, 2);
	size_t pathlen = strlen(path);
	struct dirent *entry;
	DIR *dir = opendir(path); 
	if (dir == NULL) return 0;
	lua_newtable(L);
	bool isfile;
	int index = 1;
	size_t extLen = strlen(ext);
	char *fullpath;
	while ((entry = readdir(dir)) != NULL) {
		if (entry->d_name[0]=='.'&&(entry->d_name[1]=='.'||entry->d_name[1]==0)) continue;
		struct stat statbuffer;
		size_t len;
		len = strlen(entry->d_name);
		fullpath = malloc(sizeof(char)*(pathlen+len+2));
		memcpy(fullpath, path, pathlen);
		fullpath[pathlen]='/';
		memcpy(fullpath+pathlen+1, entry->d_name, len);
		fullpath[pathlen+len+1]=0;
			if (stat(fullpath, &statbuffer) != 0) {
				free(fullpath);
				closedir(dir);
				return 0;
			};
		isfile = S_ISREG(statbuffer.st_mode);
		if (isfile && (strcmp(entry->d_name+len-extLen,ext) == 0)) {
			entry->d_name[len-extLen-1]=0;
			lua_pushstring(L, entry->d_name);
			lua_rawseti(L, -2, index++);
		}
		free(fullpath);
	}
	closedir(dir);
	return 1;
}