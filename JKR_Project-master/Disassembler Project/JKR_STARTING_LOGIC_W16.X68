*****************************************************************************
********************************<<START_LOGIC>>******************************
*****************************************************************************
*----------------------------------------------------------------------------
* STARTING LOGIC: Take in user inputs for START and END Addresses. It runs 
*                 various validations. If all checks pass, it will store the
*                 STARTING and ENDING addrs and goes to Decipher Logic.
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* INTRO Logic
*----------------------------------------------------------------------------
INTRO
    JSR     CLEAR_NEXT_LINE
    JSR		CLR_ALL                 Clear All data/addr reg for new session
	JSR		INITIALIZE_VARIABLES    Initialize all variables.
	MOVE.B	#0, PRINT_COUNTER       Set print counter var to 0.
	LEA		MSG_WELCOME, A1         Load and display welcome message
	MOVE.B  #14,D0                  |
    TRAP    #15                     V
*----------------------------------------------------------------------------
*   Prompt START_ADDR Logic
*----------------------------------------------------------------------------
START_ADDR_PROMPT
	LEA     STARTADDRESS_PROMPT,A1  Prompt for Start Address
	MOVE.B  #14,D0                  |
	TRAP	#15	                    V
	LEA		START_ADDRESS, A1       Store input value at start addr of program
	MOVE.B  #2,D0        	        Read string from keyboard and store at (A1)
    TRAP    #15        		        Length of string is stored into D1.L
    JSR		CHECK_LEN_S	            Check input length of addr (MAX 8 chars) 
    MOVE.L  #0,D3                   D3 is the counter variable, D1 is terminal
FOR_LOOP_START
    CMP.B   D3,D1                   CMP.B with counter and terminal values
    BEQ     STORE_STR_ADDRESS       IF all chars verified, then store start addr
    JSR		ASCII_TO_HEX_S          ELSE continue to check chars
    ADDQ.L  #1,D3                   Counter++; D3 is the counter variable
    BRA     FOR_LOOP_START          Loop back to start of loop
*   END: START_ADD_PROMPT Logic   
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   Prompt END_ADDR Logic
*----------------------------------------------------------------------------	
END_ADDR_PROMPT
    JSR     CLR_DATAREG             Clear data registers
    LEA     ENDADDRESS_PROMPT, A1   Prompt for End Address
	MOVE.B  #14,D0                  |
	TRAP	#15	                    V
	LEA		END_ADDRESS, A1         Store input value at end addr of program
	MOVE.B  #2,D0        	        Read string from keyboard and store at (A1)
    TRAP    #15        		        Length of string is stored into D1.L
   	MOVE.B	(A1),D2       	        We Move input byte value from A1 to D2
    JSR		CHECK_LEN_E	            Check input length of addr (MAX 8 chars) 
    MOVE.L  #0,D3                   D3 is the counter variable, D1 is terminal
FOR_LOOP_END
    CMP.B   D3,D1                   CMP.B with counter and terminal values
    BEQ     STORE_END_ADDRESS       IF all chars verified, then store end addr
    JSR		ASCII_TO_HEX_E          ELSE continue to check chars
    ADDQ.L  #1,D3                   Counter++; D3 is the counter variable
    BRA     FOR_LOOP_END            Loop back to start of loop
*   END: END_ADDR_PROMPT Logic       
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   STORE_ADDR Logic
*----------------------------------------------------------------------------      
STORE_STR_ADDRESS
    JSR     CHECK_ODD_ADDR          Check if addr is ODD to prevent crash  
    MOVEA.L D4, A5                  A5 holds STARTING ADDRESS
    JMP     END_ADDR_PROMPT         
STORE_END_ADDRESS              
    MOVEA.L D4, A6                  A6 holds ENDING ADDRESS
    JMP     CHECK_ADDRESS_VALUE
