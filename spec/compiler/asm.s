.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  sub rax, 0
  add rax, 0
  push 0
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-8]
  push rax
  call test_asm_fn
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  call test_asm_fn
  push rax
  pop rdi
  pop rax
  add rax, rdi
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
test_asm_fn:
  mov rax, 42
  push 0
  pop rax
  ret
test_asm_in_fn:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 0
  pop rax
  ret
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
  mov rsp, rbp
  pop rbp
  ret
