GCCFLAGS = -nostartfiles -no-pie
RAYLIB_DIR = ./lib
LIBFLAGS = -L${RAYLIB_DIR} -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -lc

GCC_WIN = x86_64-w64-mingw32-gcc   
LINKFLAGS = -L${RAYLIB_DIR} -lraylib -lmingw32 -lSDL2main -lSDL2 -lgdi32 -lwinuser -lm -lpthread -ldl -lX11 -lc

all: beep 
.PHONY: all clean run win

beep: main.o
	gcc -o beep main.o ${GCCFLAGS} ${LIBFLAGS} 

main.o: 
	nasm -f elf64 -g -o main.o main.asm

run: clean all
	./beep

rebuild: clean all

win: beep.exe


beep.exe: main_win.o
	${GCC_WIN} -o beep.exe main_win.o ${GCCFLAGS} ${LINKFLAGS}

main_win.o:
	nasm -f win64 -g -o main_win.o main.asm

clean:
	rm beep main.o
