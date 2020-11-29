set -x
gcc -S sample/foo.c 
gcc -c foo.s 
./bin/z -c -f sample/main.c  > z.s
gcc -c z.s 
gcc -o a.out foo.o z.o 
./a.out 
