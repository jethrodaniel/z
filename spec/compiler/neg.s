.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  push 1
  pop rax
  neg rax
  push rax
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  push 66
  mov rax, [rbp-8]
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  pop rax
  neg rax
  push rax
  pop rax
  neg rax
  push rax
  pop rdi
  call putchar
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
