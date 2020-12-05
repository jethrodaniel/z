CC=gcc -nostartfiles
cr:
	crystal run as.cr
run: build
	./a.out
clean:
	rm -fv *.o *.out
build:
	$(CC) hi.s
