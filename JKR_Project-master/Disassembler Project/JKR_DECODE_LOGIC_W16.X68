*****************************************************************************
********************************<<DECODE SUBROUTINES>>***********************
*****************************************************************************
*----------------------------------------------------------------------------
* DECODE LOGIC: Decode logic that decodes each opcodes.
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_NOP Logic
*----------------------------------------------------------------------------
DECODE_NOP
	LEA 	DISPLAY_NOP, A1
	MOVE.B 	#13, D0
	TRAP 	#15
	JMP 	PRINT_LOGIC
*   END:    DECODE_NOP Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_STOP Logic
*----------------------------------------------------------------------------
DECODE_STOP
	LEA 	DISPLAY_STOP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_STOP
	JMP     CHECK_DECODE_RHS
	JMP 	PRINT_LOGIC
*   END:    DECODE_STOP Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_JSR Logic
*----------------------------------------------------------------------------
DECODE_JSR
	LEA 	DISPLAY_JSR, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR 	GET_EAMODE_BITS
	CMP.B	#2,D2
	BEQ		DECODE_ADDRP_REG_ONE_OPERAND
	CMP.B	#7,D2
	BEQ		DECODE_EA_REG_ONE_OPERAND
	JMP 	PRINT_LOGIC
*   END:    DECODE_JSR Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_LEA Logic
*----------------------------------------------------------------------------
DECODE_LEA
	LEA 	DISPLAY_LEA, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_LEA
	JSR 	GET_EAMODE_BITS
	CMP.B	#2,D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#7,D2
	BEQ		DECODE_EA_REG_LHS
	JMP 	PRINT_LOGIC
*   END:    DECODE_LEA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_RTS Logic
*----------------------------------------------------------------------------
DECODE_RTS
	LEA 	DISPLAY_RTS, A1
	MOVE.B 	#13, D0
	TRAP 	#15
	JMP 	PRINT_LOGIC
*   END: 	DECODE_RTS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_CLR Logic
*----------------------------------------------------------------------------
DECODE_CLRB
	LEA 	DISPLAY_CLRB, A1
	BRA		DECODE_CLR_DISPLAY
	
DECODE_CLRW
	LEA 	DISPLAY_CLRW, A1
	BRA		DECODE_CLR_DISPLAY
	
DECODE_CLRL
	LEA 	DISPLAY_CLRL, A1

DECODE_CLR_DISPLAY
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR 	GET_EAMODE_BITS
	CMP.B	#0,D2
	BEQ		DECODE_DATA_REG_ONE_OPERAND
	CMP.B	#2,D2
	BEQ		DECODE_ADDRP_REG_ONE_OPERAND
	CMP.B	#3,D2
	BEQ		DECODE_ADDRPLUS_REG_ONE_OPERAND
	CMP.B	#4,D2
	BEQ		DECODE_MINUSADDR_REG_ONE_OPERAND
	CMP.B	#7,D2
	BEQ		DECODE_EA_REG_ONE_OPERAND
	JMP 	PRINT_LOGIC
*   END: 	DECODE_CLR Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_CMPB Logic
*----------------------------------------------------------------------------
DECODE_CMPB
	LEA 	DISPLAY_CMPB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_CMP          Flag set to true for when decoding RHS
	
	JSR 	GET_EAMODE_BITS
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_LHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_LHS
	JMP		PRINT_LOGIC
*   END: 	DECODE_CMPB Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_CMP_W / L Logic
*----------------------------------------------------------------------------
DECODE_CMPW
	LEA 	DISPLAY_CMPW, A1
	BRA		DECODE_CMP_W_L_DISPLAY
	
DECODE_CMPL
	LEA 	DISPLAY_CMPL, A1
	MOVE.B	#1, IS_LONG         Flag set to true for when decoding IMDATA_L
	
DECODE_CMP_W_L_DISPLAY
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_CMP          Flag set to true for when decoding RHS
	JSR 	GET_EAMODE_BITS
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B	#1, D2
	BEQ		DECODE_ADDR_REG_LHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_LHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_CMP_W / L Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MOVEMW/MOVEML Logic			*MOVEM.W/MOVE.L
*----------------------------------------------------------------------------
DECODE_MOVEMW
	MOVE.B  #1, IS_MOVEM   
	LEA 	DISPLAY_MOVEMW, A1
	BRA		MOVEM_DIRECTION

DECODE_MOVEML
	MOVE.B  #1, IS_MOVEM   
	LEA 	DISPLAY_MOVEML, A1

MOVEM_DIRECTION
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		GET_MOVEM_DR_BITS		Get MOVEM direction Bits
	CMP.W	#3, D2					IF match with 0011 bits, then Memory to Register 
	BEQ		DECODE_MOVEM_MEM_TO_REG	Decode MOVEM.M/L with Mem to Reg

DECODE_MOVEM_REG_TO_MEM
	MOVE.B	#0, IS_MEM_TO_REG		DIRECTION FLAG = 0, Register to Memory
	JSR		GET_EAMODE_BITS			*Special <EA> check for -(An) before printing <LIST>
	CMP.B	#4, D2
	BNE		JUMP_FLAG_MINUSADDR
	MOVE.B	#1, IS_MINUSADDR		*FLAG to indicate -(An) when bit 3 to 5 for EA_Mode is %0100(#4)
	CLR		D2
	
JUMP_FLAG_MINUSADDR	
	JMP 	DECODE_MOVEM_REGISTERS_LHS

DECODE_MOVEM_EA_REG_RHS				*MOVEM	<LIST>,<EA>		*<EA> part	
	JSR		PRINT_COMMA
	JSR		GET_EAMODE_BITS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_ONE_OPERAND	
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_MOVEM_EA_REG			
	JMP		PRINT_LOGIC
	
DECODE_MOVEM_MEM_TO_REG				*MOVEM	<EA>,<LIST>		*<EA> part
	MOVE.B	#1, IS_MEM_TO_REG		DIRECTION FLAG = 1, Memory to Register										
	JSR		GET_EAMODE_BITS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS	
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS	
	CMP.B	#7, D2
	BEQ		DECODE_MOVEM_EA_REG
	JMP 	PRINT_LOGIC		

DECODE_MOVEM_EA_REG					*Both MOVEM		*<EA> part
	MOVE.B	#1, IS_MOVEM_EA_REG
	JSR		GET_EAREG_BITS
	CMP.B	#0, D2		        	(xxxx).W
	BEQ		DECODE_MOVEM_EA_WORD_LHS
	CMP.B	#1,	D2		        	(xxxx).L
	BEQ		DECODE_MOVEM_EA_LONG_LHS

DECODE_MOVEM_REGISTERS_LHS			*MOVEM	<LIST>,<EA>		*<LIST> part	
DECODE_MOVEM_REGISTERS_RHS			*MOVEM	<EA>,<LIST>		*<LIST> part
	CLR.L	D3
	CLR.L	D4
	CLR.L	D5
	MOVE.W	(A5)+,D3				VALUE
	MOVE.B	#0,D4					COUNTER 0 to 15
	MOVE.B	#0,D5					Indicate first hit of 1 bit
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP
	
MOVEM_REGISTER_LHS_LOOP				*MOVEM	<LIST>,<EA>		*<LIST> part	
	CMP.W	#0,D3				    EXIT CONDITION
	BEQ		DECODE_MOVEM_EA_REG_RHS Move to <EA>
	BTST	#0,D3
	BNE		CHECK_SLASH_CONDITION_REG_TO_MEM	IF there is something in D3, print slash
	CMP.B	#1,IS_MINUSADDR
	BEQ		JUMP_SLASH_SPECIAL_CASE
	JMP		JUMP_SLASH_REG_TO_MEM
	
CHECK_SLASH_CONDITION_REG_TO_MEM
	ADD.B	#1,D5					Add count to indicate if it hits any Dn or An
	CMP.B	#1,D5					
	BLE		JUMP_SLASH_REG_TO_MEM	If there is only one Dn or An, then skip "/"
	JSR		PRINT_SLASH
	CMP.B	#1,IS_MINUSADDR
	BEQ		AFTER_SLASH_SPECIAL_CASE
	
