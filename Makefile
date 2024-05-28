#
# This project uses Lua 5.4.6
#
# Put your own lua src directory path here
LUASRCDIR = ../lua-5.4.6/src
# Put your lua lib here. Usually is lua or lua54
LIBLUA = lua

SRCDIR = src
OUTDIR = bin
OBJDIR = obj

# If you have UPX (Ultimate Packer for eXecutables), uncomment this line
# UPX = upx --best --lzma ${OUTDIR}/*.dll # Works best on Windows

CC = gcc -std=c17
CFLAGS = -fPIC -Wall -Wextra -O2 -I${LUASRCDIR} -c
OFLAGS = -shared -s -L${LUASRCDIR} -l${LIBLUA} -lcurses

MKDIR = mkdir

# If you're using Linux, uncomment the following line
RM = rm -f ${OBJDIR}/*.o ${OUTDIR}/*.dll
# else, if you're using Windows, uncomment this definition
# define RM
# del /q "${OBJDIR}\*.o"
# del /q "${OUTDIR}\*.dll"
# endef

redo: clean all
all: dir ${OUTDIR}/lib.dll files compress

lib: ${OUTDIR}/lib.dll ${OUTDIR} ${OBJDIR}
${OUTDIR}/lib.dll: ${OBJDIR}/getUserInput.o ${OBJDIR}/formatDate.o
	${CC} ${OFLAGS} -o $@ $?
${OBJDIR}/getUserInput.o: ${SRCDIR}/getUserInput.c
	${CC} ${CFLAGS} -o $@ $<
${OBJDIR}/formatDate.o: ${SRCDIR}/formatDate.c
	${CC} ${CFLAGS} -o $@ $<

files: ${OUTDIR}/getFiles.dll ${OUTDIR} ${OBJDIR}
${OUTDIR}/getFiles.dll: ${OBJDIR}/getFiles.o 
	${CC} ${OFLAGS} -o $@ $<
${OBJDIR}/getFiles.o: getFiles.c 
	${CC} ${CFLAGS} -o $@ $<

compress:
	${UPX}

dir: ${OUTDIR} ${OBJDIR}
${OUTDIR}:
	${MKDIR} ${OUTDIR}
${OBJDIR}:
	${MKDIR} ${OBJDIR}

.PHONY: clean
clean:
	${RM}
