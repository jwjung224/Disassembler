*****************************************************************************
********************************<<GET SUBROUTINES>>**************************
*****************************************************************************
*----------------------------------------------------------------------------
* GET LOGIC: These subroutines are "Getters" which parses out the the bits
*            that determine the decode logics to decompile the opcode.
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_REGISTER_BITS Logic		    |11 X 9|8   6|5    3|2   0|    
*----------------------------------------------------------------------------
GET_REGISTER_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_4_BITS, D5		
	LSL.W 	D5, D2					
	MOVE.B 	#SHIFT_13_BITS, D5
	LSR.W 	D5, D2					Isolate bit 9 to 11 for Register
	RTS                             Note: For MOVE, this is DST_REG
*   END:    GET_OPMODE_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_REGISTER_BITS_BITS_0TO2 Logic |11   9|8   6|5   3|2 X 0|  
*----------------------------------------------------------------------------
GET_REGISTER_BITS_0TO2
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_13_BITS, D5		
	LSL.W 	D5, D2					Left shift 13 bits
	MOVE.B 	#SHIFT_13_BITS, D5
	LSR.W 	D5, D2					Isolate bit 0 to 2 (3 bits) for Register
	RTS
*   END: GET_OPMODE_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_OPMODE_BITS Logic           |11   9|8 X 6|5    3|2   0|
*----------------------------------------------------------------------------
GET_OPMODE_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_7_BITS, D5		
	LSL.W 	D5, D2					
	MOVE.B 	#SHIFT_13_BITS, D5
	LSR.W 	D5, D2					Isolate bit 6 to 8 for Opmode
	RTS                             Note: For MOVE, this is DST_MODE
*   END:    GET_OPMODE_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_EAMODE_BITS Logic           |11   9|8   6|5  X  3|2   0|
*----------------------------------------------------------------------------
GET_EAMODE_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_10_BITS, D5
	LSL.W 	D5, D2
	MOVE.B 	#SHIFT_13_BITS, D5
	LSR.W 	D5, D2                  Isolate bit 3 to 5 for EA_Mode
	RTS                             Note: For MOVE, this is SRC_MODE
*   END:    GET_EAMODE_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_EAREG_BITS Logic            |11   9|8   6|5    3|2 X 0|
*----------------------------------------------------------------------------
GET_EAREG_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_13_BITS,D5
	LSL.W 	D5, D2
	LSR.W 	D5, D2                  Isolate bit 0 to 2 for EA_Register
	RTS                             Note: For MOVE, this is SRC_REG
*   END:    GET_EAREG_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_BCC_BITS Logic
*----------------------------------------------------------------------------
GET_BCC_BITS
	MOVE.W 	D7, D2
	LSL.W 	#4, D2
	MOVE.B 	#SHIFT_12_BITS,D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_BCC_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_CLR_BITS Logic
*----------------------------------------------------------------------------
GET_CLR_BITS
	MOVE.W 	D7, D2
	LSL.W 	#4, D2
	MOVE.B 	#SHIFT_10_BITS,D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_CLR_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_JSR_BITS Logic
*----------------------------------------------------------------------------
GET_JSR_BITS
	MOVE.W 	D7, D2
	LSL.W 	#4, D2
	MOVE.B 	#SHIFT_10_BITS,D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_CLR_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_LEA_BITS Logic
*----------------------------------------------------------------------------
GET_LEA_BITS
	MOVE.W 	D7, D2
	LSL.W 	#SHIFT_7_BITS, D2
	MOVE.B 	#SHIFT_13_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_LEA_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_ADDI_BITS Logic  
*----------------------------------------------------------------------------
GET_ADDI_BITS
	MOVE.W  D7, D2
    LSR.W   #SHIFT_6_BITS, D2       Isolates size bits of ADDI (7-6)
    MOVE.B  #SHIFT_6_BITS, D5      
    LSL.W   D5, D2                  
	RTS