JUMP_SLASH_REG_TO_MEM
	ADDI.B	#1,D4					Add count to hit until 16
	LSR.W	#1,D3
	BCS		DISPLAY_MOVEM_REGISTER
	JMP		MOVEM_REGISTER_LHS_LOOP		
	
JUMP_SLASH_SPECIAL_CASE				*ONLY Case to print out Dn/An mask reversed order						
	LSL.W	#1,D3
	ADDI.B	#1,D4
	ROL.W	#1,D3
	BCS		CHECK_SLASH_CONDITION_REG_TO_MEM
AFTER_SLASH_SPECIAL_CASE
	LSR.W	#1,D3	
	BCS		DISPLAY_MOVEM_REGISTER
	JMP		MOVEM_REGISTER_LHS_LOOP
	
MOVEM_REGISTER_RHS_LOOP				*MOVEM	<EA>,<LIST>		*<LIST> part
	CMP.W	#0,D3				    EXIT CONDITION
	BEQ		ONE_STEP_BEFORE_PRINT_LOGIC
	BTST	#0,D3
	BNE		CHECK_SLASH_CONDITION	IF there is something in D3, print slash
	JMP		JUMP_SLASH
	
CHECK_SLASH_CONDITION
	ADD.B	#1,D5					Add count to indicate if it hits any Dn or An
	CMP.B	#1,D5					
	BLE		JUMP_SLASH				If there is only one Dn or An, then skip "/"
	JSR		PRINT_SLASH
	
JUMP_SLASH
	ADDI.B	#1,D4					Add count to hit until 16
	LSR.W	#1,D3	
	BCS		DISPLAY_MOVEM_REGISTER
	JMP		MOVEM_REGISTER_RHS_LOOP

DISPLAY_MOVEM_REGISTER				*<EA> on both case
	CMP.W	#1,D4
	BEQ		PRINT_MOVEM_RHS_D0
	CMP.W	#2,D4
	BEQ		PRINT_MOVEM_RHS_D1
	CMP.W	#3,D4
	BEQ		PRINT_MOVEM_RHS_D2
	CMP.W	#4,D4
	BEQ		PRINT_MOVEM_RHS_D3
	CMP.W	#5,D4
	BEQ		PRINT_MOVEM_RHS_D4
	CMP.W	#6,D4
	BEQ		PRINT_MOVEM_RHS_D5
	CMP.W	#7,D4
	BEQ		PRINT_MOVEM_RHS_D6
	CMP.W	#8,D4
	BEQ		PRINT_MOVEM_RHS_D7
	CMP.W	#9,D4
	BEQ		PRINT_MOVEM_RHS_A0
	CMP.W	#10,D4
	BEQ		PRINT_MOVEM_RHS_A1
	CMP.W	#11,D4
	BEQ		PRINT_MOVEM_RHS_A2
	CMP.W	#12,D4
	BEQ		PRINT_MOVEM_RHS_A3
	CMP.W	#13,D4
	BEQ		PRINT_MOVEM_RHS_A4	
	CMP.W	#14,D4
	BEQ		PRINT_MOVEM_RHS_A5
	CMP.W	#15,D4
	BEQ		PRINT_MOVEM_RHS_A6
	CMP.W	#16,D4
	BEQ		PRINT_MOVEM_RHS_A7
	JMP		PRINT_LOGIC
	
ONE_STEP_BEFORE_PRINT_LOGIC			*ONLY used in MOVEM <EA>,<LIST>
	CMP.B	#1,  IS_MOVEM_EA_REG
	BNE		SKIP_TO_PRINT_LOGIC		If MOVEM EA REGISTER MODE,
	MOVE.W  (A5)+,D6				ADD 1 address forward in oderd to place correct address.
	CMP.B	#1,	IS_LONG				Word/long address?
	BNE		SKIP_TO_PRINT_LOGIC		If long address, then add one more move.w
	MOVE.W  (A5)+,D6
SKIP_TO_PRINT_LOGIC
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC 
*   END: 	DECODE_MOVEMW/MOVEML Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*DECODE_MOVEM_EA_WORD_LHS
*----------------------------------------------------------------------------
DECODE_MOVEM_EA_WORD_LHS
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.W  (A5)+,D6            Put current addr into D6, to hold addr value
	CMP.B	#1,IS_MEM_TO_REG	If MOVEM <EA>,<LIST>
    BNE		DONT_ADD_ADDRESS_W 	Add one address forward
	MOVE.W  (A5)+,D6            MOVEM structure need one more adding of address
	
DONT_ADD_ADDRESS_W
	MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.W  #$F000, D1      	Move the masking value to D1
    
EA_MOVEM_WORD_LOOP_LHS
    MOVE.W  D6, D5              D5 will hold addr for manipulation
    AND.W   D1, D5              Mask D5 with mask value
    LSR.W   #4, D1              Update the mask to next digit, by shifting 4
    ROL.W   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.W  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #4, D2              IF counter equals terminal value
    BEQ     EXIT_EA_MOVEM_WORD_LOOP_LHS 	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_MOVEM_WORD_LOOP_LHS    Loop to start of loop
    
EXIT_EA_MOVEM_WORD_LOOP_LHS
	CMP.B	#1,	IS_MEM_TO_REG
	BNE		DONT_MINUS_ADDRESS_W	If MOVEM <EA>,<LIST>
	MOVE.W	-(A5),D6 				Subtract 2 addresses backword,
	MOVE.W	-(A5),D6 				in oderd to place correct address.
   
DONT_MINUS_ADDRESS_W
	CMP.B	#0, IS_MEM_TO_REG	Case of MOVEM.W <LIST>,<EA> need to exit
	BEQ		SKIP_TO_PRINT_LOGIC
	JSR		PRINT_COMMA
	JMP		DECODE_MOVEM_REGISTERS_RHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_MOVEM_EA_WORD_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MOVEM_EA_LONG_LHS Logic
*----------------------------------------------------------------------------
DECODE_MOVEM_EA_LONG_LHS
	MOVE.B	#1, IS_LONG			Flag long address	
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    CMP.B	#1, IS_MEM_TO_REG	If MOVEM <EA>,<LIST>
    BEQ		STEP_FOR_MEM_TO_REG
    MOVE.L	(A5)+, D6
    JMP		DONT_ADD_ADDRESS_L
    
STEP_FOR_MEM_TO_REG
    MOVE.W  (A5)+,D6            Move up word value in memory
	MOVE.L  (A5)+,D6            Grab EA long value
	
DONT_ADD_ADDRESS_L
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.L  #$F0000000, D1      Move the masking value to D1
    
EA_MOVEM_LONG_LOOP_LHS
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L	D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2              IF counter equals terminal value
    BEQ     EXIT_EA_MOVEM_LONG_LOOP_LHS  	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_MOVEM_LONG_LOOP_LHS	Loop to start of loop
	
EXIT_EA_MOVEM_LONG_LOOP_LHS
	CMP.B	#1,  IS_MEM_TO_REG
	BNE		DONT_MINUS_ADDRESS_L	If MOVEM EA REGISTER MODE,
	MOVE.L	-(A5),D6 				ADD 2 addresses backword,
	MOVE.W	-(A5),D6 				in oderd to place correct address.   
	
DONT_MINUS_ADDRESS_L
	CMP.B	#0, IS_MEM_TO_REG		Case of MOVEM.W <LIST>,<EA> need to exit
	BEQ		SKIP_TO_PRINT_LOGIC		Exit for MOVEM.W <LIST>,<EA>
	JSR		PRINT_COMMA
	JMP		DECODE_MOVEM_REGISTERS_RHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_MOVEM_EA_LONG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MOVE Logic               Handles MOVE.B/W/L
*----------------------------------------------------------------------------
DECODE_MOVEB
	LEA 	DISPLAY_MOVEB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	BRA     DECODE_MOVE_DISPLAY

DECODE_MOVEW
	LEA 	DISPLAY_MOVEW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	BRA     DECODE_MOVE_DISPLAY
	
DECODE_MOVEL
	LEA 	DISPLAY_MOVEL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_LONG         Flag set to true for when decoding IMDATA_L

DECODE_MOVE_DISPLAY
	MOVE.B	#1, IS_MOVE         Flag set to true for when decoding RHS
	JSR 	GET_EAMODE_BITS     
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B	#1, D2
	BEQ		DECODE_ADDR_REG_LHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_LHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_MOVE Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MOVEQ Logic			*MOVEQ
