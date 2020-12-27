// test: final result should print `0`.
//
// Heavily inspired by D. See https://dlang.org/spec/iasm.html
//
int main() {
  // Assembly uses the same tokens as the rest of the language.
  asm {
    sub rax, 0;
    add rax, 0;
  }
  n = 0;
  n = n + test_asm_fn()
        + test_asm_fn();

  putchar(48 + n);
}

// Since assembly is fully supported, we don't need to have a separate
// assembler - if you want to assemble an assembly file, just wrap it in
// an assembler block and compile with the compiler.
asm {
  test_asm_fn:
    mov rax, 42;
    push 0;
    pop rax;
    ret;
}

int test_asm_in_fn() {
  asm {
    push 0;
    pop rax;
    ret;
  }

  return 42;
}
