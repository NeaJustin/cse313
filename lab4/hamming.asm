section .data
    testNum: db 10101010b ;test number for hamming code

    text1 db "Starting binary number is 01010101",0
    text2 db "With correct parity ",0
    text3 db "Causing error in number... 010100100011",0
    text4 db "Correcting... ",0
    question3 db "it would take the same amount of time"
    q3cont db " because it is a linear program, that would run at constant time."
    q4cont db "this is because we are checking the for the parity bits one at a time."
    q5cont db "so it must go through the array one by incrementing it in a specific way."
    NL db " ",10,0
    buffer: db 0
    ;text5: db "Please enter a value you would like to be checked: ",0
    
    len3 equ $-text3
    len4 equ $-text4
lenq equ $-question3
lenq2 equ $-q3cont
    
section .bss
    testHamNumArr: TIMES 12 resb 1 ;array of bits to define hamming code
    variable: resw 1               ;stores user input
    variableend: resw 1            ;getting the position of the end of the variable
    shift: resw 1                  ;value that will be multiplied to be converted from ascii to int

    global _start
section .text
    
_start:
    call createParityArr_

    mov rax, 1
    mov rdi, testNum
    syscall

    xor rax, rax

    mov r11,9
    mov r8, 0
    mov r10, testHamNumArr
    add r10, 1
    mov rax, [testNum]

    call addBitsToArr_
    xor r10, r10
    xor rax, rax
    
    
    mov r8, testHamNumArr
    call setFirstParity_
    
    add r8, 1
    call setSecondParity_
    
    add r8, 2
    call setThirdParity_
    
    add r8, 4
    call setFourthPartiy_
    
    call causeError_
    
    call checkParity_
    
    call convertToAscii_

    mov rax, text1
    call _print
    
    mov rax, NL
    call _print
    
    mov rax, text2
    call _print
    
    call outputArray_
    
    mov rax, NL
    call _print
    
    mov rax, text3
    call _print
    
    mov rax, NL
    call _print
    
    mov rax, text4
    call _print
    
    call outputArray_
    
    mov rax, NL
    call _print
    
    mov rax, NL
    call _print
    
    mov rax, question3
    call _print
    
    mov rax, NL
    call _print
    
    mov rax, q4cont
    call _print
    
    mov rax, NL
    call _print
    
    mov rax, q5cont
    call _print
    
    mov rax, NL
    call _print
    
    mov rax, 60
    mov rdi, 0
    syscall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;getting the input of the user for the true value input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_getvariable:
    mov rax, 0
    mov rdi, 0
    mov rsi, variable
    mov rdx, 8
    syscall
    ret
     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;creatParityArr_ will set the 1st bit, the 2nd bit, the 4th bit, 
;and the 8th bit to 2 as a place holder for 0 so we can check 
;what it needs to be changed to. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
createParityArr_:
    mov r10, testHamNumArr      ;mvoing testHamNumArr into r10
    mov r8, 1                   ;putting 1 into r8
    mov byte [r10], 2           ;moving 2 into that spot of r10
    mov r11, 3                  ;mov 3 into r11
reserveParity_:
    dec r11                     ;decrementing r11
    add r10, r8                 ;add r8 to r10
    mov byte [r10],2            ;moving 2 into the spot of r10
    add r8, r8                  ;clearing the r8 register
    cmp r11, 0                  ;comparing r11 (counter to 0)
    jne reserveParity_          ;if not equal, jump to 
                                ;reserveParity_ again. 
    ret                         ;else its done and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;addBitsToArr_ will add the value that is being inputted into the 
;array. It will check to see where the parity bits are and skip
;those but add the value into the spots that are available. 
;This is to make sure it is not overwriting the parity Bits. 
;it will check to see if the number is odd in the rdx, and if it
;is, it will changed that value to 1 but it will first check to 
;see if there is a parity bit there. If there is, it will skip 
;that spot and go to the next spot over to input that number. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
addBitsToArr_:
    inc r10                     ;incrementing r10
    dec r11                     ;decrementing r11
    cmp r11, 0                  ;comparing r11 to 0
    jne continue_               ;if not equal jump to continue_
    xor r10, r10                ;else clear r10 
    ret                         ;and return

continue_:
    mov r12, 2                  ;move 2 into r12
    div r12                     ;diving by r12
    cmp dx, 1                   ;if the remainder is 1
    je remainderOne_            ;jump to remainderOne_
    jmp remainderZero_          ;else jumps to remainderZero_

remainderOne_:
    cmp byte[r10], 2            ;compares the byte of r[10] to 2
    JNE addNumToArr_            ;if its not equal, jump to 
                                ;addNumToArr_
    inc r10                     ;else increment r10
    jmp remainderOne_           ;and jump to remainderOne_

remainderZero_:
    cmp byte[r10], 2            ;comparing byte[r10] to 2
    JNE addBitsToArr_           ;if not equal jump 
                                ;to addBitsToArr_
    inc r10                     ;else increment r10
    jmp addBitsToArr_           ;then jump to addBitsToArr_