*----------------------------------------------------------------------------
DECODE_MOVEQ
	MOVE.B  #1, IS_MOVEQ    
	LEA 	DISPLAY_MOVEQL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
    JSR     PRINT_IMDATA
	JSR		GET_DATA_8BITS
	JMP     SET_MOVEQ_IMDATA
*   END: 	DECODE_MOVEQ Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ROTATIONS_MS Logic			
*----------------------------------------------------------------------------
DECODE_ROTATIONS_MS
	JSR		GET_REGISTER_BITS  		Get 9th - 11th bit, find out AS(L/R), LS(L/R), or RO(L/R)
	CMP.B	#0,D2
	BEQ		DECODE_AS_MS
	JSR		GET_REGISTER_BITS
	CMP.B	#1,D2
	BEQ		DECODE_LS_MS
	JSR		GET_REGISTER_BITS
	CMP.B	#3,D2
	BEQ		DECODE_RO_MS
	BRA		INVALID_ROTATIONS_MS

DECODE_AS_MS
	LEA 	DISPLAY_AS, A1
	BRA 	SHIFT_DIRECTION_MS
	
DECODE_LS_MS
	LEA 	DISPLAY_LS, A1
	BRA 	SHIFT_DIRECTION_MS
	
DECODE_RO_MS
	LEA 	DISPLAY_RO, A1

SHIFT_DIRECTION_MS
	MOVE.B 	#14, D0
	TRAP 	#15

	JSR		GET_SHIFT_DIRECTION_BITS
	CMP.B	#0,D2
	BEQ		PRINT_SHIFT_EA
	LEA 	DISPLAY_L,A1
	BRA		GO_TO_EA
	
PRINT_SHIFT_EA
	LEA 	DISPLAY_R,A1

GO_TO_EA
	MOVE.B 	#14, D0
	TRAP 	#15	
	LEA		DISPLAY_SPACE,A1
	MOVE.B 	#14, D0
	TRAP 	#15
	 
	JSR 	GET_EAMODE_BITS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_ONE_OPERAND
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_ONE_OPERAND
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_ONE_OPERAND
	JMP 	PRINT_LOGIC	

*   END: 	DECODE_ROTATIONS_MS
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ROTATIONS_RS Logic			
*----------------------------------------------------------------------------
DECODE_ROTATIONS_BYTE_RS
	MOVE.B	#1,IS_BYTE
	BRA		DECODE_SHIFT_RS_BITS
	
DECODE_ROTATIONS_WORD_RS
	MOVE.B	#1, IS_WORD
	BRA		DECODE_SHIFT_RS_BITS	

DECODE_ROTATIONS_LONG_RS
	MOVE.B	#1, IS_LONG	

DECODE_SHIFT_RS_BITS
	JSR		GET_SHIFT_RS_BITS
	CMP.B	#0,D2				ASL/R
	BEQ		DECODE_AS

	CMP.B	#1,D2				LSL/R
	BEQ		DECODE_LS

	CMP.B	#3,D2				ROL/R
	BEQ		DECODE_RO
	BRA		INVALID_OP

DECODE_AS
	LEA 	DISPLAY_AS, A1
	BRA 	SHIFT_DIRECTION_BYTE
	
DECODE_LS
	LEA 	DISPLAY_LS, A1
	BRA 	SHIFT_DIRECTION_BYTE
	
DECODE_RO
	LEA 	DISPLAY_RO, A1
	
SHIFT_DIRECTION_BYTE
	MOVE.B 	#14, D0
	TRAP 	#15

	JSR		GET_SHIFT_DIRECTION_BITS
	CMP.B	#0,D2
	BEQ		PRINT_SHIFT_RIGHT_BYTE
	LEA 	DISPLAY_L,A1
	BRA		CHECK_SHIFT_SIZE_RS
	
PRINT_SHIFT_RIGHT_BYTE
	LEA 	DISPLAY_R,A1

CHECK_SHIFT_SIZE_RS
	MOVE.B 	#14, D0
	TRAP 	#15	
	
	CMP.B	#1,IS_BYTE
	BEQ		SHIFT_PRINT_DOT_B
	CMP.B	#1,IS_WORD
	BEQ		SHIFT_PRINT_DOT_W
	LEA		DISPLAY_DOT_L,A1
	
DECODE_IR
	MOVE.B 	#14, D0
	TRAP 	#15	
	BRA		GET_IR_BITS	
	
SHIFT_PRINT_DOT_B
	LEA 	DISPLAY_DOT_B,A1
	BRA		DECODE_IR
	
SHIFT_PRINT_DOT_W
	LEA		DISPLAY_DOT_W,A1
	BRA		DECODE_IR
*   END:	DECODE_ROTATIONS_RS
*----------------------------------------------------------------------------	
*----------------------------------------------------------------------------
*   DECODE_ROTATIONS_PRINT Logic			*Used in ASR/LSL/ROL
*----------------------------------------------------------------------------
DECODE_IMMEDIATE_NUM
	JSR 	PRINT_IMDATA
	MOVE.B	#1, IS_IMMEDIATE_DATA
	JMP		PRINT_CR_NUM
	
DECODE_REGISTER_NUM
	LEA 	DISPLAY_D, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JMP		PRINT_CR_NUM	
	
PRINT_CR_NUM
	JSR		GET_SHIFT_CR_NUM_BITS
	CMP.B	#1, IS_IMMEDIATE_DATA
	BEQ		REPRESENT_1_TO_8
	
	CMP.B	#0, D2			Case for Dn, An related
	BEQ		PRINT_0_LHS
	
REPRESENT_1_TO_8			*In Immedate data, 0 represent 8. 
	CMP.B	#1, D2
	BEQ		PRINT_1_LHS
	CMP.B	#2, D2
	BEQ		PRINT_2_LHS
	CMP.B	#3, D2
	BEQ		PRINT_3_LHS
	CMP.B	#4, D2
	BEQ		PRINT_4_LHS
	CMP.B	#5, D2
	BEQ		PRINT_5_LHS
	CMP.B	#6, D2
	BEQ		PRINT_6_LHS
	CMP.B	#7, D2
	BEQ		PRINT_7_LHS
	CMP.B	#0, D2
	BEQ		PRINT_8_LHS
	JMP		PRINT_LOGIC
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MULS/DIVU Logic			*MULS/DIVU
*----------------------------------------------------------------------------
DECODE_MULS 
	LEA 	DISPLAY_MULS, A1
	MOVE.B  #1, IS_MULS
	BRA     DECODE_MULS_DIVU_DISPLAY
	
DECODE_DIVU 
	LEA 	DISPLAY_DIVU, A1
	MOVE.B  #1, IS_DIVU

DECODE_MULS_DIVU_DISPLAY
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR 	GET_EAMODE_BITS
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_LHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_MULS/DIVU Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_BCC_BGT_BLE Logic
*----------------------------------------------------------------------------
DECODE_BCC
	LEA 	DISPLAY_BCC, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	BRA     DECODE_Bcc_DISPLAY
	
DECODE_BGT
	LEA 	DISPLAY_BGT, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	BRA     DECODE_Bcc_DISPLAY
	
DECODE_BLE
	LEA 	DISPLAY_BLE, A1
	MOVE.B 	#14, D0
	TRAP 	#15

DECODE_Bcc_DISPLAY
	JMP     DECODE_DISPLACEMENT
	JMP 	PRINT_LOGIC
*   END:    DECODE_BCC_BGT_BLE Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_DISPLACEMENT         *Used in BCC/BGT/BLE
*----------------------------------------------------------------------------
DECODE_DISPLACEMENT
    CLR.L   D6                  Clear D6
	MOVE.B  D7, D6              Move opword BYTE value into D6 for calculation
	CMP.B   #0, D6              Compare if it is word displacement as in '00'
	BEQ     WORD_DISPLACEMENT   IF not word, fall through to '01' to 'FE' logic
	
    MOVE.W  A5, D5              Move addr value into D5 for calculation
	ADD.B   D6, D5              Add the BYTE displacement value. 
                                *NOTE: JMP TBL already auto increments add by 2
    MOVE.W  D5, D7              Store displacement address in D7
    JSR     PRINT_DISP_ADDR     JSR to print displacement address logic
    JSR     CLEAR_NEXT_LINE
    JMP     PRINT_LOGIC
    
