.intel_syntax noprefix
.globl main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 0
  pop rdi
  call print_fib
  push rax
  push 1
  pop rdi
  call print_fib
  push rax
  push 2
  pop rdi
  call print_fib
  push rax
  push 3
  pop rdi
  call print_fib
  push rax
  push 4
  pop rdi
  call print_fib
  push rax
  push 5
  pop rdi
  call print_fib
  push rax
  push 6
  pop rdi
  call print_fib
  push rax
  push 7
  pop rdi
  call print_fib
  push rax
  push 8
  pop rdi
  call print_fib
  push rax
  push 9
  pop rdi
  call print_fib
  push rax
  push 10
  pop rdi
  call print_fib
  push rax
  push 11
  pop rdi
  call print_fib
  push rax
  push 12
  pop rdi
  call print_fib
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
print_fib:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp-8], rdi
  push 102
  pop rdi
  call putchar
  push rax
  push 105
  pop rdi
  call putchar
  push rax
  push 98
  pop rdi
  call putchar
  push rax
  push 40
  pop rdi
  call putchar
  push rax
  mov rax, [rbp-8]
  push rax
  pop rdi
  call print_num
  push rax
  push 41
  pop rdi
  call putchar
  push rax
  push 32
  pop rdi
  call putchar
  push rax
  mov rax, [rbp-8]
  push rax
  push 10
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_1_1
  push 32
  pop rdi
  call putchar
  push rax
  jmp label_1
  label_1_1:
  label_1:
  push 61
  pop rdi
  call putchar
  push rax
  push 32
  pop rdi
  call putchar
  push rax
  mov rax, [rbp-8]
  push rax
  pop rdi
  call fib
  push rax
  pop rdi
  call print_num
  push rax
  call puts
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
puts:
  push rbp
  mov rbp, rsp
  sub rsp, 0
  push 10
  pop rdi
  call putchar
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
print_num:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp-8], rdi
  mov rax, [rbp-8]
  push rax
  push 0
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_2_2
  push 45
  pop rdi
  call putchar
  push rax
  push 0
  mov rax, [rbp-8]
  push rax
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  jmp label_2
  label_2_2:
  label_2:
  mov rax, [rbp-8]
  push rax
  push 10
  pop rdi
  pop rax
  cqo
  idiv rdi
  push rax
  pop rax
  cmp rax, 0
  je label_3_3
  mov rax, [rbp-8]
  push rax
  push 10
  pop rdi
  pop rax
  cqo
  idiv rdi
  push rax
  pop rdi
  call print_num
  push rax
  mov rax, [rbp-8]
  push rax
  mov rax, [rbp-8]
  push rax
  push 10
  pop rdi
  pop rax
  cqo
  idiv rdi
  push rax
  push 10
  pop rdi
  pop rax
  imul rax, rdi
  push rax
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rax
  mov [rbp-8], rax
  mov rax, [rbp-8]
  push rax
  jmp label_3
  label_3_3:
  label_3:
  mov rax, [rbp-8]
  push rax
  push 48
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
fib:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp-8], rdi
  mov rax, [rbp-8]
  push rax
  push 2
  pop rdi
  pop rax
  cmp rax, rdi
  setl al
  movzb rax, al
  push rax
  pop rax
  cmp rax, 0
  je label_4_4
  mov rax, [rbp-8]
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
  jmp label_4
  label_4_4:
  label_4:
  mov rax, [rbp-8]
  push rax
  push 1
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rdi
  call fib
  push rax
  mov rax, [rbp-8]
  push rax
  push 2
  pop rdi
  pop rax
  sub rax, rdi
  push rax
  pop rdi
  call fib
  push rax
  pop rdi
  pop rax
  add rax, rdi
  push rax
  pop rax
  mov rsp, rbp
  pop rbp
  ret
