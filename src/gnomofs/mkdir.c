#include <errno.h>
#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <dirent.h> 
#include <stdbool.h>
#include <sys/stat.h>

#include "gnomofs.h"
#include "../words.h"

#define COUNT_TYPE unsigned char
#ifdef _WIN32
#	define MKDIR(path) mkdir(path)
#else
#	define MKDIR(path) mkdir(path, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH)
#endif

static char **strdiv(const char *src, const char div, COUNT_TYPE *countptr)
{
	char **ret;
	COUNT_TYPE count = 1;
	size_t len = 0;
	size_t offset = 0;
	int ret_index = 0;
	char ch;
	while ((ch=src[len++])!=0) if (ch==div) count++;
	ret=malloc(sizeof(char*)*count);
	for (size_t i = 0; i <= len; i++) if (src[i]==div || src[i]==0) {
		ret[ret_index++] = substr(src, offset, i);
		offset=i+1;
	}
	*countptr=count;
	return ret;
}

int lua_mkdir(lua_State *L)
{
	const char* path = luaL_checkstring(L, 1);
	int stts = 0;
	COUNT_TYPE count = 0;
	char **dirarr = strdiv(path, '/', &count);;
	char *current_path = malloc(sizeof(char)*(strlen(path)+1));
	size_t len = 0;
	size_t cplen=0;
	for (COUNT_TYPE i = 0; i<count; i++) {
		len = strlen(dirarr[i]);
		memcpy(current_path+cplen, dirarr[i], len);
		cplen+=len;
		current_path[cplen++]='/';
		current_path[cplen] = 0;
		if (dirarr[i][0]=='.'&&(dirarr[i][1]=='.'||dirarr[i][1]==0)) continue;
		stts=MKDIR(current_path);
	}
#ifdef _WIN32
	if (stts==-1) {
		stts=0;
	} else stts=1;
#else
	if (stts!=0) { 
		stts = 0;
	} else stts=1;
#endif
	for (COUNT_TYPE i = 0; i<count; i++) {
		free(dirarr[i]);
	}
	free(dirarr);
	lua_pushboolean(L, stts);
	return 1;
}