WORD_DISPLACEMENT    
    MOVE.W  (A5),D5             Move DISPLACEMENT value into D5 for calculation  
    MOVE.W  A5, D4              Move the current addr into D4 for calculation
    ADD.W   D4, D5              Add the current Addr with DISPLACEMENT value
    MOVE.W  D5, D7              Store displacement address in D7
    ADDA.W  #2, A5              Increment the current addr reg by 2(word value)
    JSR     PRINT_DISP_ADDR     JSR to print displacement address logic
    JSR     CLEAR_NEXT_LINE
    JMP     PRINT_LOGIC
*   END:    DECODE_DISPLACEMENT Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDB_EATODN Logic
*----------------------------------------------------------------------------
DECODE_ADDB_EATODN
	LEA 	DISPLAY_ADDB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ADDB         Flag set to true for when decoding RHS
	MOVE.B  #1, IS_EATODN
	
	JSR 	GET_EAMODE_BITS     
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_LHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_ADDB_EATODN Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADD_W_L_EATODN Logic
*----------------------------------------------------------------------------
DECODE_ADDW_EATODN
	LEA 	DISPLAY_ADDW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ADDW        ADD.W flag set to true for when decoding RHS
	MOVE.B  #1, IS_EATODN      EA->DN flag set to true for when decoding RHS
	BRA		DECODE_ADDWL_DISP
	
DECODE_ADDL_EATODN
	LEA 	DISPLAY_ADDL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
    MOVE.B	#1, IS_ADDL        ADD.L flag set to true for when decoding RHS
	MOVE.B	#1, IS_LONG        Flag set to true for when decoding IMDATA_L
	MOVE.B  #1, IS_EATODN      EA->DN flag set to true for when decoding RHS
	
DECODE_ADDWL_DISP
	JSR 	GET_EAMODE_BITS     
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B	#1, D2
	BEQ		DECODE_ADDR_REG_LHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_LHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_LHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_LHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_ADD_W_L_EATODN Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDB_DNTOEA Logic
*----------------------------------------------------------------------------
DECODE_ADDB_DNTOEA
	LEA 	DISPLAY_ADDB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ADDB         Flag set to true for when decoding RHS
	BRA     ADD_DNTOEA_DISP
	
DECODE_ADDW_DNTOEA
	LEA 	DISPLAY_ADDW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ADDW         Flag set to true for when decoding RHS
	BRA     ADD_DNTOEA_DISP	
	
DECODE_ADDL_DNTOEA
	LEA 	DISPLAY_ADDL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
    MOVE.B	#1, IS_ADDL         Flag set to true for when decoding RHS
	MOVE.B	#1, IS_LONG         Flag set to true for when decoding IMDATA_L	

ADD_DNTOEA_DISP		
	MOVE.B  #1, IS_DNTOEA
	JMP		DECODE_ADD_DATA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_ADDB_DNTOEA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDI Logic *B/W/L
*----------------------------------------------------------------------------
DECODE_ADDIB
	LEA 	DISPLAY_ADDIB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_WORD
	BRA     ADDI_DISP	
	
DECODE_ADDIW
	LEA 	DISPLAY_ADDIW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_WORD         Flag set to true for when decoding IMDATA_W
	BRA     ADDI_DISP	
	
DECODE_ADDIL
	LEA 	DISPLAY_ADDIL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_LONG         Flag set to true for when decoding IMDATA_L
	
ADDI_DISP	
	MOVE.B	#1, IS_ADDI         Flag set to true for when decoding RHS
	JMP		DECODE_IMDATA_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_ADDI Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDA Logic	*W/L
*----------------------------------------------------------------------------
DECODE_ADDAW
	LEA 	DISPLAY_ADDAW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	BRA     DECODE_ADDA
	
DECODE_ADDAL
	LEA 	DISPLAY_ADDAL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_LONG

DECODE_ADDA	
    MOVE.B  #1, IS_ADDA
	JSR     GET_EAMODE_BITS
	CMP.B   #0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B   #1, D2
	BEQ     DECODE_ADDR_REG_LHS
	CMP.B   #2, D2
	BEQ     DECODE_ADDRP_REG_LHS
	CMP.B   #3, D2
	BEQ     DECODE_ADDRPLUS_REG_LHS
	CMP.B   #4, D2
	BEQ     DECODE_MINUSADDR_REG_LHS
	CMP.B   #7, D2
	BEQ     DECODE_EA_REG_LHS   
	JMP 	PRINT_LOGIC
*   END: 	DECODE_ADDA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_AND_EATODN Logic
*----------------------------------------------------------------------------
DECODE_ANDB_EATODN
	LEA 	DISPLAY_ANDB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_ANDB
	MOVE.B  #1, IS_WORD
	BRA     DECODE_AND_EATODN

DECODE_ANDW_EATODN
	LEA 	DISPLAY_ANDW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_ANDW
	MOVE.B  #1, IS_WORD
	BRA     DECODE_AND_EATODN

DECODE_ANDL_EATODN
	LEA 	DISPLAY_ANDL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_ANDL
	MOVE.B  #1, IS_LONG
	
DECODE_AND_EATODN	
    MOVE.B  #1, IS_EATODN
	JSR     GET_EAMODE_BITS
	CMP.B   #0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B   #2, D2
	BEQ     DECODE_ADDRP_REG_LHS
	CMP.B   #3, D2
	BEQ     DECODE_ADDRPLUS_REG_LHS
	CMP.B   #4, D2
	BEQ     DECODE_MINUSADDR_REG_LHS
	CMP.B   #7, D2
	BEQ     DECODE_EA_REG_LHS 
	JMP 	PRINT_LOGIC
*   END: 	DECODE_AND_EATODN Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_AND_DNTOEA Logic
*----------------------------------------------------------------------------
DECODE_ANDB_DNTOEA
	LEA 	DISPLAY_ANDB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ANDB         Flag set to true for when decoding RHS
	MOVE.B  #1, IS_WORD
	BRA     DECODE_AND_DNTOEA

DECODE_ANDW_DNTOEA
	LEA 	DISPLAY_ANDW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ANDW         Flag set to true for when decoding RHS
	MOVE.B  #1, IS_WORD
	BRA     DECODE_AND_DNTOEA
	
DECODE_ANDL_DNTOEA
	LEA 	DISPLAY_ANDL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_ANDL         Flag set to true for when decoding RHS
	MOVE.B  #1, IS_LONG
	
DECODE_AND_DNTOEA	
	MOVE.B  #1, IS_DNTOEA
	JMP		DECODE_ADD_DATA_REG_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_AND_DNTOEA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_SUBI Logic
*----------------------------------------------------------------------------
DECODE_SUBIB
	LEA 	DISPLAY_SUBIB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_WORD
    BRA     DECODE_SUBI

DECODE_SUBIW
	LEA 	DISPLAY_SUBIW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_WORD         Flag set to true for when decoding IMDATA_W
	BRA     DECODE_SUBI
	
DECODE_SUBIL
	LEA 	DISPLAY_SUBIL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_LONG         Flag set to true for when decoding IMDATA_L

DECODE_SUBI	
    MOVE.B	#1, IS_SUBI         Flag set to true for when decoding RHS
	JMP		DECODE_IMDATA_LHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_SUBI Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_SUB_DNTOEA Logic
*----------------------------------------------------------------------------
DECODE_SUBB_DNTOEA 
	LEA 	DISPLAY_SUBB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_SUBB
	MOVE.B  #1, IS_BYTE
	MOVE.B  #1, IS_WORD
	BRA     DECODE_SUB_DNTOEA 
	
DECODE_SUBW_DNTOEA 
	LEA 	DISPLAY_SUBW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_SUBW
	MOVE.B  #1, IS_WORD
	BRA     DECODE_SUB_DNTOEA 
	
DECODE_SUBL_DNTOEA 
	LEA 	DISPLAY_SUBL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B  #1, IS_SUBL
	MOVE.B  #1, IS_LONG	
    
DECODE_SUB_DNTOEA
    MOVE.B  #1, IS_DNTOEA
	JMP		DECODE_ADD_DATA_REG_LHS
	JMP 	PRINT_LOGIC
