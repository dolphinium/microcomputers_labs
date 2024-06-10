     org 100h
;****************************************************************************************;

        lea si,a                        ;si -> address of first number 
        lea bx,b                        ;bx -> address of second number
        lea di,[2008h]                  ;di -> 2008h           
           
;*************--MOV VALUES OF FIRST AND SECOND NUMBER TO MEMORY 2000H-2008H--*************;       
        
        mov ax, word ptr[si]            ;mov the lower 16-bit of first number to 2000h-2002h
        mov [2000h],ax
        mov ax, word ptr[si+2]          ;mov the higher 16-bit of first number to 2002h-2004h        
        mov [2002h],ax
        mov ax, word ptr[bx]            ;mov the lower 16-bit of second number to 2004h-2006h
        mov [2004h],ax
        mov ax, word ptr[bx+2]          ;mov the higher 16-bit of second number to 2006h-2008h
        mov [2006h],ax                  
 
;****************************************************************************************; 
                    ; 3344 X 7788       
        
        mov ax,word ptr [si]            ;take lower 16bits (3344) of a into ax        
        mul word ptr [bx+0]             ;multiply ax with lower 16bits of b(7788) and store in ax
        mov [di],ax                     ;move the contents of ax to [di]
        mov cx,dx                       ;move the value of dx to cx  we will use this part later 
        
;****************************************************************************************;                                                                                               
                    ; 1122 x 7788 
                                                                                                 
        mov ax,word ptr [si+2]          ;take higher 16bits (1122) of a into ax
        mul word ptr [bx+0]             ;multiply ax with lower 16bits of b(7788)and store in ax
        add cx,ax                       ;cx=cx+ax
        mov [di+2],cx                   ;move the contents of cx to [di+2]
        mov cx,dx                       ;move contents of dx to cx
;****************************************************************************************;
                    ; 5566 x 3344 
                    
        mov ax,word ptr [si]            ;take lower 16bits(3344) of a in ax
        mul word ptr [bx+2]             ;multiply contents of ax with higher 16bits of b(5566)
        add word ptr [di+2],ax          ;c[di+2]=c[di+2]+ax
        adc cx,dx                       ;cx=cx+dx+cf    add with carry
        mov [di+4],ax                   ;move contents of ax to   [di+4]
        
;****************************************************************************************;       
                    ; 5566 X 1122          
                              
        mov ax,word ptr [si+2]          ;take higher 16bits of a(1122) into ax
        mul word ptr [bx+2]             ;multiply ax with higher 16bits of b(5566) and store in ax
        add cx,ax                       ;cx=cx+ax
        mov word ptr [di+4],cx          ;move contents of cx to c[di+4]
        adc dx,0000                     ;dx=dx+0000+cf  add with carry flag
        mov [di+6],dx                   ;move the contents of dx to [di+6]

        ret                             ;halt the emulator.   
;****************************************************************************************;
                ; NUMBER ASSIGNING PART        

    a dw 3344h, 1122h, 5 dup(0)         ;a is 32bit number a=1122 3344 
    b dw 7788h, 5566h, 5 dup(0)         ;b is 32bit number b=5566 7788


 