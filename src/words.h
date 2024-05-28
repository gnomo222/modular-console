#ifndef WORDS_H
#define WORDS_H

#define FAILED_ALLOC_ASSERT(pointer, bytes) \
    if (pointer == NULL) { \
        printf("ERROR: failed to allocate %zu bytes at function %s", bytes, __func__); \
        exit(1); \
    }
    
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char** words;
    int word_count;
} WordArray;

void free_wordarray(WordArray wordArray)
{
    for (int i=0; i<wordArray.word_count; i++) {
        free(wordArray.words[i]);
    }
    free(wordArray.words);
}

void rplcescsqncs(char **str)
// Replace escape sequences
{
    size_t len = strlen(*str);
    char* ret = malloc(sizeof(char)*(len+1));
    FAILED_ALLOC_ASSERT(ret, sizeof(char)*(len+1));
    
    int j = 0;
    char chs[4];
    for (size_t i = 0; i<len; i++) {
        chs[0]=(*str)[i];
        if (chs[0] == '\\') {
            chs[1]=(*str)[i+1];
            chs[2]=(*str)[i+2];
            chs[3]=(*str)[i+3];
            if ((chs[1]>='0' && chs[1]<='9') && (chs[2]>='0' && chs[2]<='9') && (chs[3]>='0' && chs[3]<='9')) {
                ret[j] = (chs[1]-'0')*64+(chs[2]-'0')*8+(chs[3]-'0');
                i+=3;
            } else { 
                switch(chs[1]) {
                case '\\': ret[j] = '\\'; break;
                case 'n': ret[j] = '\n'; break;
                case '0': ret[j] = 0; break;
                case 't': ret[j] = '\t'; break;
                case 'e': ret[j] = 27; break;
                default: ret[j] = chs[1]; break;} 
                i++;
            }
        } else ret[j]=chs[0];
        j++;
    }
    ret = realloc(ret, sizeof(char)*(j+1));
    FAILED_ALLOC_ASSERT(ret, sizeof(char)*(j+1));
    ret[j] = 0;
    free(*str);
    *str=ret;
}

char* substr(const char* src, const int start, const int end)
{
    size_t len = end-start;
    char* ret = malloc(sizeof(char)*(len+1));
    FAILED_ALLOC_ASSERT(ret, sizeof(char)*(len+1));
    memcpy(ret, src+start, len);
    ret[len]=0;
    return ret;
}

static char* parse_word(const char* str, size_t* offset)
{
    char* word = NULL;
    bool isQuoting = false;
    bool foundEscapeCharacter = false;
    for (size_t i = 0; i<=strlen(str); i++) {
        switch (str[i]) {
        case '\\': foundEscapeCharacter=(str[i-1]) != '\\'; break;
        case '"':
            if (str[i-1] == '\\') break;
            if (isQuoting) {
                isQuoting = false;
                word=substr(str, 1, i);
                *offset+=2;
                goto END_OF_LOOP;
            };
            isQuoting = true;
            break;
        case ' ': case 0:
            if (isQuoting) continue;
            word=substr(str, 0, i);
            goto END_OF_LOOP;
        }
    }
    END_OF_LOOP:
    if (isQuoting) {
        printf("SYNTAX ERROR: unclosed quotation mark");
        exit(2);
    }
    *offset+=strlen(word)+1;
    if (foundEscapeCharacter) rplcescsqncs(&word);
    return word;
}

WordArray parse_wordarray(const char* str, size_t len)
{
    WordArray wordArray = {0};
    size_t offset = 0;
    LOOP_START:
    if (offset>=len) return wordArray;
    wordArray.words = realloc(wordArray.words, (++wordArray.word_count)*sizeof(char*));
    FAILED_ALLOC_ASSERT(wordArray.words, wordArray.word_count*sizeof(char*));
    wordArray.words[wordArray.word_count-1]=parse_word(str+offset, &offset);
    goto LOOP_START;
}

#endif
