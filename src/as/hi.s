.intel_syntax noprefix
.globl _start
_start:
  // write(1, msg, 5)
  mov rax, 1
  mov rdi, 1
  // https://stackoverflow.com/a/51543939/7132678
  mov rsi, offset msg
  mov rdx, 13
  syscall

  // exit()
  mov rax, 60
  xor rdi, rdi
  syscall
msg:
  .ascii "hi!\n"
