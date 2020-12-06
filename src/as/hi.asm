global _start

section .text

_start:
  ; write(1, msg, 5)
  mov eax, 1
  mov rdi, 1

  ; https://stackoverflow.com/a/51543939/7132678
  mov rsi, msg
  mov rdx, 13
  syscall

  ; exit()
  mov rax, 60
  xor rdi, rdi
  syscall

section .data
msg: db "Hi!", 10 
