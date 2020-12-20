.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 3
  push 2
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_1_1
  push 65
  pop rdi
  call p
  push rax
  jmp label_1
  label_1_1:
  label_1:
  push 0
  push 3
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  push 2
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_2_2
  push 90
  pop rdi
  call p
  push rax
  jmp label_2
  label_2_2:
  label_2:
  push 0
  push 4
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  push 2
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_3_3
  push 90
  pop rdi
  call p
  push rax
  jmp label_3
  label_3_3:
  push 1
  pop rax
  cmp rax, 0
  je label_3_4
  push 66
  pop rdi
  call p
  push rax
  jmp label_3
  label_3_4:
  label_3:
  push 0
  push 3
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  push 3
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_4_4
  push 90
  pop rdi
  call p
  push rax
  jmp label_4
  label_4_4:
  push 2
  push 0
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_4_5
  push 67
  pop rdi
  call p
  push rax
  jmp label_4
  label_4_5:
  push 0
  pop rax
  cmp rax, 0
  je label_4_6
  push 90
  pop rdi
  call p
  push rax
  jmp label_4
  label_4_6:
  push 1
  pop rax
  cmp rax, 0
  je label_4_7
  push 90
  pop rdi
  call p
  push rax
  jmp label_4
  label_4_7:
  label_4:
  push 0
  pop rax
  cmp rax, 0
  je label_5_5
  push 90
  pop rdi
  call p
  push rax
  jmp label_5
  label_5_5:
  push 1
  pop rax
  cmp rax, 0
  je label_5_6
  push 68
  pop rdi
  call p
  push rax
  push 3
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_6_6
  push 90
  pop rdi
  call p
  push rax
  jmp label_6
  label_6_6:
  push 1
  pop rax
  cmp rax, 0
  je label_6_7
  push 69
  pop rdi
  call p
  push rax
  push 1
  push 2
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  push 3
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_7_7
  push 70
  pop rdi
  call p
  push rax
  jmp label_7
  label_7_7:
  push 1
  pop rax
  cmp rax, 0
  je label_7_8
  push 90
  pop rdi
  call p
  push rax
  jmp label_7
  label_7_8:
  label_7:
  jmp label_6
  label_6_7:
  label_6:
  jmp label_5
  label_5_6:
  push 1
  pop rax
  cmp rax, 0
  je label_5_7
  push 90
  pop rdi
  call p
  push rax
  jmp label_5
  label_5_7:
  label_5:
  pop rax
  mov rsp, rbp
  pop rbp
  ret
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
