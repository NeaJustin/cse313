section .data
    msg db 10d, 12d,"Hello world!"

section .text
    global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 13
    syscall 
    mov rax, 60
    mov rdi, 0
    syscall
