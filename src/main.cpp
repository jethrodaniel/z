#include <iostream>
#include <stdio.h>
#include <string>

#include <holycc/holycc.hpp>

// = holycc
//
// == Language recognized so far:
//
// Just a single integer.
//

int main(int argc, char ** argv) {
  if (argc != 2) {
		std::cerr << "arg missing";
    return 1;
  }

  printf(".intel_syntax noprefix\n");
  printf(".globl main\n");
  printf("main:\n");
  printf("  mov rax, %d\n", atoi(argv[1]));
  printf("  ret\n");
  return 0;
}
