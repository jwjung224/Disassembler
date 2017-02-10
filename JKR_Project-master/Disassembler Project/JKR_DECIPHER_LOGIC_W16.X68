*****************************************************************************
********************************<<DECIPHER LOGIC>>***************************
*****************************************************************************
*----------------------------------------------------------------------------
* DECIPHER LOGIC: Decipher the type of opcode and branch to its decode logic.
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* DECIPHER
*----------------------------------------------------------------------------
DECIPHER
    LEA     MSG_DECODE, A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     JMP_TABLE, A0           	Load jump table addr into A0
	
PRINT_LOGIC
	JSR		INITIALIZE_VARIABLES        Reset all variables
	JSR 	CLR_DATAREG_D6              Clear all Data Reg up to D6
	ADDI.B	#1, (PRINT_COUNTER)			Increment print counter by one
	CMP.B 	#30,(PRINT_COUNTER)		    Is printcount less than 30
	BGT		PRESS_ENTER					IF GT 30, go to prompt to press enter
	CMP.B 	#30, (PRINT_COUNTER)		Is printcount less than 30
	BNE		JMP_LOOP					IF NE, go to JUMP table loop
	
PRESS_ENTER                             *Print pause after printing 30 lines
	MOVE.B	#0, (PRINT_COUNTER)			Set print count to 0
	LEA		PRESS_ENTER_PROMPT, A1		Display press enter prompt
	MOVE.B 	#14, D0				
	TRAP 	#15
	MOVE.B 	#4, D0						Take the 'Enter' keyboard input
	TRAP 	#15
	CLR		D1							Discard user input

JMP_LOOP
    LEA     JMP_TABLE, A0           	Load jump table addr into A0
    CLR.L   D0                      	Clear D0 of size long   
    CMPA.L  A6, A5                  	Compare Start and End addr
	BGE		FINAL						IF current addr is or greater than ending, end decoding
    MOVE.W 	(A5),D7						Store full opword into D7
	JSR		DISPLAY_ADDRESS				Display addr in memory
	MOVE.W  (A5)+, D0               	Store another opword into D0 for manipulation
    MOVE.B  #SHIFT_12_BITS, D1         	Shift 12 bits to right to isolate first 4 bits
    LSR.W   D1, D0                  	Move the bits
	BRA		CHECK_MODE
	
SAFE
    MULU    #6, D0                  	Multiply D0 by 6 to properly identify 4 most sig bits
    JSR     0(A0,D0)                	Indirect jump to proper index in jump table
    CMPA.L  A6, A5                  	Compare current address and End adress
    BLE     JMP_LOOP                	IF Start addr less than End addr, reloop
*-----------------------------------------------------------------------------
*   JUMP TABLE    
*-----------------------------------------------------------------------------
JMP_TABLE
    JMP     MSB_0000                    *ADDI, ANDI, CMPI 
    JMP     MSB_0001                    *MOVE.B
    JMP     MSB_0010                    *MOVE.L
    JMP     MSB_0011                    *MOVE.W
    JMP     MSB_0100                    *CLR, MULS.L, DIVU.L, MOVEM, LEA, RTS, JSR, NOP, STOP
    JMP		MSB_0101                    *NOT USED  
    JMP     MSB_0110                    *BCC, BGT, BLE
    JMP     MSB_0111                    *MOVEQ.L
    JMP     MSB_1000                    *DIVU.W
    JMP     MSB_1001                    *SUB, SUBA
    JMP     MSB_1010                    *Unassigned  NOT USED    
    JMP     MSB_1011                    *CMP
    JMP     MSB_1100                    *AND, MULS.W
    JMP     MSB_1101                    *ADD, ADDA
    JMP     MSB_1110                    *ROL, ROR, LSL, LSR, ASL, ASR
    JMP     MSB_1111                    *Special/Reserved  NOT USED
    
*-----------------------------------------------------------------------------   
*   Most sig-bits 15 - 12 Operation Index (As in 1101~~~~~~~~~~~~)     
*-----------------------------------------------------------------------------
MSB_0000    
    JMP     MSB_SUBR_0000
MSB_0001    
    JMP     MSB_SUBR_0001
MSB_0010    
    JMP     MSB_SUBR_0010
MSB_0011    
    JMP     MSB_SUBR_0011
MSB_0100    
    JMP     MSB_SUBR_0100
MSB_0101    
    BRA     MSB_SUBR_0101	Not used   
MSB_0110    
    JMP     MSB_SUBR_0110 
MSB_0111    
    JMP     MSB_SUBR_0111 
MSB_1000    
    JMP     MSB_SUBR_1000 
MSB_1001    
    JMP     MSB_SUBR_1001
MSB_1010    
    JMP     MSB_SUBR_1010	Not used 