*   END:    DECODE_SUB_DNTOEA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_SUB_EATODN Logic
*----------------------------------------------------------------------------
DECODE_SUBB_EATODN
	LEA 	DISPLAY_SUBB, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_SUBB             Flag set to true for when decoding RHS
	MOVE.B  #1, IS_BYTE
	MOVE.B  #1, IS_WORD
	BRA     DECODE_SUB_EATODN
	
DECODE_SUBW_EATODN
	LEA 	DISPLAY_SUBW, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_SUBW             Flag set to true for when decoding RHS
	MOVE.B  #1, IS_WORD
	BRA     DECODE_SUB_EATODN
	
DECODE_SUBL_EATODN
	LEA 	DISPLAY_SUBL, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	MOVE.B	#1, IS_SUBL             Flag set to true for when decoding RHS
	MOVE.B  #1, IS_LONG
	
DECODE_SUB_EATODN	
    MOVE.B  #1, IS_EATODN
	JSR     GET_EAMODE_BITS
	CMP.B   #0, D2
	BEQ		DECODE_DATA_REG_LHS
	CMP.B   #1, IS_BYTE
	BEQ     SKIP_AN_SUB             Addr register not allowed for byte-ops
	CMP.B   #1, D2
	BEQ     DECODE_ADDR_REG_LHS
	
SKIP_AN_SUB
	CMP.B   #2, D2
	BEQ     DECODE_ADDRP_REG_LHS
	CMP.B   #3, D2
	BEQ     DECODE_ADDRPLUS_REG_LHS
	CMP.B   #4, D2
	BEQ     DECODE_MINUSADDR_REG_LHS
	CMP.B   #7, D2
	BEQ     DECODE_EA_REG_LHS
 
    JMP     PRINT_LOGIC
*   END:    DECODE_SUB_EATODN Logic
*----------------------------------------------------------------------------
*****************************************************************************
***********************<<DECODE RHS SUBROUTINES>>****************************
*****************************************************************************
*----------------------------------------------------------------------------
*   DECODE_DATA_REG_RHS Logic Dn
*----------------------------------------------------------------------------
DECODE_DATA_REG_RHS
	JSR 	GET_REGISTER_BITS
	CMP.B	#0, D2
	BEQ		PRINT_D0_RHS
	CMP.B	#1, D2
	BEQ		PRINT_D1_RHS
	CMP.B	#2, D2
	BEQ		PRINT_D2_RHS
	CMP.B	#3, D2
	BEQ		PRINT_D3_RHS
	CMP.B	#4, D2
	BEQ		PRINT_D4_RHS
	CMP.B	#5, D2
	BEQ		PRINT_D5_RHS
	CMP.B	#6, D2
	BEQ		PRINT_D6_RHS
	CMP.B	#7, D2
	BEQ		PRINT_D7_RHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_DATA_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_DATA_REG_RHS_BITS_0TO2 Logic *ASL/LSL/ROL
*----------------------------------------------------------------------------
DECODE_DATA_REG_RHS_BITS_0TO2
	JSR 	GET_REGISTER_BITS_0TO2
	CMP.B	#0, D2
	BEQ		PRINT_D0_RHS
	CMP.B	#1, D2
	BEQ		PRINT_D1_RHS
	CMP.B	#2, D2
	BEQ		PRINT_D2_RHS
	CMP.B	#3, D2
	BEQ		PRINT_D3_RHS
	CMP.B	#4, D2
	BEQ		PRINT_D4_RHS
	CMP.B	#5, D2
	BEQ		PRINT_D5_RHS
	CMP.B	#6, D2
	BEQ		PRINT_D6_RHS
	CMP.B	#7, D2
	BEQ		PRINT_D7_RHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_DATA_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDR_REG_RHS Logic An
*----------------------------------------------------------------------------
DECODE_ADDR_REG_RHS
	JSR     GET_REGISTER_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_RHS
	JMP		PRINT_LOGIC	
   	*END: 	DECODE_ADDR_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDRP_REG_RHS Logic (An)
*----------------------------------------------------------------------------
DECODE_ADDRP_REG_RHS
	JSR     GET_REGISTER_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_P_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_P_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_P_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_P_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_P_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_P_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_P_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_P_RHS
ADDRP_REG_END
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDRP_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDRPLUS_REG_RHS Logic (An)+
*----------------------------------------------------------------------------
DECODE_ADDRPLUS_REG_RHS
	JSR     GET_REGISTER_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_PP_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_PP_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_PP_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_PP_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_PP_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_PP_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_PP_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_PP_RHS
DECODE_ADDRPLUS_END
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDRPLUS_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MINUSADDR_REG_RHS Logic -(An)
*----------------------------------------------------------------------------
DECODE_MINUSADDR_REG_RHS
	JSR     GET_REGISTER_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_PM_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_PM_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_PM_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_PM_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_PM_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_PM_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_PM_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_PM_RHS
MINUSADDR_REG_END
	JMP		PRINT_LOGIC	
*   END: 	DECODE_MINUSADDR_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_REG_RHS Logic
*----------------------------------------------------------------------------
DECODE_EA_REG_RHS
	JSR     GET_REGISTER_BITS
	CMP.B	#0, D2		        (xxxx).W
	BEQ		DECODE_EA_WORD_RHS
	CMP.B	#1,	D2		        (xxxx).L
	BEQ		DECODE_EA_LONG_RHS
DECODE_EA_REG_END
	JMP		PRINT_LOGIC
*   END:    DECODE_EA_REG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_WORD_RHS Logic
*----------------------------------------------------------------------------
DECODE_EA_WORD_RHS
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.W  (A5)+,D6            Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.W  #$F000, D1      	Move the masking value to D1
    
EA_WORD_LOOP_RHS
    MOVE.W  D6, D5              D5 will hold addr for manipulation
    AND.W   D1, D5              Mask D5 with mask value
    LSR.W   #4, D1              Update the mask to next digit, by shifting 4
    ROL.W   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.W  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #4, D2              IF counter equals terminal value
    BEQ     EXIT_EA_WORD_LOOP_RHS 	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_WORD_LOOP_RHS    Loop to start of loop
EXIT_EA_WORD_LOOP_RHS
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
*   END: 	DECODE_EA_WORD_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_LONG_RHS Logic
*----------------------------------------------------------------------------
DECODE_EA_LONG_RHS
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.L  (A5)+, D6           Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.L  #$F0000000, D1      Move the masking value to D1
    
EA_LONG_LOOP_RHS
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L	D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2              IF counter equals terminal value
    BEQ     EXIT_EA_LONG_LOOP_RHS  	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_LONG_LOOP_RHS    Loop to start of loop
EXIT_EA_LONG_LOOP_RHS
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
*   END: 	DECODE_EA_LONG_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_IMDATA_RHS Logic
*----------------------------------------------------------------------------
DECODE_IMDATA_RHS
	JSR     PRINT_IMDATA
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    
    MOVE.B  #1, D2              Counter Variable
   	MOVE.B  #4, D3              D3 will hold starting shift value, as 4
   	
    CMP.B	#1, IS_LONG			Check to see if it is LONG IM_DATA
    BEQ		IS_LONG_IMDATA	
    
	*For when word
    MOVE.W  #$F000, D1      	Move the masking value to D1
    MOVE.W  (A5)+, D6           Put current addr into D6, to hold addr value
	
IMDATA_LOOP_W_RHS
    MOVE.W  D6, D5              D5 will hold addr for manipulation
    AND.W	D1, D5              Mask D5 with mask value
    LSR.W   #4, D1              Update the mask to next digit, by shifting 4
    ROL.W   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.W  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #4,D2    			IF counter equals terminal value
    BEQ     EXIT_IMDATA_LOOP_W_RHS Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     IMDATA_LOOP_W_RHS   Loop to start of loop
EXIT_IMDATA_LOOP_W_RHS
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
	
IS_LONG_IMDATA_R
    MOVE.L  #$F0000000, D1      Move the masking value to D1
    MOVE.L  (A5)+, D6           Put current addr into D6, to hold addr value
    
IMDATA_LOOP_L_RHS
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L	D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2    			IF counter equals terminal value
    BEQ     EXIT_IMDATA_LOOP_L_RHS Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     IMDATA_LOOP_L_RHS   Loop to start of loop
