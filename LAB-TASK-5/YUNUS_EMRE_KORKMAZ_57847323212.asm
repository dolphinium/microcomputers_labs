
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

mov palprime_array[0], 2 ; 2 is palprime's initial element
mov cx, 998              ;last number
mov bx, 3                ;first number to check temp[0]
mov di,2                 ;di should point the second element of array
    
    

main:
    mov temp[0],bx  ;to keep original value of number
    mov temp[2],cx  ;to track cx in variables windows
    
    reverse: 
    cmp bx,100      ;compare number with 100 if greater than or eq 
    jge reverse_greater_than_100    ;go to reverse_greater_than_100
    xor dx,dx       ;clear dx
    mov ax, bx      ;move the number to ax
    mov bx,10       ;set divisor to 10
    div bx          ;divide number to 10
    cmp ax,0        ;if quotient is 0 go to check prime
    je is_prime     ;if jumps number is lt 10
    
    cmp ax,dx       ;if not compare quotient and remainder if equals check prime
    je is_prime     ;if jumps number is in range 10-100
    jne reload      ;if not reload
    
    
    reverse_greater_than_100:
    xor dx,dx       ;clear dx
    mov bx,10       ;set divisor to 10
    mov ax,temp[0]  ;set ax to number 
    div bx          ;divide number to 10        
    mov temp[4],dx  ;*100
    xor dx,dx       ;clear dx
    div bx          ;divide again
    mov temp[6],dx  ;*10
    xor dx,dx       ;clear dx
    div bx          ;divide again
    mov temp[8],dx  ;*1
    
    mov bx,100      ;multiply number with 100
    mov ax, temp[4] ;set ax to number
    mul bx          ;multiply 
    mov temp[10],ax ;save the result
    
    mov bx,10       ;multiply number with 10
    mov ax,temp[6]  ;set ax to number
    mul bx          ;multiply
    mov temp[12],ax ;save the result
    
    mov ax, temp[10]
    add ax, temp[12]
    add ax, temp[8]
    mov temp[14],ax ;store the result
       
    cmp temp[0],ax  ;compare two numbers
    je is_prime     ;if numbers are equal check prime
    jne reload      ;if not reload 


    is_prime:       
    xor dx,dx       ;clear dx
    mov ax,temp[0]  ;take original value of number to ax
    mov bx,0002h    ;set divider to 2
    div bx          ;divide
    cmp dx,0        ;if number is even reload
    jz reload       
       
        l1:                                                                    
        mov ax,temp[0] ;load the number                                        
        xor dx,dx      ;clear dx
        div bx         ;ax/bx
        cmp dx,0       ;if remainder is 0
        je reload      ;reload 
        inc bx         ;if not increase bx
        cmp bx,ax      ;check if ax>=bx 
        jge save_and_reload ;if true save and reload                 
        jne l1              ;if not go to l1
          
    
       
    
    save_and_reload:            ;if number satisfies the conditions save and reload
    mov bx, temp[0]             ;load the numbebr
    mov cx, temp[2]             ;load the counter
    mov palprime_array[di],bx   ;save numer on di
    add di,2                    ;increase di
    inc bx                      ;increase the number
    loop main                   ;loop main

    reload:             ;if number does not satisfies the conditions reload
    mov bx,temp[0]      ;load the number  
    mov cx,temp[2]      ;load the counter
    inc bx              ;increase the number
    loop main           ;loop main

ret                             ;when cx = 0 return

temp dw 100 dup(0)              ;initialize the temporary array 
palprime_array dw 100 dup(0)    ;initialize the palprime array



