// Assembly.
//
// Heavily inspired by D. See https://dlang.org/spec/iasm.html

main() {
  // For now, inline assembly must be within a function.
  //
  // Once expressions can exist in top-level scope, assembly outside of a
  // function will be possible.
  asm {
    push 24;
  }

  // Note the semicolons - there is no special tokenizing going on here.
  asm { pop rax; push 42; }

  asm {
    // At the moment, an assembly block is an expression, and as such, is
    // expected to push a value to the stack, which will be popped into rax.
    pop rsi;
    push rsi;
  }
}

// Since assembly is fully supported, we don't need to have a separate
// assembler - if you want an assembly file, just put code in an assembly
// block.
asm {
  push 3;
  pop;

  f:
    call printf;
    ret;
}