EXIT_IMDATA_LOOP_L_RHS
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
*   END: 	DECODE_IMDATA_RHS Logic
*----------------------------------------------------------------------------
*****************************************************************************
***********************<<DECODE LHS SUBROUTINES>>****************************
*****************************************************************************
*----------------------------------------------------------------------------
*   DECODE_IMDATA_LHS Logic
*----------------------------------------------------------------------------
DECODE_IMDATA_LHS
	JSR     PRINT_IMDATA
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.B  #1, D2              Counter Variable
   	MOVE.B  #4, D3              D3 will hold starting shift value, as 4
   	
    CMP.B	#1, IS_LONG			Check to see if it is LONG IM_DATA
    BEQ		IS_LONG_IMDATA	
	
	*For when word
    MOVE.W  #$F000, D1      	Move the masking value to D1
    MOVE.W  (A5)+, D6           Put current addr into D6, to hold addr value
    BRA     IMDATA_LOOP_W_LHS

SET_MOVEQ_IMDATA        
    CMP.B   #1, IS_MOVEQ        IF we get here, we are trying to print
    MOVE.W  D2, D6              8BIT DATA for MOVEQ, so we reinitialize
    MOVE.B  #1, D2              Counter Variable
   	MOVE.B  #4, D3              D3 will hold starting shift value, as 4
   	MOVE.W  #$F000, D1      	Move the masking value to D1
	
IMDATA_LOOP_W_LHS
    MOVE.W  D6, D5              D5 will hold addr for manipulation
    AND.W	D1, D5              Mask D5 with mask value
    LSR.W   #4, D1              Update the mask to next digit, by shifting 4
    ROL.W   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.W  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #4,D2    			IF counter equals terminal value
    BEQ     EXIT_IMDATA_LOOP_W_LHS Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     IMDATA_LOOP_W_LHS   Loop to start of loop
EXIT_IMDATA_LOOP_W_LHS
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP 	PRINT_LOGIC	
	
IS_LONG_IMDATA
    MOVE.L  #$F0000000, D1      Move the masking value to D1
    MOVE.L  (A5)+, D6           Put current addr into D6, to hold addr value
    
IMDATA_LOOP_L_LHS
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L	D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2    			IF counter equals terminal value
    BEQ     EXIT_IMDATA_LOOP_L_LHS Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     IMDATA_LOOP_L_LHS   Loop to start of loop

EXIT_IMDATA_LOOP_L_LHS
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_IMDATA_LONG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADD_DATA_REG_LHS Logic *SPECIAL CASE Dn bits 11-9
*----------------------------------------------------------------------------
DECODE_ADD_DATA_REG_LHS
	JSR     GET_REGISTER_BITS
	CMP.B	#0, D2
	BEQ		PRINT_D0_LHS
	CMP.B	#1, D2
	BEQ		PRINT_D1_LHS
	CMP.B	#2, D2
	BEQ		PRINT_D2_LHS
	CMP.B	#3, D2
	BEQ		PRINT_D3_LHS
	CMP.B	#4, D2
	BEQ		PRINT_D4_LHS
	CMP.B	#5, D2
	BEQ		PRINT_D5_LHS
	CMP.B	#6, D2
	BEQ		PRINT_D6_LHS
	CMP.B	#7, D2
	BEQ		PRINT_D7_LHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADD_DATA_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_DATA_REG_LHS Logic *instruction with 2 operands 
*----------------------------------------------------------------------------
DECODE_DATA_REG_LHS
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_D0_LHS
	CMP.B	#1, D2
	BEQ		PRINT_D1_LHS
	CMP.B	#2, D2
	BEQ		PRINT_D2_LHS
	CMP.B	#3, D2
	BEQ		PRINT_D3_LHS
	CMP.B	#4, D2
	BEQ		PRINT_D4_LHS
	CMP.B	#5, D2
	BEQ		PRINT_D5_LHS
	CMP.B	#6, D2
	BEQ		PRINT_D6_LHS
	CMP.B	#7, D2
	BEQ		PRINT_D7_LHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_DATA_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDR_REG_LHS Logic *instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_ADDR_REG_LHS
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_LHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_LHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_LHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_LHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_LHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_LHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_LHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_LHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDR_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDRP_REG_LHS Logic *instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_ADDRP_REG_LHS
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_P_LHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_P_LHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_P_LHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_P_LHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_P_LHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_P_LHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_P_LHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_P_LHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDRP_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDRPLUS_REG_LHS Logic *instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_ADDRPLUS_REG_LHS
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_PP_LHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_PP_LHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_PP_LHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_PP_LHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_PP_LHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_PP_LHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_PP_LHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_PP_LHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDRPLUS_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MINUSADDR_REG_LHS Logic *instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_MINUSADDR_REG_LHS
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_PM_LHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_PM_LHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_PM_LHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_PM_LHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_PM_LHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_PM_LHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_PM_LHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_PM_LHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_MINUSADDR_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_REG_LHS Logic 	*instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_EA_REG_LHS
	JSR	    GET_EAREG_BITS
	CMP.B	#0, D2		        (xxxx).W
	BEQ		DECODE_EA_WORD_LHS
	CMP.B	#1,	D2		        (xxxx).L
	BEQ		DECODE_EA_LONG_LHS
	CMP.B	#4,	D2		        #DATA
	BEQ		DECODE_IMDATA_LHS
	JMP		PRINT_LOGIC
*   END: 	DECODE_EA_REG_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_WORD_LHS Logic *instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_EA_WORD_LHS
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.W  (A5)+,D6            Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.W  #$F000, D1      	Move the masking value to D1
    
EA_WORD_LOOP_LHS
    MOVE.W  D6, D5              D5 will hold addr for manipulation
    AND.W   D1, D5              Mask D5 with mask value
    LSR.W   #4, D1              Update the mask to next digit, by shifting 4
    ROL.W   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.W  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #4, D2              IF counter equals terminal value
    BEQ     EXIT_EA_WORD_LOOP_LHS 	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_WORD_LOOP_LHS    Loop to start of loop
EXIT_EA_WORD_LOOP_LHS
    JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_EA_WORD_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_LONG_LHS Logic	*instruction with 2 operands
*----------------------------------------------------------------------------
DECODE_EA_LONG_LHS
    JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.L  (A5)+, D6           Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.L  #$F0000000, D1      Move the masking value to D1
    
EA_LONG_LOOP_LHS
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L	D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2              IF counter equals terminal value
    BEQ     EXIT_EA_LONG_LOOP_LHS  	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_LONG_LOOP_LHS    Loop to start of loop
EXIT_EA_LONG_LOOP_LHS
    JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP 	PRINT_LOGIC
*   END: 	DECODE_EA_LONG_LHS Logic
*----------------------------------------------------------------------------
*****************************************************************************
***********************<<DECODE SINGLE OP SUBROUTINES>>**********************
*****************************************************************************
*----------------------------------------------------------------------------
*   DECODE_DATA_REG_ONE_OPERAND Logic *clr
*----------------------------------------------------------------------------
DECODE_DATA_REG_ONE_OPERAND
	JSR GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_D0_RHS
	CMP.B	#1, D2
	BEQ		PRINT_D1_RHS
	CMP.B	#2, D2
	BEQ		PRINT_D2_RHS
	CMP.B	#3, D2
	BEQ		PRINT_D3_RHS
	CMP.B	#4, D2
	BEQ		PRINT_D4_RHS
	CMP.B	#5, D2
	BEQ		PRINT_D5_RHS
	CMP.B	#6, D2
	BEQ		PRINT_D6_RHS
	CMP.B	#7, D2
	BEQ		PRINT_D7_RHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_DATA_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDR_REG_ONE_OPERAND Logic 
*----------------------------------------------------------------------------
DECODE_ADDR_REG_ONE_OPERAND
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_RHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDR_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDRP_REG_ONE_OPERAND Logic *clr
*----------------------------------------------------------------------------
DECODE_ADDRP_REG_ONE_OPERAND
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_P_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_P_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_P_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_P_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_P_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_P_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_P_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_P_RHS
	JMP		PRINT_LOGIC	
