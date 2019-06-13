;The program takes in a value from the user and uses the ConvertBin
;ConvertHext, and ConvertOct functions so the user are given the 
;numbers in three different types. It takes the string and converts
;it into integers and then it is divided by the radux of the three
;types. The result is then displayed onto the monitor for the user
;to see.
section .data
    txt1: dw "Please enter a number: ",10 ,0
    Dec: dw "Output for decimal: ",0
    Oct: dw "Output for octal: ",0
    Hex: dw "Output for hexadecimal: ",0
    Bin: dw "Output for Binary: ",0
	newLine dw " ",10,0
    buffer: db 0

section .bss
    variable: resw 1		    ; reserve 64 byte
    variableend: resw 1 		; end of value character
    shift: resw 1       		;value that will be multiplied to get conversion from ascii to int
    valueBin: resb 32           ;stores conversion in ascii
    valueOct: resb 32
    valueHex: resb 32
    valueBinPos: resb 32        ;stores pos of value
    valueOctPos: resb 32
    valueHexPos: resb 32

section .text
    global  _start 
    
_start:
    mov rax, 1
    mov [shift], rax        ;moving value into shift

	mov rax, txt1		
	call _print				;printing enter a number
	
	call _getvariable		;calling for user input
	
	mov rax, newLine
	call _print				;printing newline

	mov rax, Bin
	call _print 			;printing message for binary

	mov rbx, variableend
	call _atoi              ;calling function to convert to ascii

	xor rax, rax
	add eax, [buffer]
	call _ConvertBin		;calling function to convert to Binary

	mov rax, Oct
	call _print 			;printing octal

	xor rax, rax
	add eax, [buffer]
	call _ConvertOct		;calling function to convert to Octal

	mov rax, Hex
	call _print				;calling to print for Hex

	xor rax, rax
	add eax, [buffer]
	call _ConvertHex

    mov rax, 60 
    mov rdi, 0
            
    syscall                 ;end of program.
    
;this function is getting the user input. 
;sotres it as a string. 
_getvariable:
    mov rax, 0
    mov rdi, 0
    mov rsi, variable
    mov rdx, 16
    syscall
    ret
;***************************************************
;_atoi:
;the function converts the character from string of 
;ascii characters to integers.
;Have an empty variable after value to access the 
;string in value from right to left. we can subtract
;0x30 from each character and get the integer value
;The value shift contains the beginning value and is
;multiplied by 10 each loop occurance. It is then
;multipled by the integer value by the string 
;and added to the buffer we created. 
;The final number is held in the buffer.
;***************************************************
_atoi:
    xor rax, rax                        ;clear registers
    xor r8, r8
_Set:    
    movzx rcx,byte [rbx]                ;mov a char to rcx
    cmp rcx, 0                          ;compare it to null terminator
    je _dec                             ;jumps to the loop decrement
    cmp rcx, 10                         ;compare it to new line
    je _dec                             ;jump to loop to decrement
    cmp rcx, 13                         ;compare it to 13 
    je _dec                             ;jump to loop to decrement
    dec rbx                             ;once pasted previous coditions, decrement once more
_top:

    cmp rcx, '0'                        ;check if the characters value is less than 0x30
    jb _done                            ;if it is, done
    cmp rcx, '9'                        ;check if the value is more than 39
    ja _done                            ;if it is yes, done
    sub rcx, '0'                        ;else subtract 0x30
    
    mov rdx, rcx                        ;add value to rdx
    mov rax, rcx                        ;and rax
    mov r8, [shift]                     ;move value of shift to r8 
    mul r8                              ;multiply r8 with rax

    add rax, [buffer]                   ;setting value to rax
    mov [buffer], rax                   ;setting a different value to rax
    
    mov rax, [shift]                    ;mov shift value to rax
    mov r8, 10                          ;move r8 value of 10
    mul r8                              ;multiply r8 and rax 
    mov [shift], rax                    ;moves value to shift
    movzx rcx, byte [rbx]               ;get the next character
    dec rbx                             ;decrement rbx

    jmp _top                            ;loop until comparason results in _done
    
_dec:
    dec rbx                             ;decrement  and jumps back to _set
    jmp _Set
_done:                                  ;once conversions done return to main
    ret
;print statments for saying which number is octal, Binary,
;and Hexadecimal.             
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
;*******************************************************
;the _ConvertBin gets the value from the user
;and converts it to binary by dividing it by 2.
;after it will push it onto a stack and it will
;then pop it off and go onto the next character. 
;it will then check to see if it is zero and 
;if it is, then it will exit and print out the numbers
;********************************************************
_ConvertBin:
    mov rcx, valueBin		;setting valueBin
    mov rbx, 10             ;mov newline char to ebx
    mov [rcx], rbx          ;add newline to rcx
    inc rcx                             
    mov [valueBinPos], rcx  ;move that value into ValueBinPos

