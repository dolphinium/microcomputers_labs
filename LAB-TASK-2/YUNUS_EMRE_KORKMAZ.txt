ORG 100H 

    mov DI,2000H    ;Move Destination Index to 2000H   
    mov cx, 14      ;Set Counter to 14 
    stack_push_loop:
    mov ah, 1h      ;set mode to read from emulator screen
    int 21h         ;keyboard interrupt key      
    mov [DI],ax     ;move ax to memory (register-indirect memory)
    INC DI          ;increase destination index
    push ax         ;push the value on ax to stack 
    loop stack_push_loop
    
    mov cx,14       ;set counter to 14
    mov DI,2000H    ;reset DI
    stack_pop_loop:
    pop bx          ;pop the last element of stack to bx
    mov dx, bx      ;copy bx to dx
    MOV [DI],DX     ;move dx to memory (register-indirect memory)
    INC DI          ;increase the DI's value
    mov ah, 2h      ;special code to set mode writing to the console
    int 21h         ;keyboard interrupt key
    loop stack_pop_loop

ret
