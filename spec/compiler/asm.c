// Assembly.
//
// Heavily inspired by D. See https://dlang.org/spec/iasm.html

main() {
  // Assembly here is a first class member of the language, and uses the
  // same tokens as the rest of the language.
  asm {
    push 24;
  }

  asm { pop rax; push 42; }

  asm {
    // At the moment, an assembly block inside a function is an expression, and
    // as such, is expected to push a value to the stack, which will be popped
    // into rax.
    pop rsi;
    push rsi;
  }
}

// Since assembly is fully supported, we don't need to have a separate
// assembler - if you want an assembly file, just put code in an assembly
// block.
asm {
  push 3;
  pop rsi;

  f:
    call printf;
    ret;
}