addNumToArr_:
    mov byte[r10], 1            ;moving byte[r10] to 1
    jmp addBitsToArr_           ;then jumps to addBitsToArr_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setToZero_:
    mov byte [r8], 0        ;if the byte is even, set it to zero
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setToOne_:
    mov byte [r8], 1        ;if it is odd, set it to 1
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setFirstParity_:
    mov r10, testHamNumArr  ;moving the arr into r10
    mov rax, [r10]          ;moving the value of r10 into rax
    add r10, 2              ;incrementing by twpo to check for
                            ;the first parity bit
    add rax, [r10]          ;moving that number into the rax
    add r10, 2              ;incrementing r10 by 2
    add rax, [r10]          ;adding it r10 to the rax
    add r10, 2
    add rax, [r10]          ;the rest is doing the same thing
    add r10, 2
    add rax, [r10]
    add r10, 2
    add rax, [r10]


    mov r9, 2               ;moving 2 into r9
    div r9                  ;diving r9
    cmp dx, 0               ;compare it to 0
    je setToZero_           ;if it is zero, jump to setToZero_
    jmp setToOne_           ;else it is odd and jump to setToOne_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setSecondParity_:
    mov r10, testHamNumArr  ;moving testHamNumArr into r10
    add r10, 1              ;increment r10 by 1 to get the second
                            ;parity bit
    mov rax, [r10]          ;mov r10 into rax
    add r10, 1              ;increment r10 by 1
    add rax, [r10]          ;add r10 into the rax
    add r10, 3              ;increment r10 by 3
    add rax, [r10]          ;add the value of r10 into the rax
    add r10, 1              ;increment r10
    add rax, [r10]          ;add that value in r10 into rax
    add r10, 3              ;increment r10 by 3
    add rax, [r10]          ;add r10 value into the rax
    add r10, 1              ;increment r10 by 1
    add rax, [r10]          ;add r10 value into the rax

    mov r9, 2               ;move 2 into 2
    div r9                  ;dividing by r9
    cmp dx, 0               ;comparing it to zero
    je setToZero_           ;if it is 0, its even and
                            ;jump to setToZero_
    jmp setToOne_           ;if it is 1, its odd and 
                            ;jump to setToOne_ 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setThirdParity_:
    mov r10, testHamNumArr  ;moving testHamNumArr into r10
    add r10, 3              ;incrementing r10 by 3
    mov rax, [r10]          ;the rest is doing the same as above
    add r10, 1              
    add rax, [r10]
    add r10, 1
    add rax, [r10]
    add r10, 1
    add rax, [r10]
    add r10, 4              ;incrementing r10 by 4
    add rax, [r10]          ;add value inot the rax
    add r10, 1              ;increment by 1
    add rax, [r10]          ;add r10 to rax

    mov r9, 2               ;move 2 to r9
    div r9                  ;diving by r9
    cmp dx, 0               ;compare if it is zero
    je setToZero_           ;if its zero, jump to setToZero_
    jmp setToOne_           ;else its odd, jump to setToOne_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setFourthPartiy_:
    mov r10, testHamNumArr  ;moving testHamNumArr
    add r10, 7              ;incrementing r10 by 7
    mov rax, [r10]          ;adding that value into r10
    add r10, 1              ;increment by 1
    add rax, [r10]          ;adding r10 value into rax
    add r10, 1              ;incrementing by 1
    add rax, [r10]          ;adding r10 value into rax
    add r10, 1              ;incrementing by 1  
    add rax, [r10]          ;adding r10 value into rax
    add r10, 1              ;incrementing by 1
    add rax, [r10]          ;adding r10 value into rax

    mov r9, 2               ;moving 2 into r9
    div r9                  ;dividing by r9
    cmp dx, 0               ;comparing to zero
    je setToZero_           ;if its even, jump to setToZero_
    jmp setToOne_           ;if its odd, jump to setToOne_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;will go through the testHamNumArr and check each byte again
;and see which bit is causing the error and then it changes
;it so to 0 or 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
causeError_:
    mov r10, testHamNumArr
    cmp byte [r10], 0
    je changeBit_
    mov byte [r10], 0
    ret
    changeBit_:
    mov byte [r10], 1
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;checking the parity of the testHamNumArr and comparing the 
;byte to 0 and if it is, change it to 1 otherwise it will be
;changed to 0. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkParity_:
    mov r10, testHamNumArr
    cmp byte [r10], 0
    je changeBit2_
    mov byte [r10], 0
    ret
    changeBit2_:
    mov byte [r10], 1
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;convertToAscii_ gets the values withint the tesHamNumArr
;and converts it into readable characters to the user.
;without it, it will print out 0x and the number that comes
;after it instead of 1's or 0's
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
convertToAscii_:
    mov r10, 0
    mov r8, testHamNumArr
    dec r8

Loop0_:
    inc r8
    mov r9, [r8]
    add r9, 48
    mov [r8], r9
    inc r10
    cmp r10, 12
    je ret_
    jmp Loop0_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;outputting the array by moving r10 to 13 as a counter
;then it moves the testHamNumArr into the rsi
;then you add 12 to the rsi to start at the end of the array
;so it can print out in proper order instead of appearing
;backwards.
;each time you dec rsi and the r10 so you can keep a counter
;and also move the testHamNumArr to the correct position as 
;well.
;when its done it will output it to the user and then it
;will exit the loop. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
outputArray_:
    mov r10, 13
    mov rsi, testHamNumArr
    add rsi, 12
    
Loop1_:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall
    dec rsi
    dec r10
    cmp r10, 0
    je ret_
    jmp Loop1_
    
ret_:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this is the pring statement for the new line and the output
;stating what it is. 
_print:
    push rax
    mov rbx, 0
_loop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _loop
    
    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
    ret
    
