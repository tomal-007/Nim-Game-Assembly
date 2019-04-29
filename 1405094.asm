.MODEL SMALL
.386

.STACK 100H

.DATA 

NG DB "NEW GAME$" 
CON DB "CONTINUE$"
EXT DB "EXIT$"
FILE_NAME DB "1405094.txt",0
TWO DB 2
FIVE DB 5   
ARA DB 0,1,3,5,7 
R DB ?
;N DB ?
RES DB ?
M DW ?
N DW ?
P DB ?
ROW DB ?
COUNT DB ?
;ARA DB 0,1,1,1,2
RAND DB ?
NEXTTO DB 6 
USER_ROW DB 5
USER_COL DB 5
STATE DB 0 
MSG1 DB "YOU WIN,CONGRATS! :D$"
MSG2 DB "YOU LOST :(  $"
MSG3 DB "YOUR MOVE, PRESS 'ENTER' $"
MSG4 DB "PC MOVE, PRESS 'P' $"
SUM_ DB ?
MSG5 DB 25 DUP(0),'$'
CONTGAME DB 0
PRESSED_ENTER DB 2
.CODE

MAIN PROC FAR
    
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,0
    MOV AL,03H
    INT 10H
    
    MOV AH,0BH
    MOV BH,00H
    MOV BL,0
    INT 10H
    
    MOV BH,0
    MOV DH,5
    MOV DL,30
    CALL MOVE_CURSOR
    MOV AL,219
    MOV BL,1
    CALL WRITE_CHAR
    
    MOV BH,0
    MOV DH,5
    MOV DL,35
    CALL MOVE_CURSOR
    
    MOV SI,0
    LOOP1:
        CMP SI,8
        JGE I_END
        MOV AL,NG[SI]
        MOV BL,2
        CALL WRITE_CHAR
        INC DL
        CALL MOVE_CURSOR
        INC SI
        JMP LOOP1
    I_END:
    
    MOV BH,0
    MOV DH,10
    MOV DL,35
    CALL MOVE_CURSOR
    
    MOV SI,0
    LOOP2:
        CMP SI,8
        JGE I_END2
        MOV AL,CON[SI]
        MOV BL,2
        CALL WRITE_CHAR
        INC DL
        CALL MOVE_CURSOR
        INC SI
        JMP LOOP2
        
    I_END2:

    MOV BH,0
    MOV DH,15
    MOV DL,37
    CALL MOVE_CURSOR
    
    MOV SI,0
    LOOP3:
        CMP SI,4
        JGE I_END3
        MOV AL,EXT[SI]
        MOV BL,2
        CALL WRITE_CHAR
        INC DL
        CALL MOVE_CURSOR
        INC SI
        JMP LOOP3
        
    I_END3:
    
    MOV BH,0
    MOV DH,5
    MOV DL,30
    CALL MOVE_CURSOR 
    
    MOV CH,5
    MOV CL,15
    
    LOOP_:
        MOV AH,0
        INT 16H
        CMP AH,72
        JE UP_
        CMP AH,80
        JE DOWN_
        ;CMP AH,83
        ;JE BR
        CMP AH,28
        JE ENT
        JMP LOOP_
        UP_:
          CALL UP
          JMP LOOP_
        DOWN_:
          CALL DOWN
          JMP LOOP_
   BR:
   ENT:
    CMP DH,15
    JE EXIT_
    CMP DH,10
    JE CONT
   NEW_GAME:
    MOV AH,05H
    MOV AL,1
    INT 10H
    
    MOV AH,0BH
    MOV BH,00H
    MOV BL,0
    INT 10H
    
    MOV DH,0
    ;WRITE CHAR
    MOV AL,0B3H
    MOV BL,2
    MOV CX,1
    MOV SI,0
    
    OUTER_LOOP:
        INC SI
        CMP SI,4
        JG MOVE 
        ADD DH,5
        ;MOVE CURSOR
        MOV BH,1
        MOV DL,10  
        MOV AH,ARA[SI]
        CMP AH,0
        JE OUTER_LOOP
        ;ADD DH,5
        INNER_LOOP: 
            CALL MOVE_CURSOR
            CALL WRITE_CHAR
            DEC AH
            JZ OUTER_LOOP
            ADD DL,5
            JMP INNER_LOOP
      
    MOVE:
    
    MOV BH,1
    MOV DH,5
    MOV DL,5
    CALL MOVE_CURSOR 
    
    MOV AL,219
    MOV BL,1
    CALL WRITE_CHAR
    
    MOV CH,5
    MOV CL,20
    
    CMP CONTGAME,1
    JE CONTPROMPT
    
    ROW_LOOP:
        
        MOV AH,0
        INT 16H
        CMP AH,72
        JE ROW_UP
        CMP AH,80
        JE ROW_DOWN
        CMP AH,28
        JE TAKE_
        ;CMP AH,2
