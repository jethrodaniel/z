# z

![](https://github.com/jethrodaniel/z/workflows/ci/badge.svg)

Following along with Rui Ueyama's 9cc ([book][9cc-book], [repo][9cc]).

## install

```
git clone https://github.com/jethrodaniel/z
cd z && rake
```

## usage

```
z
```

## example

```
cd sample && make
hi!
```

## prerequisites

- crystal 0.35 or greater
- rake (ruby) for building

## license

MIT

## references

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