CHECK_ADDRESS_VALUE
    CMPA.L  A5, A6                  IF ENDING addr is GT STARTING addr
    BLE     DISPLAY_INVALID_ADDRESS Goto invalid addr logic
    JMP     DECIPHER                ELSE begin decoding
*   End:    STORE_ADDR Logic       
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DISPLAY_INVALID_ADDRESS Logic
*----------------------------------------------------------------------------
DISPLAY_INVALID_ADDRESS
    LEA     MSG_INVALID_ADDRESS, A1 Load and display invalid message
    MOVE.B  #14,D0                  |
    TRAP    #15                     |
    JSR     CLR_DATAREG             Clear data/addr registers
    MOVEA.L #0, A5                  |
    MOVEA.L #0, A6                  V
    JMP     START_ADDR_PROMPT       Branch to start of program
*   END:    DISPLAY_INVALID_ADDRESS Logic
*---------------------------------------------------------------------------- 
*----------------------------------------------------------------------------
*   ASCII_TO_HEX Logic
*----------------------------------------------------------------------------
ASCII_TO_HEX_S
    MOVE.B	(A1)+,D2       	        MOVE byte value from A1 to D2
    JSR     CHECK_NUM_S             Run through conversion logic
    LSL.L   #4,D4                   Left shift 4 bits, D4 holds converted value
    EOR.B   D2,D4                   Exclusive OR D2, into D4
    RTS 
ASCII_TO_HEX_E
    MOVE.B	(A1)+,D2       	        MOVE byte value from A1 to D2
    JSR     CHECK_NUM_E             Run through conversion logic
    LSL.L   #4,D4                   Left shift 4 bits, D4 holds converted value
    EOR.B   D2,D4                   Exclusive OR D2, into D4
    RTS
*   END:    ASCII_TO_HEX Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* VALIDATION LOGIC FOR STR/END ADDRESSES
*---------------------------------------------------------------------------- 
CHECK_NUM_S
    CMPI.B	#$30, D2		        IF LT $30 (ASCII value '0')
    BLT		INVALID_S			    Goto INVALID
    CMPI.B	#$39, D2		        ELSE CMPI to $39
  	BGT		CHECK_UCHAR_S		    IF GT $39, goto CHECK_UCHAR_START
    SUB.B	#$30, D2		        ELSE SUB $30 convert to Hex and store at D2
	RTS

CHECK_UCHAR_S
	CMPI.B	#$41, D2		        IF LT $41 (ASCII value 'A'),
	BLT		INVALID_S			    Goto INVALID_START
	CMPI.B	#$46, D2                ELSE CMPI to $46
	BGT		CHECK_LCHAR_S		    IF GT $46 (ASCII value 'F'), goto CHECK_LCHAR_START
	SUB.B	#$37, D2                ELSE SUB $37 to convert to upper case at D2
	RTS                             
	
CHECK_LCHAR_S
	CMPI.B	#$61, D2		        IF LT $61 (ASCII value 'a')
	BLT		INVALID_S			    Goto INVALID_START
	CMPI.B	#$66, D2                ELSE CMPI to $66, goto CHECK_UCHAR_START
	BGT		INVALID_S			    IF GT $66 (ASCII value 'f') go to INVALID
	SUB.B	#$57, D2                ELSE SUB $57 to convert to lower case at D2
	RTS
	
CHECK_NUM_E
    CMPI.B	#$30, D2		        IF LT $30 (ASCII value '0')
    BLT		INVALID_E			    Goto INVALID
    CMPI.B	#$39, D2		        ELSE CMPI to $39
  	BGT		CHECK_UCHAR_E		    IF GT $39, goto CHECK_UCHAR_END
    SUB.B	#$30, D2		        ELSE SUB $30 convert to Hex and store at D2
	RTS

