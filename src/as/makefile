cr: run
	crystal run as.cr
run: build
	./a.out
clean:
	rm -fv *.o *.out
build:
	nasm -f elf64 hi.asm
	file hi.o
	objdump -d -Mintel hi.o
	ld hi.o
