GCCFLAGS = -nostartfiles -no-pie
LIBFLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -lc

all: beep 
.PHONY: all clean run 

beep: main.o
	gcc -o beep main.o ${GCCFLAGS} ${LIBFLAGS} 

main.o: 
	nasm -f elf64 -g -o main.o main.asm

run: clean all
	./beep

rebuild: clean all


clean:
	rm beep main.o



