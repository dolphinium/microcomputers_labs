TITLE   8086 Code Template (for EXE file)

;       AUTHOR          YUNUS EMRE KORKMAZ
;       DATE            03.01.2023
;       VERSION         1.00
;       FILE            number_game.ASM

; 8086 Code 
                               
                               
include emu8086.inc

                               
; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

NUMBERS	DB 00111110b, 01000000b, 00000000b, 00000000b, 00000000b, 00111001b, 01000000b, 00000000b 
             ;U 30       - 31      NUM 32     SPACE 33  SPACE 34    C  35       - 36      NUM  37 
             

ZEROTOTEN DB 00111111b,00000110b,01011011b,01001111b,01100110b,01101101b,01111101b,00000111b,01111111b,01101111b            
             

MyString2  DB 'RANDOM NUMBER: '  


Dots_User_Wins      DB 01111111b, 01000000b, 01000000b, 01000000b, 01111111b ;U
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;
                    DB 01111111b, 00100000b, 00011000b, 00100000b, 01111111b ;W
                    DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b ;I
                    DB 01111111b, 00000100b, 00001000b, 00010000b, 01111111b ;N
                    DB 01001111b, 01001001b, 01001001b, 01001001b, 01111001b ;S
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ; 
                                                                           
                                                                           
Dots_Computer_Wins  DB 00111110b, 01000001b, 01000001b, 01000001b, 00100010b ;C
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;
                    DB 01111111b, 00100000b, 00011000b, 00100000b, 01111111b ;W
                    DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b ;I
                    DB 01111111b, 00000100b, 00001000b, 00010000b, 01111111b ;N
                    DB 01001111b, 01001001b, 01001001b, 01001001b, 01111001b ;S
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;  
                    
                    
Dots_Tie            DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b ;I
                    DB 00000001b, 00000001b, 01111111b, 00000001b, 00000001b ;T
                    DB 01001111b, 01001001b, 01001001b, 01001001b, 01111001b ;S
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;
                    DB 00000001b, 00000001b, 01111111b, 00000001b, 00000001b ;T
                    DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b ;I
                    DB 01111111b, 01001001b, 01001001b, 01001001b, 01000001b ;E
                    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b ;
                                                                                            

TEMP DB 100 DUP(0)                          ;temporary array
RAND DB 100 DUP(0)
DIFFS DB 100 DUP(0) 

msg1   DW  'Enter a number between 0-9:', 0
 


              
DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      300h    DUP(?)
                
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

MAIN_PROG:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX
    

    GOTOXY 0,TEMP[1]      ;GOTO NEXT LINE
    
    LEA    SI, msg1       ; ask for the number
    CALL   print_string   ;
    CALL   scan_num       ; get number in CX.
    
    CMP CL,0H
    JL OUT_OF_BOUNDS
    
    CMP CL,9H
    JG OUT_OF_BOUNDS
    
    MOV    TEMP[0], CL    ; copy the number to TEMP[0].
    
    
    
    MOV AH,00H
    INT 1AH     ;GENERATE RANDOM NUMBER AND STORE IT IN DL
    
    MOV AL, DL
    MOV BL,0AH
    DIV BL
    

    MOV RAND[0],AH      ; COMPUTERS NUMBER
    
    MOV AH,00H
    INT 1AH     ;GENERATE RANDOM NUMBER AND STORE IT IN DL
    
    MOV AL, DL
    MOV BL,0AH
    DIV BL
    
    MOV AL,0H

    MOV RAND[1],AH      ; ACTUAL NUMBER
    JMP PRINT_PART
  
 
    OUT_OF_BOUNDS:
    INC TEMP[1]
    JMP MAIN_PROG


PRINT_PART:
 
 
ASCII_LCD:
; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX

	MOV DX, 2040h	; first Seven Segment Display
	MOV SI, 0
	MOV CX, 15

NEXT_ASCII:
	MOV AL, MyString2[SI]
	out DX,AL
	INC SI
	INC DX

	LOOP NEXT_ASCII
	
    MOV AL, RAND[1]
    ADD AL,30H   
    out DX,AL       ; PRINT THE RANDOM NUMBER IN ASCII DISPLAY



