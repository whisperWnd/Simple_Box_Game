DATAS SEGMENT
CAR	   DB 5					;字符图形表
	   
	   DB 2,7,0,0
	   DB 2,7,0,1
	   DB 2,7,0,1
	   DB 2,7,0,1
	   DB 2,7,0,1
	   
WALL	DB 19
		DB 0DBH,7,0,0,1,0
		DB 0DBH,7,-13,-12,1,0
		DB 63,174,-13,15,1,1
		DB 0DBH,7,-18,15,1,0
		DB 0DBH,7,-14,-15,1,0
		DB 3,124,-8,17,1,4;红心
		DB 0DBH,7,-13,6,1,0
		DB 232,79,-13,10,1,-1
		DB 0DBH,7,-10,-40,1,0
		DB 0DBH,7,-11,10,1,0
		DB 63,174,-11,15,1,3
		DB 0DBH,7,-16,-10,1,0
		DB 232,79,-14,15,1,-1
		DB 0DBH,7,-10,17,1,0
		DB 3,124,-12,-20,1,4;红心
		DB 23,190,-12,15,1,5
		DB 0DBH,7,-12,-60,1,0
		DB 63,174,-11,15,1,2
		DB 0DBH,7,-9,24,1,0

		
LIVES   DB 3,12,0,79
CHOOSE DB 1
AGAIN   DB'CHALLENGE AGAIN?$'
RETRY DB 'RETRY$'
EXIT DB 'QUIT$'
CLEAR DB'CONGRATULATIONS!$'
COVER DB'     $'
REVERSE DB 0		
SPEED_UP DB 0
SLOW_DOWN DB 0		
PORTAL DB 0		
		
CHAR_CNT	DW   ?                  
POINTER	    DW   ?
LINE_ON	    DB   ?                   
COL_ON      DB   ?

CHAR_CNT1	DW   ?                  
POINTER1	DW   ?
LINE_ON1	DB   ?                   
COL_ON1     DB   ?

DATAS ENDS


CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
SRT PROC FAR
	
SRT ENDP    
MAIN  PROC	FAR
    PUSH DS
    SUB  AX,AX
    PUSH AX
	MOV  AX,DATAS	
    MOV	 DS,AX
    
   	CALL CLEAR_SCREEN
   	
   	LEA DI,WALL
   	MOV DH,-10
   	MOV DL,35
   	
   	SUB CH,CH
	MOV CL,[DI]			;CL=8
	INC DI
	MOV CHAR_CNT1,CX		;存字符个数
	MOV POINTER1,DI		;指向首字符
	MOV LINE_ON1,DH 		;起始位置
	MOV COL_ON1,DL
	
REFRESH: 
	MOV AL,1  	
    MOV [DI+4],AL
   	ADD DI,6
   	LOOP REFRESH
   	MOV CX,CHAR_CNT1
   	MOV DI,POINTER1
   	MOV AL,0
	MOV REVERSE,AL
	MOV SPEED_UP,AL
	MOV SLOW_DOWN,AL
	MOV PORTAL,AL
	MOV AL,5
   	
   	
   	LEA DI,CAR
   	MOV [DI],AL 
   	MOV DH,23		;车身起始位置（23，40）
   	MOV DL,40
   	
    CALL MOVE_SHAPE
    
    RET
    MAIN ENDP
;---------------------------------------------
;-----------------------------------------------
CLEAR_SCREEN PROC NEAR
	PUSH AX				;存原值
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV AH,6			;屏幕初始化
	MOV AL,0			;上卷行数，0为窗口空白
	MOV CH,0			;左上角行号
	MOV CL,0			;------列号
	MOV DH,24			;右下角行号
	MOV DL,79			;------列号
	MOV BH,7
	INT 10H
	
	POP DX				;出原值
	POP CX
	POP BX
	POP AX
	
	RET	
