#
# This project uses Lua 5.4.6
#
# Put your own lua src directory path here
LUASRCDIR = ../lua/lua
# Put your lua lib here. May be liblua.a or lua54.lib
LIBLUA = ${LUASRCDIR}/liblua.a

SRCDIR = src
OUTDIR = bin
OBJDIR = obj

CC = gcc
CFLAGS = -fomit-frame-pointer -fexpensive-optimizations -std=c17 -Os -I${LUASRCDIR} -c
OFLAGS = -shared -s

MKDIR = mkdir

# If you're using Linux, uncomment the following line
# RM = rm -f "${OBJDIR}/*.o" "${OUTDIR}/*.dll"
# else, if you're using Windows, uncomment this definition
define RM
del /q "${OBJDIR}\*.o"
del /q "${OUTDIR}\*.dll"
endef

all: input fmtdate files
redo: clean all

input: ${OUTDIR}/getUserInput.dll
${OUTDIR}/getUserInput.dll: ${OBJDIR}/getUserInput.o ${OUTDIR}
	${CC} ${OFLAGS} -o $@ $< ${LIBLUA} 
${OBJDIR}/getUserInput.o: ${SRCDIR}/getUserInput.c ${OBJDIR} 
	${CC} ${CFLAGS} -o $@ $<

fmtdate: ${OUTDIR}/formatDate.dll
${OUTDIR}/formatDate.dll: ${OBJDIR}/formatDate.o ${OUTDIR}
	${CC} ${OFLAGS} -o $@ $< ${LIBLUA}
${OBJDIR}/formatDate.o: ${SRCDIR}/formatDate.c ${OBJDIR} 
	${CC} ${CFLAGS} -o $@ $<

files: ${OUTDIR}/getFiles.dll
${OUTDIR}/getFiles.dll: ${OBJDIR}/getFiles.o ${OUTDIR}
	${CC} ${OFLAGS} -o $@ $< ${LIBLUA}
${OBJDIR}/getFiles.o: getFiles.c ${OBJDIR}
	${CC} ${CFLAGS} -o $@ $<

dir: ${OUTDIR} ${OBJDIR}
${OUTDIR}:
	${MKDIR} ${OUTDIR}
${OBJDIR}:
	${MKDIR} ${OBJDIR}

.PHONY: clean
clean:
	${RM}