section .data:
    String1 db "SA single: ",0
    String2 db "DA double: ",0
    String3 db "SPI single: ",0
    String4 db "DPI double: ",0
    String5 db "SB single: ",0
    String6 db "DB double: ",0
    SA dw 500.312
    DA dq 500.13
    SPI dw 3.14159265358979323846264338327950288419716939937
    DPI dq 3.14159265358979323846264338327950288419716939937
    SB dw 1.456e6
    DBQ dq 1.456e6
    String db "0x43fa27f0",0
    String7 db "0x43fa10a4",0
    String8 db "0x40490fdb",0
    String9 db "0x40490fdb",0
    String10 db "1.456e6",0
    String11 db "1.456e6",0
    Newline db " ",10,0
    String12 db "SC = 500.312 * 1.456e6 = 11,880.86406264 in hex: ",0
    StringSC db "0x41300000",0
    StringTrun db "SB: 1.456e6 = 49B1BC00",0
    StringTrun2 db "DB: 1.456e6 = 4136378000000000",0
section .bss:

section .text:
    global _start

_start:
    mov rax, String1 ;moving string to register
    call _print      ;calling print function
    
    mov rax, String
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, String2
    call _print
    
    mov rax, String7
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, String3
    call _print
    
    mov rax, String8
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, String4
    call _print
    
    mov rax, String9
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, String5
    call _print
    
    mov rax, String10
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, String6
    call _print
    
    mov rax, String11
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, String12
    call _print
    
    mov rax, StringSC
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, StringTrun
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, StringTrun2
    call _print
    
    mov rax, Newline
    call _print
    
    mov rax, 60
    mov rdi, 0
    syscall
    
    
_print:
    push rax
    mov rbx, 0
_printloop:
    inc rax
    inc rbx
    mov ecx, [rax]  ;moving rax into cl
    cmp cl, 0       ;compare it with 0, if not 0
    jne _printloop  ;jump back to loop
    
    mov rax, 1
    mov rdi, 1
    pop rsi         ;popping off the stack
    mov rdx, rbx,
    syscall
    
    ret