SEVEN_SEGMENT:
; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX

	MOV DX, 2030h	; first Seven Segment Display
	MOV SI, 0
	MOV CX, 8

NEXT_SEVEN:
	MOV AL,NUMBERS[SI]
	out dx,al
	INC SI
	INC DX

	LOOP NEXT_SEVEN
	
	MOV DX,2032H
	MOV BL,TEMP[0]
	MOV BH,0H
	MOV AL,ZEROTOTEN[BX]
	OUT DX,AL
	
	INC DX
	
	MOV DX,2037H
	MOV BL,RAND[0]
	MOV BH,0H
	MOV AL,ZEROTOTEN[BX]
	OUT DX,AL

; return to operating system:

CALCULATIONS:
    ;compare u and c if equal it means it's tie
    MOV AL,TEMP[0]  ;AL == U
    CMP RAND[0],AL
    JE  DOT_MATRIX_TIE
    ;if program reaches here there is still 3 prob.
    
    CMP AL,RAND[1]
    JLE FIX_1
    SUB AL,RAND[1]
    MOV TEMP[2],AL
    JMP COMP_CALC
     
    
    
    FIX_1:
    MOV AL, RAND[1]
    SUB AL,TEMP[0]
    MOV TEMP[2],AL
                  
    
    COMP_CALC:              
    MOV AL,RAND[0]
    CMP AL,RAND[1]
    JLE FIX_2
    SUB AL,RAND[1]
    MOV TEMP[3],AL
    JMP COMPARE  
    
    FIX_2:
    MOV AL,RAND[1]
    SUB AL,RAND[0]
    MOV TEMP[3],AL              
    
    
    COMPARE:
    MOV AL,TEMP[2]
    CMP AL,TEMP[3]
    JE DOT_MATRIX_TIE
    JG DOT_MATRIX_COMPUTER_WINS
    JL DOT_MATRIX_USER_WINS
         
    
    
    


DOT_MATRIX_TIE:
; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX


	MOV DX,2000h	; first DOT MATRIX digit
	MOV BX, 0

MAIN_DOT_TIE:
	MOV SI, 0
	MOV CX, 5

NEXT_DOT_TIE:
	MOV AL,Dots_Tie[BX][SI]
	out dx,al
	INC SI
	INC DX

	CMP SI, 5
	LOOPNE NEXT_DOT_TIE

	ADD BX, 5
	CMP BX, 40
	JL MAIN_DOT_TIE
 
    INC TEMP[1]

    JMP MAIN_PROG
    
    
DOT_MATRIX_USER_WINS:
; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX


	MOV DX,2000h	; first DOT MATRIX digit
	MOV BX, 0

MAIN_DOT_USER:
	MOV SI, 0
	MOV CX, 5

NEXT_DOT_USER:
	MOV AL,Dots_User_Wins[BX][SI]
	out dx,al
	INC SI
	INC DX

	CMP SI, 5
	LOOPNE NEXT_DOT_USER

	ADD BX, 5
	CMP BX, 40
	JL MAIN_DOT_USER
 
    INC TEMP[1]

    JMP MAIN_PROG 
    
    
    
DOT_MATRIX_COMPUTER_WINS:
; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
    MOV     AX, DSEG
    MOV     DS, AX
    MOV     ES, AX


	MOV DX,2000h	; first DOT MATRIX digit
	MOV BX, 0

MAIN_DOT_COMPUTER:
	MOV SI, 0
	MOV CX, 5

NEXT_DOT_COMPUTER:
	MOV AL,Dots_Computer_Wins[BX][SI]
	out dx,al
	INC SI
	INC DX

	CMP SI, 5
	LOOPNE NEXT_DOT_COMPUTER

	ADD BX, 5
	CMP BX, 40
	JL MAIN_DOT_COMPUTER
 
    INC TEMP[1]

    JMP MAIN_PROG           
    



    
START   ENDP

;*******************************************  


DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS


CSEG    ENDS 

        END    START    ; set entry point.

