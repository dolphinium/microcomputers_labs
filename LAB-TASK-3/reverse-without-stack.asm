;REVERSE THE INITIALIZED ARRAY WITH MOVSB, LODSB, CLD AND STD

org 100h
;*******************************************************************
;CLEAR DIRECTION FLAG INSTRUCTION "CLD" SETS THE DF TO 0
CLD             ;DF = 0 MEANS SI = SI + 1   -->ASCENDING ORDER
LEA SI,string1  ;LOAD EFFECTIVE ADDRES OF OUR STRING TO SI
MOV DI,2000H    ;SET DI TO 2000H  
MOV CX,14       ;SET COUNTER TO 14
REP MOVSB       ;REPEAT MOVSB 14 TIMES
;*******************************************************************     
;LAST ELEMENT OF MICROCOMPUTERS IS 200DH AT THE END OF THIS PART
;NOW LETS SET DIRECTION FLAG TO 1 WITH STD WHICH IS DESCENDING ORDER
STD             ;DF = 1 MEANS SI = SI -1
MOV CX,14       ;SET COUNTER TO 14
MOV DI,3000H    ;MOVE DI TO 3000H
MOV SI,200DH    ;SET SI TO 200DH BECAUSE LAST ELEMENT IS ON THERE 
;*******************************************************************    
L1:
LODSB           ;LOAD BYTE AT DS INTO AL
MOV [DI],AL     ;REGISTER INDIRECT MEMORY PART
INC DI          ;INCREMENT DI              
LOOP L1 

;NOW WE HAVE REVERSE ORDERED STRING AT MEMORY 3000H-3000DH
;*******************************************************************
CLD             ; DF = 0 MEANS SI = SI + 1 WHICH IS ASCENDING ORDER
MOV SI,3000H    ; SI = SI+1
MOV DI,2000H    ; DI = DI+1
MOV CX,14       ; SET COUNTER TO 14
REP MOVSB       ; REPEAT MOVSB 14 TIMES

;*******************************************************************

ret

string1 db 'MICROCOMPUTERS'  ; initial array    


