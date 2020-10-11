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

If you're on CentOS (using `yum`, that is), set up c++17 with `make prereqs`.

## prerequisites

- c++17

## license

MIT

## references

> If I have seen further, it is by standing upon the shoulders of giants.
>
> Sir Isaac Newton, 1675

Thanks, y'all.

Dependencies

- https://github.com/fmtlib/fmt
- https://github.com/catchorg/Catch2 (test)

TempleOS

- https://templeos.org/
- https://github.com/cia-foundation/TempleOS
- https://harrisontotty.github.io/p/a-lang-design-analysis-of-holyc
- https://christine.website/blog/templeos-1-installation-and-basic-use-2019-05-20
- https://archive.org/details/TerryADavis_TempleOS_Archive
- https://minexew.github.io/2020/02/27/templeos-loader-part1.html
- https://minexew.github.io/2020/03/29/templeos-loader-part2.html
- https://minexew.github.io/2020/05/10/templeos-loader-part3.html
- https://www.youtube.com/watch?v=1hCrl2wsz5c

Compilers

- http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
- https://www.sigbus.info/compilerbook
  - https://github.com/KENNN/compiler-book
  - https://translate.google.com/translate?hl=en&sl=ja&tl=en&u=https%3A%2F%2Fwww.sigbus.info%2Fcompilerbook
  - https://github.com/rui314/chibicc

C++

- https://github.com/AnthonyCalandra/modern-cpp-features

Etc

- https://blogs.oracle.com/linux/hello-from-a-libc-free-world-part-1-v2
- https://blogs.oracle.com/linux/hello-from-a-libc-free-world-part-2-v2
