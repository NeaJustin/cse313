section .data
    msg db 10d, 12d, "Hello, World!" ;;creating a new line with the 10d, 12d
section .text
    global _start  ;;moving to _start
_start:
    mov rax, 1   ;;sys_write function
    mov rdi, 1   ;;std_out File Descriptor
    mov rsi, msg ;;offset of msg
    mov rdx, 20  ;;length of msg
    syscall      ;;call the kernel
    mov rax, 60  ;;sys_exit function
    mov rdi, 0   ;;sucessful termination
    syscall      ;;call the kernel
end:             ;;end label