CLEAR_SCREEN ENDP
;-------------------------------------------------
DRAW_WALL PROC NEAR
	PUSH AX				;存原值
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	
	
	MOV AH,0FH			;取当前显示方式
	INT 10H				;BH页号
						;AH列数，AL显示方式
	INC DI
	MOV DH,LINE_ON1
	MOV DL,COL_ON1
	MOV CX,CHAR_CNT1
	
	DRAW_NEXT:
	
		ADD DH,[DI+2]
		ADD DL,[DI+3]
		
		PUSH CX
		MOV CL,[DI+4]
		CMP CL,0
		JZ DRAW_END
		POP CX
		
		MOV AH,2			;移动光标 			；；；；画图；；；；
		INT 10H
		
		MOV AL,[DI]			;取字符
		MOV BL,[DI+1]		;取字符属性
		PUSH CX	
		MOV CX,1			;显示次数
		MOV AH,09
		INT 10H				;显示字符
		
		CALL CRASH
		
DRAW_END:POP CX
		
		ADD DI,6			;指向下一个字符
		LOOP DRAW_NEXT
		
	POP DI
	POP DX				;出原值
	POP CX
	POP BX
	POP AX


	RET
DRAW_WALL ENDP
;---------------------------------------------
MOVE_SHAPE PROC NEAR
	PUSH AX				;存原值
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	
	
	
	MOV AH,0FH			;取当前显示方式
	INT 10H				;BH页号
						;AH列数，AL显示方式
	SUB CH,CH
	MOV CL,[DI]			;CL=7
	INC DI
	MOV CHAR_CNT,CX		;存字符个数
	MOV POINTER,DI		;指向首字符
	MOV LINE_ON,DH 		;起始位置
	MOV COL_ON,DL
	
	
	
	PLOT_NEXT:
		ADD DH,[DI+2]
		ADD DL,[DI+3]
		
		
		JMP MOV_CRSR
		CALL ERASE
		
	POP DI
	POP DX				;出原值
	POP CX
	POP BX
	POP AX
		
RET



	MOV_CRSR:
		MOV AH,2			;移动光标 			；；；；画图；；；；
		INT 10H
		
		MOV AL,[DI]			;取字符
		MOV BL,[DI+1]		;取字符属性
		PUSH CX	
		MOV CX,1			;显示次数
		MOV AH,09
		INT 10H				;显示字符
		
		POP CX
		ADD DI,4			;指向下一个字符
		LOOP PLOT_NEXT
		
			PUSH AX				;存原值
			PUSH BX
			PUSH CX
			PUSH DX
			PUSH DI
			
			LEA DI,WALL
			CALL DRAW_WALL
			
			LEA DI,CAR
			SUB CH,CH
			MOV CL,[DI]
			LEA DI,LIVES
	        MOV DH,[DI+2]
	        MOV DL,[DI+3]
DRAW_LIFE:
		MOV AH,2
	    INT 10H
	    MOV AL,[DI]
	    MOV BL,[DI+1]
	    PUSH CX
	    MOV CX,1
	    MOV AH,9
	    INT 10H
	    POP CX
	    INC DH
	    LOOP DRAW_LIFE
	        
	        POP DI
			POP DX				;出原值
			POP CX
			POP BX
			POP AX
		

		CALL DLY_QRTR		;延时
		
		
		CALL ERASE1
		CALL ERASE
		JMP SHORT PLOT_NEXT