CHECK_UCHAR_E
	CMPI.B	#$41, D2		        IF LT $41 (ASCII value 'A'),
	BLT		INVALID_E			    Goto INVALID_END
	CMPI.B	#$46, D2                ELSE CMPI to $46
	BGT		CHECK_LCHAR_E		    IF GT $46 (ASCII value 'F'), goto CHECK_LCHAR_END
	SUB.B	#$37, D2                ELSE SUB $37 to convert to upper case at D2
	RTS  
	
CHECK_LCHAR_E
	CMPI.B	#$61, D2		        IF LT $61 (ASCII value 'a')
	BLT		INVALID_E			    Goto INVALID_START
	CMPI.B	#$66, D2                ELSE CMPI to $66, goto CHECK_UCHAR_END
	BGT		INVALID_E			    IF GT $66 (ASCII value 'f') go to INVALID
	SUB.B	#$57, D2                ELSE SUB $57 to convert to lower case at D2
	RTS

INVALID_ODD_ADDR
    LEA 	MSG_INVALID_ODDADDR, A1 Load and display invalid odd addr message
    MOVE.B 	#14, D0                 |
    TRAP 	#15                     |
    JSR     CLR_DATAREG             V
    JMP     START_ADDR_PROMPT       Return to START_ADDR_PROMPT
	
INVALID_LEN_S
    LEA 	MSG_INVALID_LENGTH, A1  Load and display invalid length message
    MOVE.B 	#13, D0                 |
    TRAP 	#15                     |
    JSR     CLR_DATAREG             V
    JMP     START_ADDR_PROMPT       Return to START_ADDR_PROMPT

INVALID_S
    LEA 	MSG_INVALID_ENTRY, A1   Load and display invalid length message
    MOVE.B 	#13, D0                 |
    TRAP 	#15                     |
    JSR     CLR_DATAREG             V
    JMP     START_ADDR_PROMPT       Return to START_ADDR_PROMPT    
    
INVALID_LEN_E
    LEA 	MSG_INVALID_LENGTH, A1  Load and display invalid length message
    MOVE.B 	#13, D0                 |
    TRAP 	#15                     |
    JSR     CLR_DATAREG             V
    BRA     END_ADDR_PROMPT         Return to END_ADDR_PROMPT

INVALID_E
    LEA 	MSG_INVALID_ENTRY, A1   Load and display invalid length message
    MOVE.B 	#13, D0                 |
    TRAP 	#15                     |
    JSR     CLR_DATAREG             V
    JMP     END_ADDR_PROMPT         Return to END_ADDR_PROMPT  

CHECK_LEN_S	
	CMP.B	#$8, D1			        IF string length is GT 8
	BGT		INVALID_LEN_S		    Goto INVALID_LEN_START
	CMP.B	#$0, D1                 ELSE CMP length of string with 0
	BLE		INVALID_LEN_S		    IF string length is LT 0, Goto INVALID_LEN_S
	RTS
	
CHECK_LEN_E	
	CMP.B	#$8, D1			        IF string length is GT 8
	BGT		INVALID_LEN_E		    Goto INVALID_LEN_END
	CMP.B	#$0, D1                 ELSE CMP length of string with 0
	BLE		INVALID_LEN_E		    IF string length is LT 0, Goto INVALID_LEN_E
	RTS
	
CLR_DATAREG                         *Subroutine to clear data registers
    CLR.L   D0                      |
    CLR.L   D1                      |
    CLR.L   D2                      |
    CLR.L   D3                      |
    CLR.L   D4                      V
    RTS                             RTS
*   END:    INTRO Logic
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*   CHECK_ODD_ADDR: Since program is word addressible, it will crash on odd
*                   Check if last bit is 1, if so invalid entry.
*-----------------------------------------------------------------------------
CHECK_ODD_ADDR
    MOVE.B  D4, D3                  Get a byte value from the addr
    LSR.B   #1, D3                  Right shift 1 bit to force carry bit flag
    BCS     INVALID_ODD_ADDR        IF carry bit is 1, it is odd
    RTS
*   END     CHECK_ODD_ADDR Logic
*-----------------------------------------------------------------------------

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
