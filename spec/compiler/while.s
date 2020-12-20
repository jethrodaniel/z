.intel_syntax noprefix
.globl main
p:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp-8], rdi
  mov rax, [rbp-8]
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
main:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  push 5
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
  push 48
  pop rdi
  pop rax
  add rax, rdi
  push rax
  pop rdi
  call p
  push rax
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
  jmp label_begin_1
label_end_1:
  pop rax
  mov rsp, rbp
  pop rbp
  ret