MSB_1011    
    JMP     MSB_SUBR_1011              
MSB_1100    
    JMP     MSB_SUBR_1100
MSB_1101    
    JMP     MSB_SUBR_1101  
MSB_1110    
    JMP     MSB_SUBR_1110
MSB_1111    
    BRA     MSB_SUBR_1111	Not used

*-----------------------------------------------------------------------------
*   Most sig-bits 15 - 12 decipher subroutines
*-----------------------------------------------------------------------------
*0000..*ADDI.B/W/L		            TESTED AND COMPLETE
MSB_SUBR_0000
	JSR     GET_ADDI_BITS 
    CMP.W   #$0600, D2
    BEQ     DECODE_ADDIB            If $0600, it's ADDI.B
    CMP.W   #$0640, D2
    BEQ     DECODE_ADDIW            If $0640, it's ADDI.W
    CMP.W   #$0680, D2
    BEQ     DECODE_ADDIL            If $0680, it's ADDI.L
    
    CMP.W   #$0400, D2
    BEQ     DECODE_SUBIB            If $0600, it's SUBI.B
    CMP.W   #$0440, D2
    BEQ     DECODE_SUBIW            If $0640, it's SUBI.W
    CMP.W   #$0480, D2
    BEQ     DECODE_SUBIL            If $0680, it's SUBI.L
    JMP     INVALID_OP

*0001..*MOVE.B                      TESTED AND COMPLETE
MSB_SUBR_0001
    JMP     DECODE_MOVEB
    JMP     INVALID_OP
 
*0010..*MOVE.L                      TESTED AND COMPLETE     
MSB_SUBR_0010
    JMP     DECODE_MOVEL
    JMP     INVALID_OP
   
*0011.. MOVE.W    	                TESTED AND COMPLETE          
MSB_SUBR_0011
    JMP     DECODE_MOVEW  
    JMP     INVALID_OP

*0100.. <CLR.B/W/L>, MOVEM, LEA, RTS, JSR, NOP, STOP     
MSB_SUBR_0100
	CMP.W	#$4E71, D7				Compares hex value for NOP
	BEQ		DECODE_NOP				IF equal, decode NOP Opcode
	
	CMP.W	#$4E72, D7				Compares hex value for STOP
	BEQ		DECODE_STOP				IF equal, decode STOP Opcode
	
	CMP.W	#$4E75, D7				Compares hex value for RTS
	BEQ		DECODE_RTS				IF equal, decode RTS Opcode
	
	JSR		GET_CLR_BITS            Get CLR Bits
	CMP.W	#VAR_CLRB, D2           IF match with CLR.B bits
	BEQ		DECODE_CLRB             Decode CLR.B
	CMP.W	#VAR_CLRW, D2           IF match with CLR.B bits
	BEQ		DECODE_CLRW             Decode CLR.W
	CMP.W	#VAR_CLRL, D2           IF match with CLR.B bits
	BEQ		DECODE_CLRL             Decode CLR.L
	
	JSR		GET_JSR_BITS            Get JSR Bits
	CMP.W	#VAR_JSR, D2            IF match with JSR bits
	BEQ		DECODE_JSR              Decode JSR
	
	JSR     GET_LEA_BITS            Get LEA Bits
	CMP.W   #VAR_LEA, D2            IF match with LSR bits    
	BEQ     DECODE_LEA              Decode JSR
	
	JSR		GET_MOVEM_BITS			Get MOVEM Bits
	CMP.W	#VAR_MOVEMW, D2			IF match with MOVEM.W bits 
	BEQ		DECODE_MOVEMW			Decode MOVEMW
	
	JSR		GET_MOVEM_BITS			Get MOVEM Bits
	CMP.W	#VAR_MOVEML, D2			IF match with MOVEM.L bits 
	BEQ		DECODE_MOVEML			Decode MOVEML
	JMP     INVALID_OP

*0101..ADDQ/SUBQ/Scc/DBcc           NOT USED       
MSB_SUBR_0101  
    JMP     INVALID_OP

*0110..*BCC, BGT, BLE               TESTED AND COMPLETE
MSB_SUBR_0110 
    JSR     GET_BCC_BITS 
    CMP.W   #VAR_BCC, D2
    BEQ     DECODE_BCC
    
    CMP.W   #VAR_BGT, D2
    BEQ     DECODE_BGT
     
    CMP.W   #VAR_BLE, D2
    BEQ     DECODE_BLE 
    JMP     INVALID_OP
 
*0111..*MOVEQ.L                      TESTED AND COMPLETE
MSB_SUBR_0111 
    JSR     GET_MOVEQ_BITS
    CMP.W   #VAR_MOVEQ,D2
    BEQ     DECODE_MOVEQ
    JMP     INVALID_OP

