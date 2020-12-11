FLAGS = -masm=intel \
    -O0 \
    -Wall \
    -Wextra \
    -fno-asynchronous-unwind-tables \
    -fno-exceptions \
    -fno-ident \
    -finhibit-size-directive \
    -Wl,-z,noexecstack
CC=gcc#$(FLAGS)
 
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