_loop1:
    mov rdx, 0
    mov rbx, 2                          
    div rbx                  ;divideds rax by rbx
    push rax                 ;pushing rax onto the stack
    add rdx, 48              ;add 48 to get asscii char

    mov rcx, [valueBinPos]   ;move valueBinPos to rcx
    mov [rcx], dl            ;store results from the dl
    inc rcx                             
    mov [valueBinPos], rcx   ;get next char

    pop rax                  ;getting value from stack
    cmp rax, 0               ;check if rax is a zero
    jne _loop1               ;loop until rax is zero
_loop2:
    mov rcx, [valueBinPos]   ;get the last value from valueBinPos
    mov rax, 1                      
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall                  ;print char to console

    mov rcx, [valueBinPos]              
    dec rcx
    mov [valueBinPos], rcx   ;get next char

    cmp rcx, valueBin        ;Once valueBin and valueBinPos are equal we are done
    jge _loop2               ;loop if not
    ret
    
;******************************************************
;_ConvertOct is taking the value of the input 
;and dividing it by 8 and then it will push it onto 
;a stack and it will continously divide it by 8 until
;the number is zero. Once the number is zero, it will
;the print out the number giving it in Octal.
;******************************************************    
_ConvertOct:
    mov rcx, valueOct		;set valueOct to rcx
    mov rbx, 10                         
    mov [rcx], rbx
    inc rcx                 ;increase position
    mov [valueOctPos], rcx  ;store rcx in valueOctPos

_loop3:
    mov rdx, 0
    mov rbx, 0x08           ;move 8 to rbx
    div rbx                 ;divide rax by rbx, remainder stored in rdx
    push rax                ;push rax onto the stack
    add rdx, 48             ;add 48 to get ascii char

    mov rcx, [valueOctPos]  ;store remainder in edx in ascii to valueOctPos
    mov [rcx], dl
    inc rcx                 ;get next char
    mov [valueOctPos], rcx

    pop rax                 ;getting value back from stack
    cmp rax, 0              ;compare rax to zero
    jne _loop3              ;loop until rax is zero
_loop4:
    mov rcx, [valueOctPos]  ;get char from valueOctPos
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall                 ;print char to console

    mov rcx, [valueOctPos]  ;get next char from valueOctPos
    dec rcx
    mov [valueOctPos], rcx

    cmp rcx, valueOct       ;compare valueOct to valueOctPos
    jge _loop4              ;loop until they are equal
    ret
    
;**************************
;_ConvertHex is getting the value from the input
;and pushing it onto the register to be read. Then
;the value is divided by 16 and you add 48 so that 
;you can get the ascii character for it. After you 
;then do comparisons to numbers and see where it is
;at. We then add 7 because of the jump due to characters
;in the ascii code. It will then continously go to the next
;character and print them out once it exits the looping
;yielding the binary Number of the given input value
;**************************
_ConvertHex:
    mov rcx, valueHex        ;move valueHex to rcx
    mov rbx, 10
    mov [rcx], rbx          
    inc rcx                  ;get first char
    mov [valueHexPos], rcx   ;store rcx in valueHexPos

_loop5:
    mov rdx, 0          
    mov rbx, 16d             ;move 16 to rbx
    div rbx                  ;divide rax by rbx. remainder goes to rdx
    push rax                 ;push value of rax to stack
    add rdx, 48              ;add 48 to get ascii char
    
    cmp rdx, '9'             ;compare if value is less than the ascii char for 9
    jbe _finish              ;if it is skip next line
    add rdx, 7               ;if it is not, add 7 to get ascii value (A-F)
    
_finish:

    mov rcx, [valueHexPos]   ;store char to valueHexPos
    mov [rcx], dl
    inc rcx                  ;getting next char
    mov [valueHexPos], rcx

    pop rax                  ;get value from stack and put back to rax
    cmp rax, 0               ;see if rax is zero
    jne _loop5               ;loop until rax is zero
_loop6:
    mov rcx, [valueHexPos]   ;get char from valueHexPos
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall                  ;print char

    mov rcx, [valueHexPos]   ;get next char
    dec rcx
    mov [valueHexPos], rcx

    cmp rcx, valueHex        ;loop until valueHex equals valueBinPos
    jge _loop6
    ret
