.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 42
  pop rdi
  call fib
  push rax
  mov rsp, rbp
  pop rbp
  ret
fib:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp-8], rdi
  push 41
  call g
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
g:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 1
  pop rax
  mov rsp, rbp
  pop rbp
  ret