MOVE_SHAPE ENDP
;-----------------------------------------------
CRASH PROC NEAR
	PUSH AX				;存原值
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI
	
	CMP DH,22
	JNZ CRASH_NEXT
	
	CMP DL,COL_ON
	JB CRASH_NEXT
	
	MOV AL,COL_ON
	PUSH DI
	LEA DI,CAR
	ADD AL,[DI]
	POP DI
	
	CMP DL,AL
	JA CRASH_NEXT
	
	MOV AL,0
	MOV [DI+4],AL
	
	MOV AL,[DI+5]
	CMP AL,-1
	JZ DIE
	CMP AL,1
	JZ REV
	CMP AL,2
	JZ SU
	CMP AL,3
	JZ SD
	CMP AL,4
	JZ ADD_LIFE
	CMP AL,5
	JZ TRANS
	
	CRASH_NEXT:
					
				CMP DH,24
				JNE CRASH_END
				MOV AL,0
				MOV [DI+4],AL
				MOV AL,[DI+5]
				CMP AL,-1
				JZ CRASH_END
				CMP AL,4
				JZ CRASH_END
				

    REDUCE_LIFE:
    			PUSH DI
                LEA DI,CAR
                MOV AL,[DI]
                SUB AL,1
                MOV [DI],AL
                POP DI
                CMP AL,0
                JNE CRASH_END				
    DIE:        CALL CLEAR_SCREEN
    			MOV DH,12
    			MOV DL,32
    			MOV AH,2
    			INT 10H
    			MOV DX,OFFSET AGAIN
    			MOV AH,9
    			INT 21H
    			
    WAITF:
                MOV AL,0
                CMP CHOOSE,AL
                JZ EX
    			MOV DH,13
    			MOV DL,28
    			MOV AH,2
    			INT 10H
    			MOV DX,OFFSET RETRY
    			MOV AH,9
    			INT 21H
    			MOV DH,13
    			MOV DL,42
    			MOV AH,2
    			INT 10H
				MOV DX,OFFSET COVER
    			MOV AH,9
    			INT 21H
    			JMP CON
    EX:			MOV DH,13
    			MOV DL,42
    			MOV AH,2
    			INT 10H
				MOV DX,OFFSET EXIT
    			MOV AH,9
    			INT 21H
    			MOV DH,13
    			MOV DL,28
    			MOV AH,2
    			INT 10H
    			MOV DX,OFFSET COVER
    			MOV AH,9
    			INT 21H
   CON:			MOV AH,7
    			INT 21H
    			CMP AL,13
    			JZ QUIT
    			CMP AL,4BH
    			JZ CON_SET
    			CMP AL,4DH
    			JZ EXIT_SET
    			JMP WAITF
    CON_SET:
    			MOV AL,CHOOSE
    			MOV AL,1
    			MOV CHOOSE,AL
    			JMP WAITF
    EXIT_SET:
                MOV AL,CHOOSE
                MOV AL,0
                MOV CHOOSE,AL
                JMP WAITF
	QUIT:		
				MOV AL,CHOOSE
				CMP AL,0
				JNE  BACK
	            CALL CLEAR_SCREEN			
				MOV AH,4CH
				INT 21H
	BACK:		
				CALL SRT
	REV: 	
		MOV BL,REVERSE
		CMP BL,0
		JZ R1
		MOV BL,0
		MOV REVERSE,BL
		JMP CRASH_END 
	R1:	MOV BL,1
		MOV REVERSE,BL		
		JMP CRASH_END		
	SU:
		 MOV BL,1
		 MOV SPEED_UP,BL
		 JMP CRASH_END
    SD:
         MOV BL,1
         MOV SLOW_DOWN,BL
         JMP CRASH_END
    LIFE:
    	 INC BL
    	 MOV [DI],BL
    	 POP DI
    	 JMP CRASH_END			
	ADD_LIFE:
		 PUSH DI
		 LEA DI,CAR
		 MOV BL,[DI]
		 CMP BL,5
		 JB LIFE
		 POP DI
		 JMP CRASH_END 
	TRANS:
	     MOV AL,1
	     MOV PORTAL,AL
	     JMP CRASH_END			
	CRASH_END:
				POP DI
				POP DX				;出原值
				POP CX
				POP BX
				POP AX
	RET	
CRASH ENDP
;----------------------------------------------------------			
ERASE PROC NEAR
	MOV CX,CHAR_CNT			;字符个数
	MOV DI,POINTER			;重拾字符R地址
	MOV DH,LINE_ON			;重拾车起始位置基准
	MOV DL,COL_ON
	
	ERASE_NEXT:
		ADD DH,[DI+2]		;加上相对位置
		ADD DL,[DI+3]
		MOV AH,2
		INT 10H				;设置光标			；；；；擦除；；；；
		
		MOV AL,[DI]
		MOV BL,0
		PUSH CX
		MOV CX,1
		MOV AH,9
		INT 10H
		POP CX
		ADD DI,4
	LOOP ERASE_NEXT
		
		MOV AH,1
		INT 16H
		
		CMP AH,48H
		JZ UP
		
		CMP AH,50H
		JZ DOWN
		
		CMP AH,4BH
		JZ LEFT
		
		CMP AH,4DH
		JZ RIGHT
		
			
		JMP ERASE_END
		
		UP:	
			SUB LINE_ON,2
			JMP ERASE_END
			
		DOWN:
			ADD LINE_ON,2
			JMP ERASE_END
			
		LEFT:
			MOV BL,REVERSE
			CMP BL,1
			JZ R
			L:
			MOV BL,SLOW_DOWN
			MOV AL,SPEED_UP
			SUB AL,BL
			ADD AL,4
			SUB COL_ON,AL
			JMP ERASE_END
			
		RIGHT:
		    MOV BL,REVERSE
		    CMP BL,1
		    JZ L
			R:
			MOV BL,SLOW_DOWN
			MOV AL,SPEED_UP
			SUB AL,BL
			ADD AL,4
			ADD COL_ON,AL
			JMP ERASE_END
		
	ERASE_END:
			MOV AH,0CH
			MOV AL,0BH
			INT 21H
	
	    LEA DI,WALL
	    SUB CH,CH
	    MOV CL,[DI]
	    INC DI