*1000..*DIVU.W                       TESTED AND COMPLETE
MSB_SUBR_1000 
    JSR		GET_MULS_DIVU_BITS      
	CMP.W	#VAR_DIVU,D2
	BEQ		DECODE_DIVU   
    JMP     INVALID_OP
     
*1001..*SUB.B/W/L				     TESTED AND COMPLETE
MSB_SUBR_1001                   
    JSR     GET_OPMODE_BITS             
    CMP.W   #0, D2
    BEQ     DECODE_SUBB_EATODN
    CMP.W   #1, D2
    BEQ     DECODE_SUBW_EATODN
    CMP.W   #2, D2
    BEQ     DECODE_SUBL_EATODN
    
    CMP.W   #4, D2
    BEQ     DECODE_SUBB_DNTOEA
    CMP.W   #5, D2
    BEQ     DECODE_SUBW_DNTOEA
    CMP.W   #6, D2
    BEQ     DECODE_SUBL_DNTOEA 
    JMP     INVALID_OP

*1011..*<CMP.B/W/L>	                  TESTED AND COMPLETE
MSB_SUBR_1011              
	JSR		GET_OPMODE_BITS
	CMP.W	#VAR_CMPB,D2
	BEQ		DECODE_CMPB
	CMP.W	#VAR_CMPW,D2
	BEQ		DECODE_CMPW
	CMP.W	#VAR_CMPL,D2
  	BEQ		DECODE_CMPL
   	JMP     INVALID_OP

*1010..Unassigned   NOt USED 
MSB_SUBR_1010   	
	JMP     INVALID_OP

*1100..*AND.B/W/L, MULS.W 			  TESTED AND COMPLETE
MSB_SUBR_1100    	
	JSR		GET_MULS_DIVU_BITS        Decode Muls/Divu   
	CMP.W	#VAR_MULS,D2
	BEQ		DECODE_MULS

	JSR     GET_OPMODE_BITS                 
    CMP.W   #0, D2
    BEQ     DECODE_ANDB_EATODN        Decode AND EA to Dn
    CMP.W   #1, D2
    BEQ     DECODE_ANDW_EATODN
    CMP.W   #2, D2
    BEQ     DECODE_ANDL_EATODN
    CMP.W   #4, D2
    BEQ     DECODE_ANDB_DNTOEA        Decode AND Dn to EA
    CMP.W   #5, D2
    BEQ     DECODE_ANDW_DNTOEA
    CMP.W   #6, D2
    BEQ     DECODE_ANDL_DNTOEA
    JMP     INVALID_OP
  
*1101..*ADD.B/W/L, ADDA.W/L 		  TESTED AND COMPLETE
MSB_SUBR_1101 
    JSR     GET_OPMODE_BITS
    CMP.W   #0, D2
    BEQ     DECODE_ADDB_EATODN
    CMP.W   #1, D2
    BEQ     DECODE_ADDW_EATODN
    CMP.W   #2, D2
    BEQ     DECODE_ADDL_EATODN
    CMP.W   #3, D2
    BEQ     DECODE_ADDAW
    CMP.W   #4, D2
    BEQ     DECODE_ADDB_DNTOEA
    CMP.W   #5, D2
    BEQ     DECODE_ADDW_DNTOEA
    CMP.W   #6, D2
    BEQ     DECODE_ADDL_DNTOEA
    CMP.W   #7, D2
    BEQ     DECODE_ADDAL   
    JMP     INVALID_OP 
     
*1110..*ROL.B/W/L, LSL.B/W/L, ASR.B/W/L     	TESTED AND COMPLETE
MSB_SUBR_1110       
	*<REG SHIFT>	
	JSR		GET_SHIFT_SIZE_BITS					Check 6th and 7th bit, %11 != RS mode
	CMP.B	#0,D2
	BEQ		DECODE_ROTATIONS_BYTE_RS			%00 == BYTE
	CMP.B	#1,D2
	BEQ		DECODE_ROTATIONS_WORD_RS			%01 == WORD
	CMP.B	#2,D2
	BEQ		DECODE_ROTATIONS_LONG_RS			%11 == LONG

	*<MEM SHIFT>	
	BRA		CHECK_ROTATIONS_OPMODE_LHS
VALID_ROTATIONS_MS           
	JSR		GET_SHIFT_SIZE_BITS
	CMP.B	#3,D2	
	BEQ		DECODE_ROTATIONS_MS     			Check 6th and 7th bit, %11 == MS mode 
INVALID_ROTATIONS_MS	
    JMP     INVALID_OP

*1111..Special/Reserved     NOT USED
MSB_SUBR_1111

INVALID_OP
    JMP INVALID_OPWORD		When current opword can't be decoded (ERROR)
*   END:    DECIPHER
*-----------------------------------------------------------------------------
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
