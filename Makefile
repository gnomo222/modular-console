#
# This project uses Lua 5.4.6
#

# Put your own lua src directory path here
LUASRCDIR = ../lua-5.4.6/src
# Put your lua lib here. Usually is "lua" for Linux and "lua54" for Windows
LIBLUA = lua

SRCDIR = src
OUTDIR = bin
OBJDIR = obj

GFS_OBJDIR = ${OBJDIR}/gnomofs

platform = unknown
# possible values: mingw, linux

# If you have UPX (Ultimate Packer for eXecutables), uncomment this line
# UPX = upx -q --best --lzma
# UPX may only work on Windows

CC = gcc -std=c17
CFLAGS = -fPIC -Wall -Wextra -O2 -I${LUASRCDIR} -c
OFLAGS = -shared -s -L${LUASRCDIR} -l${LIBLUA}

LIB_NAMES = getUserInput formatDate clear getOS
GFS_NAMES = mkdir getfiles gnomofs

LIB_OBJS = ${LIB_NAMES:%=${OBJDIR}/%.o}
GFS_OBJS = ${GFS_NAMES:%=${GFS_OBJDIR}/%.o}

MKDIR = mkdir -p
RM = rm -f
S = /
EXT = .dll

.PHONY: all unknown mingw linux clean
all: ${platform} lib gnomofs 

unknown:
	$(error please configure the Makefile by setting the platform variable)

mingw:
	$(eval S := \)
	$(eval RM := del /q)
	$(eval MKDIR := mkdir)
	$(eval CC += -D__USE_MINGW_ANSI_STDIO)
linux:
	$(eval OFLAGS += -lcurses)
	$(eval EXT := .so)

lib: ${platform} ${OUTDIR} ${OBJDIR} ${LIB_OBJS}
	${CC} ${OFLAGS} -o ${OUTDIR}/lib${EXT} ${LIB_OBJS}
ifdef UPX
	${UPX} ${OUTDIR}/lib${EXT}
endif
gnomofs: ${platform} ${OUTDIR} ${GFS_OBJDIR} ${GFS_OBJS}
	${CC} ${OFLAGS} -o ${OUTDIR}/gnomofs${EXT} ${GFS_OBJS}
ifdef UPX
	${UPX} ${OUTDIR}/gnomofs${EXT}
endif

${OBJDIR}/%.o: ${SRCDIR}/%.c
	${CC} ${CFLAGS} -o $@ -c $<

${OUTDIR}:
	${MKDIR} "$@"
${OBJDIR}:
	${MKDIR} "$@"
${GFS_OBJDIR}:
	${MKDIR} "$@"

clean: ${platform}
	${RM} "${OBJDIR}$S*.o" "${GFS_OBJDIR}$S*.o" "${OUTDIR}$S*${EXT}"
