.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 0
  pop rax
  cmp rax, 0
  je label1
  push 24
label1:
  push 1
  pop rax
  cmp rax, 0
  je label2
  push 2
  pop rax
  cmp rax, 0
  je label3
  push 3
  pop rax
  cmp rax, 0
  je label4
  push 4
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
label4:
  pop rax
label3:
label2:
  pop rax
  mov rsp, rbp
  pop rbp
  ret
