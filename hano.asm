STK SEGMENT STACK
    DW 100H DUP(?)
TOP LABEL WORD
STK ENDS

DATA SEGMENT
AN   DW 5
BN   DW 0
CN   DW 0
A    DB 13,12,11,10,9,8,7,6,5,4,3,2,1
B    DB 30 DUP(?)
C    DB 30 DUP(?)
STR1 DB "Please input number(<=13) of dish!",0DH,0AH,24H
STR2 DB "Please press any key to next step!",0DH,0AH,24H
DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE,SS:STK
MAIN PROC FAR
     MOV AX,STK
     MOV SS,AX
     LEA SP,TOP
    
     MOV AX,DATA
     MOV DS,AX     
     
     LEA  DX,STR1
     MOV  AH,9
     INT  21H
     CALL INPU      ;disk number
     CALL CLEA      ;clean 
     
     LEA DI,A
     XOR DX,DX
     MOV CX,AN
  L4:
     MOV  [DI],CL   ;draw hano tower
     INC  DI
     MOV  AX,0F020H
     PUSH AX     
     PUSH CX
     INC  DX
     MOV  AL,DL
     MOV  AH,00H
     PUSH AX
     CALL DRAW      
     LOOP L4      
     
     MOV  AH,7
     INT  21H

     MOV  AX,0002H
     PUSH AX
     MOV  AX,AN
     MOV  AH,AL
     MOV  AL,01H
     PUSH AX
     CALL HANO 

     MOV AH,4CH
     INT 21H
MAIN ENDP

INPU PROC NEAR        
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH DS
     XOR BX,BX
  I1:MOV AH,7
     INT 21H
     CMP AL,0DH
     JE  I3
     CMP AL,30H
     JB  I1
     CMP AL,39H
     JA  I1
     MOV DL,AL
     MOV AX,BX
     MOV DH,10
     MUL DH
     AND DL,0FH
     XOR DH,DH
     ADD AX,DX
     CMP AX,13
     JA  I3
     MOV BX,AX
     ADD DL,30H
     MOV AH,2
     INT 21H
  I2:JMP I1
  I3:MOV AX,DATA
     MOV DS,AX
     CMP BX,0
     JBE I4
     MOV AN,BX
  I4:POP  DS
     POP  DX
     POP  CX
     POP  BX
     POP  AX
     RET
INPU ENDP

HANO PROC NEAR         
     PUSH BP
     MOV  BP,SP
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
  
     MOV  BX,[BP+4]    
     MOV  CX,[BP+6]    
     CMP  BH,1
     JBE  H1
     MOV  AH,CH       
     MOV  AL,BL
     PUSH AX
     MOV  AL,CL
     MOV  AH,BH
     DEC  AH
     PUSH AX
     CALL HANO

  H1:PUSH CX           
     CALL MOVE         

     CMP  BH,1
     JBE  H2
     MOV  AH,BL       
     MOV  AL,CL
     PUSH AX
     MOV  AL,CH
     MOV  AH,BH
     DEC  AH
     PUSH AX
     CALL HANO
  H2:
     POP  DX
     POP  CX
     POP  BX
     POP  AX
     POP  BP
     RET  4
HANO ENDP

MOVE PROC NEAR       
     PUSH BP
     MOV  BP,SP
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH DS
     PUSH SI
     PUSH DI     
      
     MOV  AX,DATA
     MOV  DS,AX

     MOV  AX,[BP+4]   
     CMP  AH,0         
     JNE  M1
     LEA  BX,A
     LEA  SI,AN
     JMP  M3
  M1:CMP  AH,1
     JNE  M2
     LEA  BX,B
     LEA  SI,BN
     JMP  M3
  M2:LEA  BX,C
     LEA  SI,CN
  M3:MOV  DI,[SI]    
     MOV  DX,0020H    
     PUSH DX
     MOV  DX,DI
     MOV  DH,AH
     PUSH DX
     DEC  DI
     MOV  CL,[BX+DI]
     XOR  CH,CH
     PUSH CX
     MOV  [SI],DI
     CALL DRAW     

     CMP  AL,0       
     JNE  M4
     LEA  BX,A     
     LEA  SI,AN
     JMP  M6
  M4:CMP  AL,1
     JNE  M5
     LEA  BX,B
     LEA  SI,BN
     JMP  M6
  M5:LEA  BX,C
     LEA  SI,CN
  M6:MOV  DI,[SI]    
     MOV  DX,0F020H  
     PUSH DX
     MOV  DX,DI
     INC  DX
     MOV  DH,AL
     PUSH DX
     MOV  [BX+DI],CL
     PUSH CX
     INC  DI
     MOV  [SI],DI
     CALL DRAW    
     
     MOV  AH,7       
     INT  21H
     POP  DI
     POP  SI
     POP  DS
     POP  DX
     POP  CX
     POP  BX
     POP  AX
     POP  BP
     RET 2
MOVE ENDP
 
CLEA PROC NEAR       
     PUSH AX
     PUSH CX
     PUSH DS
     PUSH ES
     PUSH DI
     MOV  AX,0B800H
     MOV  ES,AX
     MOV  AX,DATA
     MOV  DS,AX
     XOR  DI,DI
     MOV  CX,2000
     MOV  AX,0020H
  C1:MOV  ES:[DI],AX
     ADD   DI,2
     LOOP  C1
     
     LEA  SI,STR2
     XOR  DI,DI
     MOV  AH,2FH
     MOV  CX,34
  C2:MOV  AL,[SI]
     MOV  ES:[DI],AX
     ADD  DI,2
     INC  SI
     LOOP C2
     POP  ES
     POP  DI
     POP  DS
     POP  CX
     POP  AX
     RET
CLEA ENDP

DRAW PROC NEAR        
     PUSH BP
     MOV  BP,SP
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH DS
     PUSH DI
     PUSH SI
     MOV  AX,0B800H
     MOV  DS,AX
                      
     MOV  BX,[BP+6]   
     MOV  AX,19
     SUB  AL,BL
     MOV  SI,80
     MUL  SI
     MOV  SI,AX
     
     MOV  AX,27       
     MOV  BL,BH
     XOR  BH,BH
     MUL  BX
     ADD  SI,AX
     ADD  SI,13
     MOV  BX,SI  
     SHL  BX,1     
                      
     MOV  CX,[BP+4]  
     SHL  CX,1
     MOV  DI,CX
     NEG  DI
     MOV  AX,[BP+8]   
  D1:MOV  [BX+DI],AX
     ADD  DI,2
     LOOP D1
     
     MOV  CX,AX  
     MOV  AX,[BP+4]
     MOV  DI,10
     XOR  DX,DX
     DIV  DI
     MOV  DH,CH
     ADD  DL,30H
     MOV  [BX],DX
     MOV  AH,CH
     ADD  AL,30H
     MOV  [BX-2],AX

     POP  SI
     POP  DI    
     POP  DS
     POP  DX
     POP  CX
     POP  BX
     POP  AX
     POP  BP
     RET  6
DRAW ENDP

CODE ENDS
     END MAIN
