.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 104
  pop rdi
  call putchar
  push rax
  push 105
  pop rdi
  call putchar
  push rax
  push 33
  pop rdi
  call putchar
  push rax
  push 10
  pop rdi
  call putchar
  push rax
  push 13
  pop rdi
  call putchar
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