CHECK_WIN:
		MOV AL,[DI+4]
		CMP AL,1
		JZ CONTINUE
		ADD DI,6
		LOOP CHECK_WIN
		JMP FAR PTR WIN 	    
CONTINUE:LEA DI,CAR
		SUB CH,CH
		MOV CL,[DI]

ERASE_LIFE:
            LEA DI,LIVES
            MOV DH,[DI+2]
            MOV DL,[DI+3]          
LIFE_LOOP:
			MOV AH,2
			INT 10H
			MOV AL,[DI]
			MOV BL,0
			PUSH CX
			MOV CX,1
			MOV AH,9
			INT 10H
			POP CX
			INC DH
			LOOP LIFE_LOOP		
	    
	    LEA DI,CAR
		SUB CH,CH
		MOV CL,[DI]			
		MOV CHAR_CNT,CX
		MOV DI,POINTER
		CMP PORTAL,1
		JZ  PORT
PE:		MOV DH,LINE_ON
		MOV DL,COL_ON
		
RET
WIN:
		CALL CLEAR_SCREEN
		MOV DH,12
		MOV DL,30
		MOV AH,2
		INT 10H
		MOV DX,OFFSET CLEAR
		MOV AH,9
		INT 21H
		MOV AH,4CH
		INT 21H	
PORT:
        MOV AL,COL_ON
        ADD AL,2
        MOV COL_ON,AL
        CMP AL,40
        JNB P1
        SUB AL,40
        NEG AL
        ADD COL_ON,AL
        ADD COL_ON,AL
        MOV AL,2
        SUB COL_ON,AL
        MOV AL,0
        MOV PORTAL,AL
        JMP PE
P1:     		
		SUB AL,40
	    SUB COL_ON,AL
	    SUB COL_ON,AL
	    MOV AL,2
	    SUB COL_ON,AL
	    MOV AL,0
	    MOV PORTAL,AL
	    JMP PE
ERASE ENDP
;-----------------------------------------------------------
ERASE1 PROC NEAR
	MOV CX,CHAR_CNT1		;字符个数
	MOV DI,POINTER1			;重拾字符R地址
	MOV DH,LINE_ON1			;重拾车起始位置基准
	MOV DL,COL_ON1
	
	ERASE1_NEXT:
		ADD DH,[DI+2]		;加上相对位置
		ADD DL,[DI+3]
		MOV AH,2
		INT 10H				;设置光标			；；；；擦除；；；；
		
		MOV AL,[DI]
		MOV BL,0
		PUSH CX
		MOV CX,1
		MOV AH,9
		INT 10H
		POP CX
		ADD DI,6
	LOOP ERASE1_NEXT
		
		MOV CX,CHAR_CNT1
		MOV DI,POINTER1
		
		INC LINE_ON1
		MOV DH,LINE_ON1
		MOV DL,COL_ON1
		
RET

ERASE1 ENDP
;-----------------------------------------------------------
DLY_QRTR PROC NEAR
	PUSH CX
	PUSH DX
	MOV DX,100
	D11:
		MOV CX,2801
	D12:
		LOOP D12
		DEC DX
		JNZ D11
		POP DX
		POP CX
		
RET

DLY_QRTR ENDP

;----------------------------------------------------------
;--------------------------------------------------------------
CODES ENDS
    END MAIN



















