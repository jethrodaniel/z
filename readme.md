# z

![](https://github.com/jethrodaniel/z/workflows/ci/badge.svg)

Building a C compiler along with Rui Ueyama's 9cc ([book][9cc-book], [repo][9cc]).

## prereqs

Crystal.

## build/install

```
git clone https://github.com/jethrodaniel/z && cd z && make
```

## usage

```
$ ./bin/z
Usage: z [command] [arguments]
    lex                              Lex input, output tokens
    parse                            Parse input, output AST
    dot                              Parse input, output graphviz dot
    compile                          Compile input, output assembly
    run                              Compile and run input
    obj                              Analyze object files
    -i                               Get input from stdin
    -c                               Get input from string
    -v, --version                    Show the version
    -h, --help                       Show this help
```

## example

See the specs in the [spec/compiler directory](spec/compiler).

```
$ pushd spec/compiler/
$ ../../bin/z run hi.c
hi!
$ ../../bin/z run main.c
fib(0)  = 0
fib(1)  = 1
fib(2)  = 1
fib(3)  = 2
fib(4)  = 3
fib(5)  = 5
fib(6)  = 8
fib(7)  = 13
fib(8)  = 21
fib(9)  = 34
fib(10) = 55
fib(11) = 89
fib(12) = 144
$ z run -c 'p(c){putchar(c);}main(){p(65);p(10);}'
A
```

## license

MIT

## references

> If I have seen further, it is by standing upon the shoulders of giants.
>
> Sir Isaac Newton, 1675

Thanks, y'all.

- https://web.archive.org/web/20191210114310/http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html
- https://github.com/charly-lang/charly
- https://github.com/mint-lang/mint
- https://github.com/cia-foundation/TempleOS
- http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
- https://www.sigbus.info/compilerbook
  - english: https://translate.google.com/translate?hl=en&sl=ja&tl=en&u=https%3A%2F%2Fwww.sigbus.info%2Fcompilerbook
- https://github.com/rui314/chibicc
- https://github.com/eatonphil/ulisp
- unix history repo
  - https://github.com/dspinellis/unix-history-repo/blob/Research-V2-Snapshot-Development/c/nc0/c00.c
- [writing elf output](https://github.com/lazear/lass/blob/66771edd7fa883e0620b3e00777320e6577f7f33/assembler.c#L53)
