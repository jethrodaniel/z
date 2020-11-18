# z

![](https://github.com/jethrodaniel/z/workflows/ci/badge.svg)

Following along with Rui Ueyama's 9cc.

## install

```
git clone --recursive git@github.com:jethrodaniel/z
cd z && rake
```

If you forget the `--recursive`, check out the submodule like so

```
git submodule update --init --progress --depth=1
```

## usage

```
$ ./bin/z '2*10-4/4-(3*5)-(5+4)+45-20+2+10*2;'
42
./bin/z -f sample/math.z 
42
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
- https://github.com/KENNN/compiler-book
- https://translate.google.com/translate?hl=en&sl=ja&tl=en&u=https%3A%2F%2Fwww.sigbus.info%2Fcompilerbook
- https://github.com/rui314/chibicc
- unix history repo
  - https://github.com/dspinellis/unix-history-repo/blob/Research-V2-Snapshot-Development/c/nc0/c00.c
