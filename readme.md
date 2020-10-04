# holycc

![](https://github.com/jethrodaniel/holycc/workflows/ci/badge.svg)

Following along with Rui Ueyama's 9cc, but implementing Terry David's HolyC.

## install

```
git clone --recursive git@github.com:jethrodaniel/cpp-starter app
cd app && make
```

If you forget the `--recursive`, check out the submodule like so

```
git submodule update --init --progress --depth=1
```

## license

MIT

## references

TempleOS

- https://github.com/cia-foundation/TempleOS
- https://harrisontotty.github.io/p/a-lang-design-analysis-of-holyc
- https://christine.website/blog/templeos-1-installation-and-basic-use-2019-05-20
- https://archive.org/details/TerryADavis_TempleOS_Archive

Compilers

- http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
- https://www.sigbus.info/compilerbook
  - https://github.com/KENNN/compiler-book
  - https://translate.google.com/translate?hl=en&sl=ja&tl=en&u=https%3A%2F%2Fwww.sigbus.info%2Fcompilerbook
  - https://github.com/rui314/chibicc