;        JE ONE
        CMP AH,25
        JE PCMOVE
        CMP AH,18
        JE EXIT_
        JMP ROW_LOOP
        ROW_UP:
          CMP PRESSED_ENTER,1
          JE ROW_LOOP
          CALL UP
          MOV USER_ROW,DH
          MOV USER_COL,DL
          JMP ROW_LOOP
        ROW_DOWN:
          CMP PRESSED_ENTER,1
          JE ROW_LOOP 
          CALL DOWN
          MOV USER_ROW,DH
          MOV USER_COL,DL
          JMP ROW_LOOP
        TAKE_:
            MOV PRESSED_ENTER,1
            CMP CONTGAME,1
            JE ERASE
            MOV STATE,0
            MOV BH,1
            CMP USER_ROW,5
            JE FIRST
            CMP USER_ROW,10
            JE SECOND
            CMP USER_ROW,15
            JE THIRD
            CMP USER_ROW,20
            JE FOURTH
            
            FIRST:
                MOV SI,1
                CALL TAKE
                PUSH AX 
                MOV AL,ARA[SI]
                DEC AL
                MOV ARA[SI],AL
                CALL CUR_SUM
                CMP SUM_,0
                JE WIN_PROMPT
                POP AX
                JMP ROW_LOOP
            SECOND:
                ;MOV USER_ROW,DH
                ;MOV USER_COL,DL
                MOV SI,2
                ;MOV DH,10
                CALL TAKE
                PUSH AX 
                MOV AL,ARA[SI]
                DEC AL
                MOV ARA[SI],AL
                CALL CUR_SUM
                CMP SUM_,0
                JE WIN_PROMPT
                POP AX
                JMP ROW_LOOP
            THIRD:
                ;MOV USER_ROW,DH
                ;MOV USER_COL,DL
                MOV SI,3
                ;MOV DH,15
                CALL TAKE
                PUSH AX 
                MOV AL,ARA[SI]
                DEC AL
                MOV ARA[SI],AL
                CALL CUR_SUM
                CMP SUM_,0
                JE WIN_PROMPT
                POP AX
                JMP ROW_LOOP
            FOURTH:
                ;MOV USER_ROW,DH
                ;MOV USER_COL,DL
                MOV SI,4
                ;MOV DH,20
                CALL TAKE
                PUSH AX 
                MOV AL,ARA[SI]
                DEC AL
                MOV ARA[SI],AL
                CALL CUR_SUM
                Cmp SUM_,0
                JE WIN_PROMPT
                POP AX
                JMP ROW_LOOP
                
    PCMOVE:
          CMP CONTGAME,1
          JE ERASE 
          CMP PRESSED_ENTER,0
          JE ROW_LOOP
          MOV PRESSED_ENTER,0
          
          MOV STATE,1
          CALL PC_MOVE
          MOV CH,0
          MOV CL,COUNT
          CMP ROW,1
          JE FI
          CMP ROW,2
          JE SE
          CMP ROW,3
          JE TH
          CMP ROW,4
          JE FO
          
          FI:
             MOV SI,1
             MOV DH,5
             CALL TAKE
             ;PUSH AX 
             ;MOV AL,ARA[SI]
             DEC ARA[SI]
             ;MOV ARA[SI],AL
             ;POP AX
             LOOP FI
             MOV DH,USER_ROW
             MOV DL,USER_COL
             CALL MOVE_CURSOR
             JMP ROW_LOOP
          SE:  
             MOV SI,2
             MOV DH,10
             CALL TAKE
             ;PUSH AX 
             ;MOV AL,ARA[SI]
             DEC ARA[SI]
             ;MOV ARA[SI],AL
             ;POP AX
             LOOP SE
             MOV DH,USER_ROW
             MOV DL,USER_COL
             CALL MOVE_CURSOR
             JMP ROW_LOOP
          TH:
             MOV SI,3
             MOV DH,15
             CALL TAKE
             ;PUSH AX 
             ;MOV AL,ARA[SI]
             DEC ARA[SI]
             ;MOV ARA[SI],AL
             ;POP AX
             LOOP TH
             MOV DH,USER_ROW
             MOV DL,USER_COL
             CALL MOVE_CURSOR
             JMP ROW_LOOP
          FO:
             MOV SI,4
             MOV DH,20
             CALL TAKE
             ;PUSH AX 
             ;MOV AL,ARA[SI]
             DEC ARA[SI]
             ;MOV ARA[SI],AL
             ;POP AX
             LOOP FO
             MOV DH,USER_ROW
             MOV DL,USER_COL
             CALL MOVE_CURSOR
             JMP ROW_LOOP
    
    CONT:
        MOV CONTGAME,1
        MOV AH,03DH
        LEA DX,FILE_NAME 
        MOV AL,0
        INT 21H
        
        MOV BX,AX
        MOV AH,3FH
        MOV CX,5
        LEA DX,ARA 
        INT 21H
        ;MOV AH,ARA[0]
        AND ARA[0],07D
        AND ARA[1],07D
        AND ARA[2],07D
        AND ARA[3],07D
        AND ARA[4],07D
        JMP NEW_GAME
    WIN_PROMPT:
         MOV AH,05H
          MOV AL,2
          INT 10H
          
          MOV BH,2
          MOV DH,10
          MOV DL,30
          CALL MOVE_CURSOR
          
          LEA DX,MSG2
          MOV AH,9
          INT 21H
          jmp FIN_EXIT
    CONTPROMPT:
          CMP ARA[0],0
          JE PCMOVEPRINT
          MOV BH,1
          MOV DH,0
          MOV DL,30
          CALL MOVE_CURSOR
          
          LEA DX,MSG3
          MOV AH,9
          INT 21H
          
          MOV BH,1
          MOV DH,5
          MOV DL,5
          CALL MOVE_CURSOR
      JMP ROW_LOOP  
      
    PCMOVEPRINT:
          MOV BH,1
          MOV DH,0
          MOV DL,30
          CALL MOVE_CURSOR
          
          LEA DX,MSG4
          MOV AH,9
          INT 21H
          
          MOV BH,1
          MOV DH,5
          MOV DL,5
          CALL MOVE_CURSOR
          
          JMP ROW_LOOP
    ERASE:
          MOV CONTGAME,0
          MOV BH,1
          MOV DH,0
          MOV DL,30
          CALL MOVE_CURSOR
          
          LEA DX,MSG5
          MOV AH,9
          INT 21H 
          
          MOV BH,1
          MOV DH,USER_ROW
          MOV DL,USER_COL
          CALL MOVE_CURSOR
          
          CMP ARA[0],0
          JE PCMOVE
          JMP TAKE_
        
           
    EXIT_:
        PUSH AX
        MOV AH,STATE
        MOV ARA[0],AH
        POP AX
        MOV AH,03DH
        LEA DX,FILE_NAME
        MOV AL,2
        INT 21H
        
        ADD ARA[0],30H
        ADD ARA[1],30H
        ADD ARA[2],30H
        ADD ARA[3],30H
        ADD ARA[4],30H
        MOV BX,AX
        MOV AH,040H
        MOV CX,5
        LEA DX,ARA
        INT 21H
        FIN_EXIT:
        
        MOV AH,04CH
        INT 21H
        
        
    MAIN ENDP
    CUR_SUM PROC
    PUSH AX
    PUSH CX
    XOR AX,AX
    MOV SI,0
    MOV CX,4
    LOOP_SUM:
    INC SI
    ADD AL,ARA[SI]
    LOOP LOOP_SUM
    MOV SUM_,AL
    POP CX
    POP AX
    RET
    CUR_SUM ENDP
    
    WRITE_CHAR PROC
        PUSH AX
        PUSH BX
        PUSH CX
        MOV CX,1
        MOV AH,9
        INT 10H
        POP CX
        POP BX
        POP AX
        RET
    WRITE_CHAR ENDP
       
    
    MOVE_CURSOR PROC
        PUSH AX
        PUSH BX
        PUSH DX
        PUSH CX
        MOV AH,2
        INT 10H
        POP CX
        POP DX
        POP BX
        POP AX
        RET
        MOVE_CURSOR ENDP
    UP PROC
        CMP DH,CH
        JL EXIT
        MOV AL,0
        CALL WRITE_CHAR
        SUB DH,5
        CALL MOVE_CURSOR
        MOV AL,219
        MOV BL,1
        CALL WRITE_CHAR
        EXIT:
         RET
    UP ENDP
    DOWN PROC
        CMP DH,CL
        JE EX
        MOV AL,0
        CALL WRITE_CHAR
        ADD DH,5
        CALL MOVE_CURSOR
        MOV AL,219
        MOV BL,1
        CALL WRITE_CHAR
        EX:
         RET
    DOWN ENDP
    ODD PROC
        PUSH AX
        MOV AL,CH
        MOV AH,0
        MUL TWO
        DEC AX
        MOV CL,AL
        POP AX
        RET
    ODD ENDP
    TAKE PROC
        PUSH AX
        MOV AH,0
        MOV AL, ARA[SI]
        MUL FIVE
        ADD AL,5
        MOV DL,AL
        CALL MOVE_CURSOR
        MOV AL,0
        CALL WRITE_CHAR 
        MOV DL,5
        CALL MOVE_CURSOR
        POP AX
        RET
        TAKE ENDP
   PC_MOVE PROC
       
       PUSH AX
       PUSH BX
       PUSH CX
       PUSH DX
       CALL RANDOM
       MOV SI,1
       MOV AL,0
       MOV CX,4                 
       SUM:
       ADD AL,ARA[SI]
       INC SI
       LOOP SUM
       CMP AL,0
       JE EX_P
       CMP NEXTTO,5
       JNE GAME
       GAME:
         MOV NEXTTO,5
         CALL WIN_POS
         CMP AL,1
         JNE THEN
         XOR DX,DX
         MOV DL,RAND
         MOV SI,DX  
         CMP ARA[SI],0
         JE WHILE_
         MOV COUNT,1
         XOR DX,DX
         MOV DL,RAND
         MOV SI,DX
         DEC ARA[SI] 
         MOV BL,RAND
         MOV ROW,BL
         JMP FINAL_CHECK
         ;GET IT TO NAFIS
         WHILE_:
         XOR AX,AX
         MOV AL,RAND
         MOV BL,4
         DIV BL
         ADD AH,1
         MOV RAND,AH
         XOR DX,DX
         MOV DL,RAND
         MOV SI,DX
         CMP ARA[SI],0
         JE WHILE_
         MOV COUNT,1
         XOR DX,DX
         MOV DL,RAND
         MOV SI,DX
         DEC ARA[SI]
         MOV BL,RAND
         MOV ROW,BL
         JMP FINAL_CHECK
         ;GET IT TO NAFIS
       THEN:
          WHILE:
          XOR AX,AX
          MOV AL,RAND
          MOV BL,4
          DIV BL
          ADD AH,1
          MOV RAND,AH
          XOR DX,DX
          MOV DL,RAND
          MOV SI,DX
          CMP ARA[SI],0
          JE WOW
          JMP GO
          WOW:
            XOR AX,AX
            MOV AL,RAND
            MOV BL,4
            DIV BL
            ADD AH,1
            MOV RAND,AH
            XOR DX,DX
            MOV DL,RAND
            MOV SI,DX
            CMP ARA[SI],0
            JE WOW
          GO:
              XOR DX,DX
              MOV DL,RAND
              MOV SI,DX
              MOV BL,ARA[SI]
              MOV P,BL
              NEXTLOOP:
                  XOR DX,DX
                  MOV DL,RAND
                  MOV SI,DX
                  DEC ARA[SI]
                  CALL WIN_POS
                  XOR DX,DX
                  MOV DL,RAND
                  MOV SI,DX
                  CMP ARA[SI],0
                  JE AGAIN_
                  CMP AL,0
                  JE  NEXTLOOP
             
            AGAIN_:
                CALL WIN_POS
                MOV BL,P
                XOR DX,DX
                MOV DL,RAND
                MOV SI,DX
                SUB BL,ARA[SI]
                MOV COUNT,BL
                MOV BL,RAND
                MOV ROW,BL
                CMP AL,1
                JE FINAL_CHECK 
                XOR DX,DX
                MOV DL,RAND
                MOV SI,DX
                MOV BL,P
                MOV ARA[SI],BL
                JMP WHILE
            
        FINAL_CHECK:
             MOV SI,1
             MOV AH,0
             MOV CX,4
             YO:
             
             ADD AH,ARA[SI]
             INC SI
             LOOP YO
             
             CMP AH,0
             JE PLAYER_WIN
             
             XOR DX,DX
             MOV DL,ROW
             MOV SI,DX   
             MOV BL,COUNT
             ADD ARA[SI],BL
             
             POP DX
             POP CX
             POP BX
             POP AX
             
             
             RET
        EX_P:
           MOV AH,1
        PLAYER_WIN:
          MOV AH,05H
          MOV AL,2
          INT 10H
          
          MOV BH,2
          MOV DH,10
          MOV DL,30
          CALL MOVE_CURSOR
          
          LEA DX,MSG1
          MOV AH,9
          INT 21H
       
      
PC_MOVE ENDP

RANDOM PROC
    MOV AH,00H
    INT 1AH
    MOV AX,0
    MOV AL,DL
    MOV BL,4
    DIV BL 
    INC AH
    
    MOV RAND,AH 
    RET
RANDOM ENDP       
WIN_POS PROC

    MOV SI,1
    MOV CX,4
    MOV AL,0
    IN_:
      XOR AL,ARA[SI]
      INC SI
      LOOP IN_
    MOV CX,4
    MOV SI,1 
    MOV BL,0
    OUT_:
     OR BL,ARA[SI]
     INC SI
     LOOP OUT_
   
   CMP AL,0
   JE NEXT1
   MOV AL,0
   CHECK:
   CMP BL,1
   JE NEXT2
   MOV BL,0
   JMP RETU_
   NEXT1:
   MOV AL,1 
   JMP CHECK
   NEXT2:
   MOV BL,1
   JMP RETU_
   
   RETU_:
   XOR AL,BL
   MOV RES,AL
   RET
WIN_POS ENDP
        
END MAIN