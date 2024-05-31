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

GFS_OBJDIR = ${OBJDIR}/gnomofs

plataform = unknown
# possible values: mingw, linux

# If you have UPX (Ultimate Packer for eXecutables), uncomment this line
# UPX = upx -q --best --lzma
# Works best on Windows

CC = gcc -std=c17
CFLAGS = -fPIC -Wall -Wextra -O2 -I${LUASRCDIR} -c
OFLAGS = -shared -s -L${LUASRCDIR} -l${LIBLUA}

LIB_NAMES = getUserInput formatDate clear getOS
GFS_NAMES = mkdir getfiles gnomofs

LIB_OBJS = ${LIB_NAMES:%=${OBJDIR}/%.o}
GFS_OBJS = ${GFS_NAMES:%=${GFS_OBJDIR}/%.o}

MKDIR = mkdir -p
S = /
RM = rm -f

all: lib gnomofs 

unknown:
	$(error please, configure the Makefile)

mingw:
	$(eval S := \)
	$(eval RM := del /q)
	$(eval MKDIR := mkdir)
	$(eval CC += -D__USE_MINGW_ANSI_STDIO)
linux:
	$(eval OFLAGS += -lcurses)

lib: ${plataform} ${OUTDIR} ${OBJDIR} ${OUTDIR}/lib.dll
gnomofs: ${plataform} ${OUTDIR} ${GFS_OBJDIR} ${OUTDIR}/gnomofs.dll 
${OUTDIR}/lib.dll: ${LIB_OBJS}
	${CC} ${OFLAGS} -o $@ $?
	${UPX} $@
${OUTDIR}/gnomofs.dll: ${GFS_OBJS}
	${CC} ${OFLAGS} -o $@ $?
	${UPX} $@

${OBJDIR}/%.o: ${SRCDIR}/%.c
	${CC} ${CSTD} ${CFLAGS} -o $@ -c $<

${OUTDIR}:
	${MKDIR} "$@"
${OBJDIR}:
	${MKDIR} "$@"
${GFS_OBJDIR}:
	${MKDIR} "$@"

.PHONY: clean
clean: ${plataform}
	${RM} "${OBJDIR}$S*.o" "${GFS_OBJDIR}$S*.o" "${OUTDIR}$S*.dll"
