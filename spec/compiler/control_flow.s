.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  call test_while
  push rax
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
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
  pop rax
  mov rsp, rbp
  pop rbp
  ret
test_while:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  push 10
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
label_begin_1:
  mov rax, [rbp-8]
  push rax
  push 0
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_end_1
  mov rax, [rbp-8]
  push rax
  push 1
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  pop rax
  jmp label_begin_1
label_end_1:
  mov rax, [rbp-8]
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
