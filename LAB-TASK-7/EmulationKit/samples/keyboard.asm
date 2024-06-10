TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

NUMBERS	DB 00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b,
        DB 01110111b, 01111100b, 00111001b, 01011110b, 01111001b, 01110001b

DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

; Store return address to OS:
 	PUSH    DS
 	MOV     AX, 0
 	PUSH    AX

; set segment registers:
 	MOV     AX, DSEG
 	MOV     DS, AX
 	MOV     ES, AX

; initialization

	MOV CX, 8	; initialize all seven segment displays to empty
	MOV DX, 2030h
	MOV AL, 00h
INIT:	OUT DX, AL
	INC DX
	LOOP INIT
	
	MOV AL, 00h
	MOV DX, 2082h
	OUT DX, AL	
	MOV DX, 2083h
	OUT DX, AL	
	
NEXT:	
	MOV DX, 2083h 	; input data from keyboard (if buffer has key)
	IN  AL, DX    
	CMP AL, 00h
	JE  NEXT      	; buffer has no key, check again
	
	; a new key was pressed
	
	MOV DX, 2082h	; read key (8-bit input)
	IN  AL, DX	
	
	MOV BL, AL	; BX now has the key
	MOV BH, 0
	
	; display key on seven segment (using hexadecimal)
	
	MOV DX, 2030h 	; output most significant 4-bits
	MOV SI, BX
	AND SI, 00F0h
	MOV CL, 4
	ROR SI, CL
	MOV AL, NUMBERS[SI]
	OUT DX, AL

	MOV DX, 2031h 	; output least significant 4-bits
	MOV SI, BX
	AND SI, 000Fh
	MOV AL, NUMBERS[SI]
	OUT DX, AL
	
	MOV DX, 2032h	; output 'h' indicating hexadecimal key
	MOV AL, 01110100b
	OUT DX, AL

	; reset buffer indicator to allow more keys
	MOV DX, 2083h
	MOV AL, 00h
	OUT DX, AL
	
	JMP NEXT ; infinit loop

; return to operating system:
	RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

