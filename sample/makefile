CC=gcc
Z=../bin/z
run: build
	./a.out; exit 0
clean:
	rm -fv *.o *.s *.out
build:
	$(CC) -c io.c 
	$(Z) -c -f main.c > z.s
	$(CC) -c z.s
	$(CC) *.o
