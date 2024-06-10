;@author: YUNUS EMRE KORKMAZ
;ALPHAINDEX CHECKER

include emu8086.inc                         ;include emu8086.inc to use its functions.
org 100h

    main_loop:                              ;runs indefinetly
        PRINT 'PLEASE ENTER THE INPUT:'     ;prints the message
        mov temp[0],0                       ;set index counter to 0
        mov temp[2],0                       ;set match counter to 0
        mov temp[4],16H                     ;set column number to 22 because the input text is 22 characters long
                                            ;we will use this for calculate the x-y directions to print on appropriate location
        mov di,5                            ;the matched numbers starts from 5
        mov si,0

    take_input:                             ;loop that takes the char inputs
        mov ah ,01h                         ;input mode
        int 21h                             ;interrupt
        mov ah,0h                           
        mov word[si], ax                    
        inc si                              
                                            
        cmp al,13                           ;check if enter key is pressed if true go to print 
        je print_matches                    ;go to print_matches
                                            
        jmp is_match                        ;control if given char is match?
                                            

    is_match:             
        cmp al,5ah                          ; is number > Z
        jg out_of_bounds                    ; if true it is out of [A-Z] bounds
        cmp al,41h                          ; is number < A
        jl out_of_bounds                    ; if true it is out of [A-Z] bounds     
        
        mov bx,0                            ;we start to alphabet counter from 0
        mov temp[1],0                       ;set alphabet counter to 0
                                            
            match_loop:                     ;loop that find matches
                cmp al, alphabet[bx]        ;compare the given char with alphabet's bx. element   
                je index_control            ;if true go to index control
                inc temp[1]                 ;increase the alphabeth count before going to loop 
                inc bx                      ;increase the word's index before going to loop 
                jne match_loop              ;if not true go loop again
     
     
        index_control:
            cmp temp[0], bl         ;compare index counter with alphabet counter    
            je save_letter          ;if equals go save letter
            inc temp[0]             ;increase index counter
            jne take_input          ;if not equal go to take_input again

        out_of_bounds:              ;if index is out of [A-Z] bounds  
            inc temp[0]             ;increase the index
            jmp take_input          ;jump to take_input section

        save_letter:                ;save letter if the index count == alphabet count
            mov temp[di],al         ;save letter to temporary array
            inc di                  ;increment di to go to next char
            inc temp[0]             ;increment index counter
            inc temp[2]             ;increment match count 
            jmp take_input          ;jump to take_input section


        print_matches:              ;print the matched letters
            cmp si,5h
            je is_exit
            not_exit:
            cmp temp[2],0           ;if there is no match
            jz print_zero_match     ;jump to print_zero_match
            mov bl,temp[4]          ;take the x coordinate to bl register 
            add bl,temp[0]          ;add bl register 
            add bl,2                ;add 2 space after the input
            mov al,temp[3]          ;load the pos of y coordinate to al register  
            GOTOXY bl,AL            ;go to appropriate position
            PRINT ">"               ;print ">"
            mov ch,0h               ;clear the higher portion of cx
            mov cl,temp[2]          ;run the program match times 
            mov di,5                ;start from temp[5]
        print_loop:             
            mov al, temp[di]        ;load the char into al
            PUTC al                 ;put char
            inc di                  ;increment di
            loop print_loop         ;loop match times
            PRINT ">"               ;print ">" again
            mov ah,0                ;clear the higher portion of ax
            mov al,temp[2]          ;move al to match count
            CALL print_num          ;print match count as a decimal number
            inc temp[3]             ;increment y direction to go to next line
            mov al,temp[3]          ;move the appropriate x position to al register
            GOTOXY 0,AL             ;go to next line 
            jmp main_loop           ;jump to main loop for taking the next input

        print_zero_match:           ;if no matches
            mov bl,temp[4]          ;move x direction to bl register
            add bl,temp[0]          ;add bl the index count to calculate x-y direction
            add bl,2                ;add 2 space after input
            mov al,temp[3]          ;load the pos of Y direction  
            GOTOXY bl,AL            ;go to appropiate coordinates
            PRINT ">"               ;print ">"
            PRINT "0"               ;print "0"
            inc temp[3]             ;increment Y direction to go next line
            mov al,temp[3]          ;move Y direction to al register
            GOTOXY 0,AL             ;go to next line
            jmp main_loop           ;jump to main loop for taking the next input


        is_exit:                    ;this parts has not been implemented yet
            is_E:
                mov ax,word[0]      ;move ax to word's zeroth index          
                cmp al,45H          ;ASCII code of 'E'  
                je is_X             ;check next character if equal 
                jne not_exit        ;if not go to not_exit section 
            is_X:
                mov ax,word[1]      ;move ax to word's first index     
                cmp al,58H          ;ASCII code of 'X'            
                je is_I             ;check next character if equal
                jne not_exit        ;if not go to not_exit section
            
            is_I:
                mov ax,word[2]      ;move ax to word's second index
                cmp al,49H          ;ASCII code of 'I'            
                je is_T             ;check next character if equal
                jne not_exit        ;if not go to not_exit section
            
            is_T:
                mov ax,word[3]      ;move ax to word's third index
                cmp al,54H          ;ASCII code of 'T'            
                je exit             ;check next character if equal
                jne not_exit        ;if not go to not_exit section
                

        exit:                       ;if user input is 'EXIT' exit the program                       
        ret


DEFINE_PRINT_NUM                            ;defining the function for printing number in decimal format on emulator screen.
DEFINE_PRINT_NUM_UNS                        ;defining the function for printing unsigned number in decimal format on emulator screen.

alphabet  db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'   ;alphabet array
word  db 100 dup(0)
temp db 100 dup(0)                          ;temporary array