*   END:    DECODE_ADDR_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_ADDRPLUS_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
DECODE_ADDRPLUS_REG_ONE_OPERAND
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_PP_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_PP_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_PP_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_PP_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_PP_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_PP_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_PP_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_PP_RHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_ADDRPLUS_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_MINUSADDR_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
DECODE_MINUSADDR_REG_ONE_OPERAND
	JSR     GET_EAREG_BITS
	CMP.B	#0, D2
	BEQ		PRINT_A0_PM_RHS
	CMP.B	#1, D2
	BEQ		PRINT_A1_PM_RHS
	CMP.B	#2, D2
	BEQ		PRINT_A2_PM_RHS
	CMP.B	#3, D2
	BEQ		PRINT_A3_PM_RHS
	CMP.B	#4, D2
	BEQ		PRINT_A4_PM_RHS
	CMP.B	#5, D2
	BEQ		PRINT_A5_PM_RHS
	CMP.B	#6, D2
	BEQ		PRINT_A6_PM_RHS
	CMP.B	#7, D2
	BEQ		PRINT_A7_PM_RHS
	JMP		PRINT_LOGIC	
*   END: 	DECODE_MINUSADDR_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
DECODE_EA_REG_ONE_OPERAND
	JSR	    GET_EAREG_BITS
	CMP.B	#0, D2		        (xxxx).W
	BEQ		DECODE_EA_WORD_RHS
	CMP.B	#1,	D2		        (xxxx).L
	BEQ		DECODE_EA_LONG_RHS
	JMP		PRINT_LOGIC
*   END: 	DECODE_EA_REG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_WORD_ONE_OPERAND Logic
*----------------------------------------------------------------------------
DECODE_EA_WORD_ONE_OPERAND
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.W  (A5)+,D6            Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.W  #$F000, D1      	Move the masking value to D1
    
EA_WORD_LOOP_ONE_OPERAND
    MOVE.W  D6, D5              D5 will hold addr for manipulation
    AND.W   D1, D5              Mask D5 with mask value
    LSR.W   #4, D1              Update the mask to next digit, by shifting 4
    ROL.W   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.W  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #4, D2              IF counter equals terminal value
    BEQ     EXIT_EA_WORD_LOOP_ONE_OPERAND 	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_WORD_LOOP_RHS    Loop to start of loop
EXIT_EA_WORD_LOOP_ONE_OPERAND
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
*   END: 	DECODE_EA_WORD_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_EA_LONG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
DECODE_EA_LONG_ONE_OPERAND
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.L  (A5)+, D6           Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.L  #$F0000000, D1      Move the masking value to D1
    
EA_LONG_LOOP_ONE_OPERAND
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L	D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with a 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2              IF counter equals terminal value
    BEQ     EXIT_EA_LONG_LOOP_ONE_OPERAND  	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     EA_LONG_LOOP_ONE_OPERAND    Loop to start of loop
EXIT_EA_LONG_LOOP_ONE_OPERAND
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
*   END: 	DECODE_EA_LONG_ONE_OPERAND Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   CHECK_DECODE_RHS Logic
*----------------------------------------------------------------------------
CHECK_DECODE_RHS
    CMP.B	#1, IS_CMP			Decode RHS for CMP
    BEQ     CMP_RHS
    CMP.B   #1, IS_LEA          Decode RHS for LEA
	BEQ		LEA_RHS
    CMP.B   #1, IS_MOVE         Decode RHS for MOVE
    BEQ     MOVE_RHS            
    CMP.B   #1, IS_MOVEQ        Decode RHS for MOVEQ
    BEQ     MOVEQ_RHS
    CMP.B   #1, IS_MOVEM        Decode RHS for MOVEM ONLY for Mem to Reg 
    BEQ     MOVEM_RHS 
    CMP.B   #1, IS_MULS         Decode RHS for MULS
    BEQ     MULS_RHS
    CMP.B   #1, IS_ADDB         DST for ADD excludes An, #<data>
    BEQ     ADDB_RHS
    CMP.B   #1, IS_ADDW         DST for ADD excludes #<data>
    BEQ     ADD_W_L_RHS	
    CMP.B   #1, IS_ADDL
    BEQ     ADD_W_L_RHS	
    CMP.B   #1, IS_DIVU         Decode RHS for DIVS
    BEQ     DIVU_RHS
    CMP.B   #1, IS_ADDI         DST for ADD excludes An, #<data>
    BEQ     ADDI_RHS
    CMP.B   #1, IS_ADDA         DST for ADD excludes An, #<data>
    BEQ     ADDA_RHS
    CMP.B   #1, IS_ANDB         DST for ADD excludes An, #<data>
    BEQ     ANDB_RHS
    CMP.B   #1, IS_ANDW         DST for ADD excludes #<data>
    BEQ     AND_W_L_RHS
    CMP.B   #1, IS_ANDL
    BEQ     AND_W_L_RHS
    CMP.B   #1, IS_SUBI         DST for ADD excludes An, #<data>
    BEQ     SUBI_RHS
    CMP.B   #1, IS_SUBB         DST for ADD excludes An, #<data>
    BEQ     SUBB_RHS
    CMP.B   #1, IS_SUBW         DST for ADD excludes #<data>
    BEQ     SUB_W_L_RHS
    CMP.B   #1, IS_SUBL
    BEQ     SUB_W_L_RHS
    CMP.B   #1, IS_STOP         Decode RHS for STOP    
    BEQ     STOP_RHS
	JMP 	PRINT_LOGIC
*   END: 	CHECK_DECODE_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DECODE_RHS Logic
*----------------------------------------------------------------------------
DECODE_RHS
	
CMP_RHS
	JMP		DECODE_DATA_REG_RHS 		DST for CMP is only Dn
LEA_RHS        
	JMP		DECODE_ADDR_REG_RHS 		DST for LEA is only An
MULS_RHS
	JMP		DECODE_DATA_REG_RHS 		DST for MULS is only Dn
DIVU_RHS
	JMP		DECODE_DATA_REG_RHS 		DST for DIVU is only Dn
MOVEQ_RHS
    JMP		DECODE_DATA_REG_RHS 		DST for MOVEQ is only Dn
MOVEM_RHS	
	JMP		DECODE_MOVEM_REGISTERS_RHS	DST for MOVEM (Mem to Reg)
STOP_RHS
    JMP		DECODE_IMDATA_RHS   		STOP has only IM_DATA.W
MOVE_RHS	
	JSR 	GET_OPMODE_BITS     		DST for MOVE is Dn/(An)/(An)+/-(An)/EA_W/L/IM_DATA
	CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_RHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS

ADDB_RHS                         
	CMP.B   #1, IS_EATODN
	BEQ     DECODE_DATA_REG_RHS
	
    JSR     GET_EAMODE_BITS     		DST for ADDB is (An)/(An)+/-(An)/EA_W/EA_L
    CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_RHS
    CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B   #1, IS_DNTOEA
	BEQ     DECODE_EA_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS           
	JMP		PRINT_LOGIC	

ADD_W_L_RHS	
	CMP.B   #1, IS_EATODN
	BEQ     DECODE_DATA_REG_RHS
	
    JSR 	GET_EAMODE_BITS     		DST for ADD.W/ADD.L is same 
	CMP.B	#0, D2
	BEQ     DECODE_DATA_REG_RHS
	CMP.B	#1, D2
	BEQ     DECODE_ADDR_REG_RHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B   #1, IS_DNTOEA
	BEQ     DECODE_EA_REG_ONE_OPERAND
    CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS          	
	JMP		PRINT_LOGIC
	
ADDI_RHS
    JSR     GET_EAMODE_BITS     		DST for ADDI is Dn/(An)/(An)+/-(An)/EA_W/EA_L
    CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_ONE_OPERAND
    CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_ONE_OPERAND
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_ONE_OPERAND
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_ONE_OPERAND
	JMP		PRINT_LOGIC

ADDA_RHS
    JMP     DECODE_ADDR_REG_RHS
    JMP		PRINT_LOGIC
	
ANDB_RHS                         
	CMP.B   #1, IS_EATODN
	BEQ     DECODE_DATA_REG_RHS
    
	JSR     GET_EAMODE_BITS     		DST for ANDB is (An)/(An)+/-(An)/EA_W/EA_L
    CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_RHS
    CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B   #1, IS_DNTOEA
	BEQ     DECODE_EA_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS           
	JMP		PRINT_LOGIC

