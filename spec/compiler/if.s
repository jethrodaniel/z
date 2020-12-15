.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 0
  pop rax
  cmp rax, 0
  je label_1
  push 24
label_1:
  push 1
  pop rax
  cmp rax, 0
  je label_2
  push 2
  pop rax
  cmp rax, 0
  je label_3
  push 3
  pop rax
  cmp rax, 0
  je label_4
  push 4
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
label_4:
  pop rax
label_3:
label_2:
  pop rax
  mov rsp, rbp
  pop rbp
  ret
