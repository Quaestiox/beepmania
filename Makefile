GCCFLAGS = -nostartfiles -no-pie
LINKFLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -lc
WINFLAGS = -mwindows


all: beep 
.PHONY: all clean run win clean_win

beep: main.o
	gcc -o beep main.o ${GCCFLAGS} ${LINKFLAGS} 

main.o: 
	nasm -f elf64 -g -o main.o main.asm

run: clean all
	./beep

rebuild: clean all

win: beep.exe


beep.exe: main_win.o
	gcc -o beep.exe main_win.o ${GCCFLAGS} ${LINKFLAGS} ${WINFLAGS}

main_win.o:
	nasm -f win64 -g -o main_win.o main.asm

clean:
	rm beep main.o

clean_win:
	rm beep.exe main_win.o
