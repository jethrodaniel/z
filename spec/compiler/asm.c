// == Assembly
//
// Heavily inspired by D. See https://dlang.org/spec/iasm.html

main() {
  // Assembly here uses the same tokens as the rest of the language.
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
// assembler - if you want an assembly file, just put code in an assembly
// block.
asm {
  test_asm_fn:
    mov rax, 42;
    push 0;
    pop rax;
    ret;
}

test_asm_in_fn() {
  asm {
    // At the moment, an assembly block inside a function is an expression, and
    // as such, is expected to push a value to the stack, which will be popped
    // into rax.
    push 0;
    pop rax;
    ret;
  }

  return 42;
}
