BITS	64
%idefine rip rel $       ;created 
GLOBAL	_start
_start:
    XOR edi, edi	; end_data_segment = NULL
    PUSH BYTE 12	; PUSH / POP is the shortest way of loading
    POP rax		; small immediates. Here: SYS_brk
    SYSCALL
    PUSH BYTE 99        ;push 99 bytes
    POP rdx		; 99 bottles of beer

    MOV r10, rax	    ;move r10 to rax
    MOV rbx, rax            ;add rax to rbx
    MOV r15, rax            ;add rax to r15
    LEA r12, [rel .putchar] ;do something
.reload:
    LEA rsi, [BYTE (.txt - .putchar) + r12]
.loop:
    LODSB	                ; Fetch a byte
    CMP al, 0               ;compare al to 0
    JG .char                ;jump to char
    CBW                     
    CWDE
    CDQE		    ; Byte to Quadword
    ADD rax, r12            ;add r12 to rax
    JMP rax                 ;jump to rax
.char:
    CALL r12
    JMP .loop
.exit:
    MOV rsi, r10	    ; buf = Base
    MOV rdx, rbx
    SUB rdx, r10            ; len = Ptr - Base
    PUSH BYTE 1
    POP rdi		    ; fd = stdout
    MOV eax, edi	    ; SYS_write
    SYSCALL

    XOR edi, edi	    ; returncode = 0
    PUSH BYTE 60
    POP rax		    ; SYS_exit
    SYSCALL
.nomore:
    PUSH rsi                ;push rsi
    MOV r13b, 7             ;mov 7o to r13b
    LEA rsi, [.nomore_txt]  ;mov nomore_txt to rsi
.nomore_loop:
    LODSB                   
    CALL r12                ;call r12
    DEC r13b                ;decriment r13b
    JNE .nomore_loop        ;if not true, jump to nomore_loop
    POP rsi                 ;pop rsi
    JMP .loop               ;jump to .loop
.plural:
    CMP dl, 1               ;compare dl to 1
    JE .loop                ;if true, jump to loop
    MOV al, 's'             ;move 's' to al
    CALL r12                ;call r12
    JMP .loop               ;jump to .loop
.restart:
    CMP dl, 0               ;comparing dl to 0
    JE .loop                ;if its equal then jump to .loop
    JMP .reload             ;else jump to reload
.sub:   
    DEC edx                 ;decriment edx
    CMP dl, 0               ;compare dl to 0
    JE .nomore              ;if equal, jump to nomore
.num:       
    MOV eax, edx            ;adding edx to eax
    MOV cl, 10              ;moving 10 to cl
    DIV cl                  ;diving by cl
    CMP al, 0               ;compariing al to 0
    JE .ignore0             ;if its equal, jump to ignore0
    PUSH rax                ;push onto the rax
    ADD al, '0'             ;add 0x30 to al
    CALL r12                ;call r12
    POP rax                 ;pop rax
.ignore0:
    MOV al, ah              ;mov ah to al
    ADD al, '0'             ;add 0x30 to al
    CALL r12                ;call r12
    JMP .loop               ;jump to .loop
.putchar:
    MOV ebp, eax            ;add eax to ebp
    CMP r15, rbx            ; Need more mem?
    JG .putchar_ok          ;jump to putchar_ok
    LEA rdi, [0x1000 + r15] ; New max (one page at a time...)
    MOV r15, rdi            ;add rdi to r15
    PUSH BYTE 12            ;push 12 onto byte
    POP rax		    ; SYS_brk
    SYSCALL
.putchar_ok:; 99 bottles of beer in AMD64-assembler for Linux.
;
; AMD64 (a.k.a x86_64) is a 64-bit extension to the x86 architecture.
;
; This program does rudimentary memory management via the brk()
; syscall (as can be seen by running it under strace). It features
; (gratuitous) use of the new 64-bit registers and the new program
; counter relative addressing mode.
    MOV [rbx], bpl          ;add bpl to rbx
    INC rbx                 ;increment rbx
    RET                     ;return
.txt:
    DB .num-.putchar, " bottle", .plural-.putchar, " of beer on the wall, "             ;creating a string
    DB .num-.putchar, " bottle", .plural-.putchar, " of beer.", 0x0a                    ;same thing
    DB "Take one down and pass it around, "                                             ;these are all strings basically
    DB .sub-.putchar, " bottle", .plural-.putchar, " of beer on the wall.", 0x0a, 0x0a  ;this is all just the same thing
    DB .restart-.putchar                                                        
    DB "No more bottles of beer on the wall, "
.nomore_txt:
    DB "no more bottles of beer.", 0x0a
    DB "Go to the store and buy some more, 99 bottles of beer on the wall.", 0x0a
    DB .exit-.putchar
