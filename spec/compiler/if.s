.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  push 0
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-8]
  push rax
  call test_if
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  call test_if_nested
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  call test_if_zero
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  call test_if_else_braces
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
test_if:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_1
  push 2
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_1:
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_2
  push 2
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_2:
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_3
  push 0
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_3:
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
test_if_nested:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_4
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setle al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_5
  push 0
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_5:
  pop rax
label_4:
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
test_if_zero:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 0
  pop rax
  cmp rax, 0
  je label_6
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_6:
  push 0
  pop rax
  mov rsp, rbp
  pop rbp
  ret
test_if_else:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_7
  push 2
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_7:
  push 0
  pop rax
  cmp rax, 0
  je label_8
  push 3
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_8:
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_9
  push 0
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_9:
  push 0
  pop rax
  cmp rax, 0
  je label_10
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_10:
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
test_if_else_braces:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_11
  push 2
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
label_11:
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setg al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_12
  push 2
  pop rax
  mov rsp, rbp
  pop rbp
  ret
label_12:
  push 0
  pop rax
  cmp rax, 0
  je label_13
  push 3
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
label_13:
  push 2
  push 4
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_14
  push 0
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
label_14:
  push 0
  pop rax
  cmp rax, 0
  je label_15
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  pop rax
label_15:
  push 42
  pop rax
  mov rsp, rbp
  pop rbp
  ret