*   END:    GET_ADDI_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_MOVEQ_BITS Logic     *This gets 8th bit,  *MOVEQ ONLY 
*---------------------------------------------------------------------------- 
GET_MOVEQ_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_7_BITS, D5
	LSL.W 	D5, D2
	MOVE.B 	#SHIFT_15_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_MOVEQ_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_MOVEM_BITS Logic    *This gets 9th to 6th bits,  *MOVEM ONLY
*---------------------------------------------------------------------------- 
GET_MOVEM_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_6_BITS, D5
	LSL.W 	D5, D2
	MOVE.B 	#SHIFT_12_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_MOVEM_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_MOVEM_DR_BITS Logic    *This gets 11th to 10th bits,  *MOVEM ONLY
*---------------------------------------------------------------------------- 
GET_MOVEM_DR_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_4_BITS, D5
	LSL.W 	D5, D2
	MOVE.B 	#SHIFT_14_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_MOVEM_DR_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_DATA_8BITS Logic    	*This gets bits from 0 to 7,  *MOVEQ ONLY
*---------------------------------------------------------------------------
GET_DATA_8BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_8_BITS, D5
	LSL.W 	D5, D2
	MOVE.B 	#SHIFT_8_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_DATA_8BITS Logic
*----------------------------------------------------------------------------
*   GET_MULS_DIVU_BITS Logic    *This gets bits 8 to 6, shared by both
*---------------------------------------------------------------------------- 
GET_MULS_DIVU_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_7_BITS, D5
	LSL.W 	D5, D2
	MOVE.B 	#SHIFT_13_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_MULS_DIVU_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_SHIFT_SIZE_BITS Logic		6th & 7th Bit	*Used in ASL/LSL/ROL 
*----------------------------------------------------------------------------
GET_SHIFT_SIZE_BITS
	MOVE.W 	D7, D2
	MOVE.B	#SHIFT_8_BITS, D5
	LSL.W	D5, D2
	MOVE.B 	#SHIFT_14_BITS, D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_SHIFT_SIZE_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_SHIFT_RS_BITS Logic		 	3rd & 4th Bit	*Used in ASL/LSL/ROL
*----------------------------------------------------------------------------
GET_SHIFT_RS_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_11_BITS, D5
	LSL.W	D5,	D2
	MOVE.B	#SHIFT_14_BITS,	D5
	LSR.W	D5, D2
	RTS
*   END:    GET_SHIFT_RS_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_SHIFT_DIRECTION_BITS Logic	*Used in ASL/LSL/ROL 
*----------------------------------------------------------------------------
GET_SHIFT_DIRECTION_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_7_BITS, D5
	LSL.W	D5,	D2
	MOVE.B	#SHIFT_15_BITS,	D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_SHIFT_DIRECTION_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_SHIFT_IR_BITS Logic			*Used in ASL/LSL/ROL 
*----------------------------------------------------------------------------
GET_SHIFT_IR_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_10_BITS, D5
	LSL.W	D5,	D2
	MOVE.B	#SHIFT_15_BITS,	D5
	LSR.W	D5, D2
	RTS
*   END:    GET_SHIFT_DRSIZE_BITS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_SHIFT_CR_NUM_BITS Logic	*CR = Count(Im Data) or Register(D), Used in ASL/LSL/ROL 
*----------------------------------------------------------------------------
GET_SHIFT_CR_NUM_BITS
	MOVE.W 	D7, D2
	MOVE.B 	#SHIFT_4_BITS, D5
	LSL.W	D5,	D2
	MOVE.B	#SHIFT_13_BITS,	D5
	LSR.W 	D5, D2
	RTS
*   END:    GET_SHIFT_CR_NUM_BITS Logi
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   GET_IR_BITS Logic		        *Used in ASL/LSL/ROL 
*----------------------------------------------------------------------------	
GET_IR_BITS
	JSR		GET_SHIFT_IR_BITS
	CMP.B	#0,D2
	BEQ		DECODE_IMMEDIATE_NUM
	CMP.B	#1,D2
	BEQ		DECODE_REGISTER_NUM
    JMP     PRINT_LOGIC
*   END:    GET_IR_BITS Logic
*----------------------------------------------------------------------------
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
