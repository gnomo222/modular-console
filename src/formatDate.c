#include <time.h>
#include "exports.h"

#if _WIN64 || __linux__ || __unix__
#define DATE_START 11
#else
#define DATE_START 0
#endif

void setFormatedDate(struct tm tm, char *dateString)
{
    int mon = (tm.tm_mon+1);
    int year = (tm.tm_year+1900);

    dateString[DATE_START]   = (char)(tm.tm_mday/10)+'0';
    dateString[DATE_START+1] = (char)(tm.tm_mday%10)+'0';
    dateString[DATE_START+3] = (char)       (mon/10)+'0';
    dateString[DATE_START+4] = (char)       (mon%10)+'0';
    dateString[DATE_START+6] = (char)    (year/1000)+'0';
    dateString[DATE_START+7] = (char)  (year/100%10)+'0';
    dateString[DATE_START+8] = (char)   (year/10%10)+'0';
    dateString[DATE_START+9] = (char)      (year%10)+'0';
}

int doWhatever(lua_State *L)
{
    int day = (int)luaL_checkinteger(L, 1);
    int month = (int)luaL_checkinteger(L, 2);
    int year = (int)luaL_checkinteger(L, 3);
    
    #if _WIN64 || __linux__ || __unix__
        char dateString[28] = "\x1b[38;5;051m00/00/0000> \x1b[0m\0";
    #else
        char dateString[13] = "00/00/0000> \0";
    #endif // _WIN32
    
    time_t rawtime;
    time(&rawtime);
    struct tm *timeinfo = localtime(&rawtime);
    
    if (day != 0) timeinfo->tm_mday = day;
    if (month != 0) timeinfo->tm_mon = month-1;
    if (year != 0) timeinfo->tm_year = year-1900;
    
    setFormatedDate(*timeinfo, dateString);
    lua_pushstring(L, dateString);
    return 1;
}

int luaopen_formatDate(lua_State *L) 
{
    lua_pushcfunction(L, doWhatever);
    return 1;
}