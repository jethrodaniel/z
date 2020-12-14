.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push  42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
