# z

![](https://github.com/jethrodaniel/z/workflows/ci/badge.svg)

Building a C compiler along with Rui Ueyama's 9cc ([book][9cc-book], [repo][9cc]).

Well, that's where _some_ of this started. The _eventual_ plan is to implement
HolyC.

## license

MIT

## prerequisites

- crystal 0.35 or greater
- rake (ruby) for building

## install

```
git clone https://github.com/jethrodaniel/z
cd z && rake
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

## references

TODO: clean this up, add more refereneces, order by subject

> If I have seen further, it is by standing upon the shoulders of giants.
>
> Sir Isaac Newton, 1675

Thanks, y'all.

- https://github.com/charly-lang/charly
- https://github.com/mint-lang/mint
- https://github.com/cia-foundation/TempleOS
- http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
- https://www.sigbus.info/compilerbook
  - english: https://translate.google.com/translate?hl=en&sl=ja&tl=en&u=https%3A%2F%2Fwww.sigbus.info%2Fcompilerbook
- https://github.com/rui314/chibicc
- unix history repo
  - https://github.com/dspinellis/unix-history-repo/blob/Research-V2-Snapshot-Development/c/nc0/c00.c
- https://github.com/eatonphil/ulisp
- [writing elf output](https://github.com/lazear/lass/blob/66771edd7fa883e0620b3e00777320e6577f7f33/assembler.c#L53)
  - https://github.com/crystal-lang/crystal/blob/1f38312aa4ac9e3aa0ab5c1a900f5801845845bd/src/exception/call_stack/elf.cr

[9cc-book]: https://www.sigbus.info/compilerbook
[9cc]: https://github.com/rui314/chibicc
