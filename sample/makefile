CC=gcc
Z=../bin/z
run: build
	./a.out; exit 0
clean:
	rm -fv *.o *.s *.out
build:
	$(Z) compile main.c > z.s
	$(CC) z.s
