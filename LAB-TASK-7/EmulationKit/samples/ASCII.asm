TITLE   8086 Code Template (for EXE file)
 
;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'
MyString  DB 'This is a TEST  of the ASCII LCDin Emulation Kit'
MyString2  DB 'ABCDEDFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

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

	MOV DX, 2040h	; first Seven Segment Display
	MOV SI, 0
	MOV CX, 48

NEXT:
	MOV AL, MyString2[SI]
	out DX,AL
	INC SI
	INC DX

	LOOP NEXT


; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

