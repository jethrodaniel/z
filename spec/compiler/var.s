.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  call test_vars
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
p:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp-8], rdi
  push 48
  mov rax, [rbp-8]
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  pop rdi
  call putchar
  push rax
  push 10
  pop rdi
  call putchar
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
test_vars:
  push rbp
  mov rbp, rsp
  sub rsp, 24
  push 5
  pop rax
  mov [rbp-24], rax
  mov rax, [rbp-24]
  push rax
  pop rax
  mov [rbp-16], rax
  mov rax, [rbp-16]
  push rax
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-8]
  push rax
  pop rdi
  call p
  push rax
  push 4
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-8]
  push rax
  pop rdi
  call p
  push rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-24]
  push rax
  push 3
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rdi
  pop rax
  imul rax, rdi
  push rax
  push 5
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rax
  mov [rbp-16], rax
  mov rax, [rbp-16]
  push rax
  mov rax, [rbp-16]
  push rax
  pop rdi
  call p
  push rax
  mov rax, [rbp-8]
  push rax
  pop rax
  mov [rbp-16], rax
  mov rax, [rbp-16]
  push rax
  push 2
  pop rdi
  pop rax
  imul rax, rdi
  push rax
  mov rax, [rbp-24]
  push rax
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  push 1
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rax
  mov [rbp-24], rax
  mov rax, [rbp-24]
  push rax
  mov rax, [rbp-24]
  push rax
  pop rdi
  call p
  push rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-16]
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  push 1
  pop rdi
  pop rax
  add rax, rdi
  push rax
  mov rax, [rbp-24]
  push rax
  push 4
  pop rdi
  pop rax
  imul rax, rdi
  push rax
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rdi
  call p
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
