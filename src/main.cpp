#include <iostream>
#include <stdio.h>
#include <string>

#include <holycc/holycc.hpp>

// = holycc
//
// == Language recognized so far:
//
// Addition/Subtraction - one number followed by zero or more numbers
// or +/-.

int main(int argc, char ** argv) {
  if (argc != 2) {
    std::cerr << "arg missing";
    return 1;
  }

  char *c = argv[1];

  printf(".intel_syntax noprefix\n");
  printf(".globl main\n");
  printf("main:\n");
  printf("  mov rax, %ld\n", strtol(c, &c, 10));

  while (*c) {
    if (*c == '+') {
      c++;
      printf("  add rax, %ld\n", strtol(c, &c, 10));
      continue;
    }

    if (*c == '-') {
      c++;
      printf("  sub rax, %ld\n", strtol(c, &c, 10));
      continue;
    }

    std::cerr << "Error: " << *c << "\n";
    return 1;
  }

  printf("  ret\n");
  return 0;
}