AND_W_L_RHS
	CMP.B   #1, IS_EATODN
	BEQ     DECODE_DATA_REG_RHS
	
    JSR 	GET_EAMODE_BITS         	DST for AND.W/AND.L is the same
	CMP.B	#0, D2
	BEQ     DECODE_DATA_REG_RHS
	CMP.B	#1, D2
	BEQ     DECODE_ADDR_REG_RHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B   #1, IS_DNTOEA
	BEQ     DECODE_EA_REG_ONE_OPERAND
    CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS          	
	JMP		PRINT_LOGIC

SUBI_RHS
    JSR     GET_EAMODE_BITS     		DST for ADDI is Dn/(An)/(An)+/-(An)/EA_W/EA_L
    CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_ONE_OPERAND
    CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_ONE_OPERAND
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_ONE_OPERAND
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_ONE_OPERAND
	JMP		PRINT_LOGIC

SUBB_RHS                         
	CMP.B   #1, IS_EATODN
	BEQ     DECODE_DATA_REG_RHS
	
    JSR     GET_EAMODE_BITS     		DST for ADDB is (An)/(An)+/-(An)/EA_W/EA_L
    CMP.B	#0, D2
	BEQ		DECODE_DATA_REG_RHS
    CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B   #1, IS_DNTOEA
	BEQ     DECODE_EA_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS           
	JMP		PRINT_LOGIC
	
SUB_W_L_RHS
	CMP.B   #1, IS_EATODN
	BEQ     DECODE_DATA_REG_RHS
	
    JSR 	GET_EAMODE_BITS     		DST for SUB.W/SUB.L is the same
	CMP.B	#0, D2
	BEQ     DECODE_DATA_REG_RHS
	CMP.B	#1, D2
	BEQ     DECODE_ADDR_REG_RHS
	CMP.B	#2, D2
	BEQ		DECODE_ADDRP_REG_RHS
	CMP.B	#3, D2
	BEQ		DECODE_ADDRPLUS_REG_RHS
	CMP.B	#4, D2
	BEQ		DECODE_MINUSADDR_REG_RHS
	CMP.B   #1, IS_DNTOEA
	BEQ     DECODE_EA_REG_ONE_OPERAND
	CMP.B	#7, D2
	BEQ		DECODE_EA_REG_RHS           
	JMP		PRINT_LOGIC
*   END:    DECODE_RHS Logic
*----------------------------------------------------------------------------
*****************************************************************************
********************************<<MISC SUBROUTINES>>*************************
*****************************************************************************
*----------------------------------------------------------------------------
*   INITIALIZE_VARIABLES
*----------------------------------------------------------------------------
INITIALIZE_VARIABLES
	MOVE.B 	#0, IS_CMP
	MOVE.B	#0, IS_BYTE
	MOVE.B	#0, IS_WORD
	MOVE.B	#0, IS_LONG
	MOVE.B  #0, IS_LEA
	MOVE.B  #0, IS_MOVE
	MOVE.B  #0, IS_MULS	
	MOVE.B  #0, IS_DIVU
    MOVE.B  #0, IS_MOVEQ
    MOVE.B	#0,	IS_MOVEM
    MOVE.B  #0, IS_STOP
	MOVE.B  #0, IS_ADDB
	MOVE.B  #0, IS_ADDW
	MOVE.B  #0, IS_ADDL
	MOVE.B  #0, IS_ADDI
	MOVE.B  #0, IS_ADDA
	MOVE.B  #0, IS_ANDB
	MOVE.B  #0, IS_ANDW
	MOVE.B  #0, IS_ANDL
	MOVE.B  #0, IS_SUBI
	MOVE.B  #0, IS_SUBB
	MOVE.B  #0, IS_SUBW
	MOVE.B  #0, IS_SUBL
	MOVE.B  #0, IS_EATODN
	MOVE.B  #0, IS_DNTOEA
	MOVE.B	#0,	IS_MEM_TO_REG
	MOVE.B	#0,	IS_MOVEM_EA_REG
	MOVE.B	#0,	IS_MINUSADDR
	MOVE.B	#0, IS_IMMEDIATE_DATA
	MOVE.B	#0, IS_LEFT
	RTS
*   END:    INITIALIZE_VARIABLES
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   CLR_DATAREG Logic -- Saves D7
*----------------------------------------------------------------------------
CLR_DATAREG_D6                    
    CLR.L   D0
    CLR.L   D1
    CLR.L   D2
    CLR.L   D3
    CLR.L   D4
    CLR.L   D5
    CLR.L   D6
    RTS
*   END:    CLR_DATAREG Logic
*---------------------------------------------------------------------------- 
*----------------------------------------------------------------------------
*   CLR_ALL Logic
*----------------------------------------------------------------------------
CLR_ALL
	CLR.L	D0
	CLR.L	D1
	CLR.L	D2
	CLR.L	D3
	CLR.L	D4
	CLR.L	D5
	CLR.L	D6
	CLR.L	D7
	MOVEA.L #0, A0
	MOVEA.L #0, A1
	MOVEA.L #0, A2
	MOVEA.L #0, A3
	MOVEA.L #0, A4
	MOVEA.L #0, A5
	MOVEA.L #0, A6
	RTS
*   END:    CLR_ALL Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   CHECK_MODE Logic     CHECK modes before decoding (to prevent 101,110,111)
*----------------------------------------------------------------------------
CHECK_MODE
	CMP.W	#$4E71,D7			NOP pass by
	BEQ		END_OF_CHECK
	CMP.W	#$4E72,D7			STOP pass by
	BEQ		END_OF_CHECK
	CMP.W	#$4E75,D7			RTS pass by
	BEQ		END_OF_CHECK
	CMP.B	#6,D0				BCC pass by
	BEQ		END_OF_CHECK
	CMP.B	#7,D0				MOVEQ pass by
	BEQ		END_OF_CHECK
	CMP.B	#14,D0				ROL/LSL/ASR pass by for now check later because of RS mode
	BEQ		END_OF_CHECK
	
	CMP.B	#1, D0				MOVE.B LHS check
	BEQ		CHECK_EA_LHS
	CMP.B	#2, D0				MOVE.W LHS check
	BEQ		CHECK_EA_LHS
	CMP.B	#3, D0				MOVE.L LHS check
	BNE		CHECK_EA_RHS

CHECK_EA_LHS
	JSR		GET_OPMODE_BITS		Check 6th - 8th bit additional check for MOVE
	CMP.B	#1,	D2
	BEQ		INVALID_OP
	CMP.B	#5, D2
	BEQ		INVALID_OP
	CMP.B	#6, D2
	BEQ		INVALID_OP
	CMP.B	#7,	D2
	BNE		CHECK_EA_RHS
	JSR		GET_REGISTER_BITS	Check Mode %111, Reg %010 and %011
	CMP.B	#2, D2
	BEQ		INVALID_OP
	CMP.B	#3, D2
	BEQ		INVALID_OP		

CHECK_EA_RHS
	JSR		GET_EAMODE_BITS		Check 3rd - 5th bit EA MODE
	CMP.B	#5, D2
	BEQ		INVALID_OP
	CMP.B	#6, D2
	BEQ		INVALID_OP
	CMP.B	#7,	D2
	BNE		END_OF_CHECK
	JSR		GET_EAREG_BITS		Check Mode %111, Reg %010 and %011
	CMP.B	#2, D2
	BEQ		INVALID_OP
	CMP.B	#3, D2
	BEQ		INVALID_OP
	
END_OF_CHECK
	BRA		SAFE	
*   END:    CHECK_MODE Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   CHECK_ROTATIONS_OPMODE_LHS Logic		CHECK modes before start decoding
*                                           to prevent %101, %110, %111
*----------------------------------------------------------------------------
CHECK_ROTATIONS_OPMODE_LHS
	JSR		GET_EAMODE_BITS		            Check 3rd - 5th bit EA MODE
	CMP.B	#5, D2
	BEQ		INVALID_ROTATIONS_MS
	CMP.B	#6, D2
	BEQ		INVALID_ROTATIONS_MS
	BRA		VALID_ROTATIONS_MS
*   END:    CHECK_ROTATIONS_OPMODE_LHS
*----------------------------------------------------------------------------
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
