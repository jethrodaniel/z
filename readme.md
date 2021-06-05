# z

![](https://github.com/jethrodaniel/z/workflows/ci/badge.svg)
![](https://img.shields.io/github/license/jethrodaniel/z.svg)

Building a C compiler along with Rui Ueyama's 9cc ([book][9cc-book], [repo][9cc]).

## prerequisites

Go.

```
$ make install_go
$ go version # go version go1.16.4 linux/amd64
```

## install

```
git clone https://github.com/jethrodaniel/z && cd z && make install
```

or

```
go install github.com/jethrodaniel/z@latest
```

## development

```
make build   # builds executables into ./bin
make install # `go install` this project
make test
```

## License

MIT

## References

TODO: clean this up, add more, order by subject

### c `atexit`, 

- https://web.archive.org/web/20191210114310/http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html

### some other languages

- https://github.com/charly-lang/charly
- https://github.com/mint-lang/mint
- https://github.com/cia-foundation/TempleOS

### compilers

- http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
- https://www.sigbus.info/compilerbook
  - english: https://translate.google.com/translate?hl=en&sl=ja&tl=en&u=https%3A%2F%2Fwww.sigbus.info%2Fcompilerbook
- https://github.com/rui314/chibicc
- https://github.com/eatonphil/ulisp

### general info

- unix history repo
  - https://github.com/dspinellis/unix-history-repo/blob/Research-V2-Snapshot-Development/c/nc0/c00.c
- [writing elf output](https://github.com/lazear/lass/blob/66771edd7fa883e0620b3e00777320e6577f7f33/assembler.c#L53)
