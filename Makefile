#
# This project uses Lua 5.4.6
#
# Put your own lua src directory path here
LUASRCDIR = ../lua-5.4.6/src
# Put your lua lib here. Usually is "lua" for Linux and "lua54" for Windows
LIBLUA = lua54

SRCDIR = src
OUTDIR = bin
OBJDIR = obj

plataform = unknown
# possible values: mingw, linux

# If you have UPX (Ultimate Packer for eXecutables), uncomment this line
# UPX = upx --best --lzma ${OUTDIR}/*.dll 
# Works best on Windows

CC = gcc -std=c17
CFLAGS = -fPIC -Wall -Wextra -O2 -I${LUASRCDIR} -c
OFLAGS = -shared -s -L${LUASRCDIR} -l${LIBLUA}

FILENAMES = getUserInput formatDate

SRCS = ${FILENAMES:%=${SRCDIR}/%.c}
OBJS = ${FILENAMES:%=${OBJDIR}/%.o}

MKDIR = mkdir
S = /
RM = rm -f

all: ${plataform} dir lib files compress 
redo: ${plataform} clean dir files lib compress

unknown:
	$(error please, configure the Makefile)

mingw:
	$(eval S := \)
	$(eval RM := del /q)
	$(eval CC += -D__USE_MINGW_ANSI_STDIO)
linux:
	$(eval OFLAGS += -lcurses)

lib: ${OUTDIR}/lib.dll ${OUTDIR} ${OBJDIR}
${OUTDIR}/lib.dll: ${OBJDIR}/getUserInput.o ${OBJDIR}/formatDate.o
	${CC} ${OFLAGS} -o $@ $?
${OBJDIR}/%.o: ${SRCDIR}/%.c
	${CC} ${CSTD} ${CFLAGS} -o $@ -c $<

files: ${OUTDIR}/getFiles.dll ${OUTDIR} ${OBJDIR}
${OUTDIR}/getFiles.dll: ${OBJDIR}/getFiles.o 
	${CC} ${OFLAGS} -o $@ $<
${OBJDIR}/getFiles.o: getFiles.c 
	${CC} ${CFLAGS} -o $@ $<

compress:
ifdef UPX
	${UPX}
endif

dir: ${OUTDIR} ${OBJDIR}
${OUTDIR}:
	${MKDIR} ${OUTDIR}
${OBJDIR}:
	${MKDIR} ${OBJDIR}

.PHONY: clean
clean: ${plataform}
	${RM} ${OBJDIR}$S*.o ${OUTDIR}$S*.dll
