#define FMT_HEADER_ONLY // needed to use as a header only lib
#include <fmt/format.h>
#include <fmt/color.h>

#include <holycc/compiler.hpp>

holycc::Compiler::Compiler() {
}

// = holycc
//
// == Language recognized so far:
//
// Takes as input a number or addition/subtraction, and exits with the
// result of the expression.

int holycc::Compiler::run(int argc, char **argv) {
  if (argc != 2) {
    fmt::print(stderr, fg(fmt::color::red) | fmt::emphasis::bold, "No input file provided!\n");
    return 1;
  }

  char *c = argv[1];

  fmt::print(".intel_syntax noprefix\n");
  fmt::print(".globl main\n");
  fmt::print("main:\n");
  fmt::print("  mov rax, {}\n", strtol(c, &c, 10));

  while (*c != 0) {
    if (*c == '+') {
      c++;
      fmt::print("  add rax, {}\n", strtol(c, &c, 10));
      continue;
    }

    if (*c == '-') {
      c++;
      fmt::print("  sub rax, {}\n", strtol(c, &c, 10));
      continue;
    }

    fmt::print(stderr, fg(fmt::color::red) | fmt::emphasis::bold, "Error: {}\n", *c);
    return 1;
  }

  fmt::print("  ret\n");

  return 0;
}