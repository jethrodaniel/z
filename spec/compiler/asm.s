.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push  24
  pop  rax
  push  42
  pop  rsi
  push  rsi
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  push  3
  pop
  f:
  call  printf
  ret
