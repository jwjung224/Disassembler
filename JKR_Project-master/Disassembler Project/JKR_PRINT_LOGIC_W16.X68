*****************************************************************************
********************************<<PRINT_LOGIC>>******************************
*****************************************************************************
*----------------------------------------------------------------------------
* PRINT LOGIC: Collection of various subroutines used to print output.
*              Main printing logics: 
*              RHS PRINT - prints DST operands.
*              LHS PRINT - prints SRC operands.
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_SLASH Logic
*----------------------------------------------------------------------------
PRINT_SLASH
    LEA		DISPLAY_SLASH, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	RTS
*   END:    PRINT_SLASH Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_COMMA Logic
*----------------------------------------------------------------------------
PRINT_COMMA
    LEA		DISPLAY_COMMA, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	RTS
*   END:    PRINT_COMMA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_DOLLAR Logic
*----------------------------------------------------------------------------
PRINT_DOLLAR
	LEA 	DISPLAY_DOLLAR, A1
	MOVE.B 	#14, D0				
	TRAP 	#15
	RTS
*   END:    PRINT_DOLLAR Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_IMDATA Logic  *Prints out '#$'
*----------------------------------------------------------------------------
PRINT_IMDATA
    LEA 	DISPLAY_HASH, A1
	MOVE.B 	#14, D0				
	TRAP 	#15
	LEA 	DISPLAY_DOLLAR, A1
	MOVE.B 	#14, D0				
	TRAP 	#15
	RTS
*   END:    PRINT_IMDATA Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   CLEAR_NEXT_LINE Logic
*----------------------------------------------------------------------------
CLEAR_NEXT_LINE
	LEA     CLEAR_LINE,A1       Display a space and clear to new line
	MOVE.B  #14, D0             |
	TRAP    #15                 V
	RTS                         RTS
*   END:    CLEAR_NEXT_LINE Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   DISPLAY_ADDRESS             Prints the address of where data is in memory
*----------------------------------------------------------------------------
DISPLAY_ADDRESS
    LEA     DISPLAY_SPACE, A1
    MOVE.B  #14, D0
    TRAP    #15
    JSR     PRINT_DOLLAR
    JMP     HEX_TO_ACII_ADDR    
    RTS                         
*   END:    DISPLAY_ADDRESS
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* HEX TO ASCII Logic for Addr
*----------------------------------------------------------------------------
HEX_TO_ACII_ADDR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVEA.L A5, A1              Take the addr at A5 and put it in A1
    MOVE.L  A1, D6              Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.L  #$F0000000, D1      Move the masking value to D1
      
CONVERSION_LOOP
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L   D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2              IF counter equals terminal value
    BEQ     CONTINUE_DISPLAY   	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     CONVERSION_LOOP     Loop to start of loop
CONTINUE_DISPLAY
	RTS
*   END: DISPLAY_ADDRESS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_DISP_ADDR             Prints the address of displacement
*----------------------------------------------------------------------------
PRINT_DISP_ADDR
    LEA     DISPLAY_SPACE, A1
    MOVE.B  #14, D0
    TRAP    #15
    JSR     PRINT_DOLLAR
    JMP     HEX_TO_ACII_DISPLACEMENT    
    RTS                         
*   END:    PRINT_DISP_ADDR Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* HEX_TO_ACII_DISPLACEMENT Logic: For displaying the displacement Addr 
*----------------------------------------------------------------------------
HEX_TO_ACII_DISPLACEMENT
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.L  D7, D6              Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.L  #$F0000000, D1      Move the masking value to D1
      
DISPLACEMENT_LOOP
    MOVE.L  D6, D5              D5 will hold addr for manipulation
    AND.L   D1, D5              Mask D5 with mask value
    LSR.L   #4, D1              Update the mask to next digit, by shifting 4
    ROL.L   D3, D5              ROL once to bring MSB to LSB
    MOVE.B  D5, D4              Extract the digit
    JSR 	CHECK_CONVERSION    Send the extracted digit for conversion
    MOVE.L  #0,(PRINT_ADDR_CHAR) Initialize addr with 0 for null termination
    MOVE.B  D4,(PRINT_ADDR_CHAR) Print the converted digit
    LEA     PRINT_ADDR_CHAR,A1  |
    MOVE.B  #14,D0              |
    TRAP    #15                 V
    CMPI.B  #8, D2              IF counter equals terminal value
    BEQ     EXIT_DISP_LOOP   	Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     DISPLACEMENT_LOOP   Loop to start of loop
EXIT_DISP_LOOP
	RTS
*   END: PRINT_DISP_ADDR Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   CHECK_CONVERSION Logic
*----------------------------------------------------------------------------
CHECK_CONVERSION 
    CMPI.B	#$9, D4		        D4 stores the single hex value to print
    BGT     CHECK_LETTER        
    ADD.B	#$30,D4		        Add $30 to make it ASCII value_digits
	RTS
	
CHECK_LETTER 
    ADD.B	#$37,D4		        Add $37 to make it ASCII value_upper(A-F)
	RTS	
*   END:    CHECK_CONVERSION
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   INVALID_OPWORD Logic
*----------------------------------------------------------------------------	
INVALID_OPWORD
	LEA 	DISPLAY_DATA, A1    
	MOVE.B 	#14, D0				
	TRAP 	#15
	JSR     PRINT_DOLLAR
    JSR     CLR_DATAREG_D6      Clear all registers before calculation
    MOVE.W  D7, D6              Put addr1's addr into D6, to hold addr value
    MOVE.B  #1, D2              Counter Variable
    MOVE.B  #4, D3              D3 will hold starting shift value, as 4
    MOVE.W  #$F000, D1      	Move the masking value to D1
    
INVALID_LOOP
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
    BEQ     EXIT_LOOP   		Exit the loop
	ADDQ.B	#4, D3       	    Else update shift value to next digit
    ADDQ.B  #1, D2              Counter++
    BRA     INVALID_LOOP     	Loop to start of loop
EXIT_LOOP
	JSR		CLEAR_NEXT_LINE
	JMP 	PRINT_LOGIC
*   END: INVALID_OPWORD Logic
*----------------------------------------------------------------------------
*****************************************************************************
********************************<<RHS PRINT SUBROUTINES>>********************
*****************************************************************************
*----------------------------------------------------------------------------
*   PRINT_Dn_RHS Logic Dn
*----------------------------------------------------------------------------
PRINT_D0_RHS
	LEA		DISPLAY_D0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D1_RHS
	LEA		DISPLAY_D1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D2_RHS
	LEA		DISPLAY_D2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D3_RHS
	LEA		DISPLAY_D3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D4_RHS
	LEA		DISPLAY_D4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D5_RHS
	LEA		DISPLAY_D5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D6_RHS
	LEA		DISPLAY_D6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_D7_RHS
	LEA		DISPLAY_D7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
*   END:    PRINT_Dn_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_An_RHS Logic  An
*----------------------------------------------------------------------------
PRINT_A0_RHS
	LEA		DISPLAY_A0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A1_RHS
	LEA		DISPLAY_A1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A2_RHS
	LEA		DISPLAY_A2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A3_RHS
	LEA		DISPLAY_A3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A4_RHS
	LEA		DISPLAY_A4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A5_RHS
	LEA		DISPLAY_A5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A6_RHS
	LEA		DISPLAY_A6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A7_RHS
	LEA		DISPLAY_A7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
*   END:    PRINT_An_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_AN_P_RHS Logic (An)
*----------------------------------------------------------------------------
PRINT_A0_P_RHS
	LEA		DISPLAY_A0_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A1_P_RHS
	LEA		DISPLAY_A1_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A2_P_RHS
	LEA		DISPLAY_A2_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A3_P_RHS
	LEA		DISPLAY_A3_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A4_P_RHS
	LEA		DISPLAY_A4_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A5_P_RHS
	LEA		DISPLAY_A5_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A6_P_RHS
	LEA		DISPLAY_A6_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A7_P_RHS
	LEA		DISPLAY_A7_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
*   END:    PRINT_AN_P_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_AN_PP_RHS Logic (An)+
*----------------------------------------------------------------------------
PRINT_A0_PP_RHS
	LEA		DISPLAY_A0_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A1_PP_RHS
	LEA		DISPLAY_A1_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A2_PP_RHS
	LEA		DISPLAY_A2_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A3_PP_RHS
	LEA		DISPLAY_A3_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A4_PP_RHS
	LEA		DISPLAY_A4_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A5_PP_RHS
	LEA		DISPLAY_A5_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A6_PP_RHS
	LEA		DISPLAY_A6_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A7_PP_RHS
	LEA		DISPLAY_A7_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
*   END:    PRINT_AN_PP_RHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_AN_PM_RHS Logic -(An)
*----------------------------------------------------------------------------
PRINT_A0_PM_RHS
	LEA		DISPLAY_A0_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A1_PM_RHS
	LEA		DISPLAY_A1_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A2_PM_RHS
	LEA		DISPLAY_A2_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A3_PM_RHS
	LEA		DISPLAY_A3_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A4_PM_RHS
	LEA		DISPLAY_A4_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A5_PM_RHS
	LEA		DISPLAY_A5_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A6_PM_RHS
	LEA		DISPLAY_A6_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
PRINT_A7_PM_RHS
	LEA		DISPLAY_A7_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR		CLEAR_NEXT_LINE
	JMP		PRINT_LOGIC
*   END:    PRINT_AN_PM_RHS Logic
*----------------------------------------------------------------------------
*****************************************************************************
********************************<<LHS PRINT SUBROUTINES>>********************
*****************************************************************************
*----------------------------------------------------------------------------
*   PRINT_Dn_LHS Logic Dn
*----------------------------------------------------------------------------
PRINT_D0_LHS
	LEA		DISPLAY_D0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D1_LHS
	LEA		DISPLAY_D1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D2_LHS
	LEA		DISPLAY_D2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D3_LHS
	LEA		DISPLAY_D3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D4_LHS
	LEA		DISPLAY_D4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D5_LHS
	LEA		DISPLAY_D5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D6_LHS
	LEA		DISPLAY_D6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_D7_LHS
	LEA		DISPLAY_D7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
*   END:    PRINT_Dn_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_An_LHS Logic An
*----------------------------------------------------------------------------
PRINT_A0_LHS
	LEA		DISPLAY_A0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A1_LHS
	LEA		DISPLAY_A1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A2_LHS
	LEA		DISPLAY_A2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A3_LHS
	LEA		DISPLAY_A3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A4_LHS
	LEA		DISPLAY_A4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A5_LHS
	LEA		DISPLAY_A5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A6_LHS
	LEA		DISPLAY_A6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A7_LHS
	LEA		DISPLAY_A7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
*   END:    PRINT_An_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_AN_P_LHS Logic (An)
*----------------------------------------------------------------------------
PRINT_A0_P_LHS
	LEA		DISPLAY_A0_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A1_P_LHS
	LEA		DISPLAY_A1_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A2_P_LHS
	LEA		DISPLAY_A2_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A3_P_LHS
	LEA		DISPLAY_A3_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A4_P_LHS
	LEA		DISPLAY_A4_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A5_P_LHS
	LEA		DISPLAY_A5_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A6_P_LHS
	LEA		DISPLAY_A6_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A7_P_LHS
	LEA		DISPLAY_A7_P, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
*   END:    PRINT_AN_P_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_AN_PP_LHS Logic (An)+
*----------------------------------------------------------------------------
PRINT_A0_PP_LHS
	LEA		DISPLAY_A0_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A1_PP_LHS
	LEA		DISPLAY_A1_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A2_PP_LHS
	LEA		DISPLAY_A2_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A3_PP_LHS
	LEA		DISPLAY_A3_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A4_PP_LHS
	LEA		DISPLAY_A4_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A5_PP_LHS
	LEA		DISPLAY_A5_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A6_PP_LHS
	LEA		DISPLAY_A6_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A7_PP_LHS
	LEA		DISPLAY_A7_PP, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
*   END:    PRINT_AN_PP_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_AN_PM_LHS Logic -(An)
*----------------------------------------------------------------------------
PRINT_A0_PM_LHS
	LEA		DISPLAY_A0_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A1_PM_LHS
	LEA		DISPLAY_A1_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A2_PM_LHS
	LEA		DISPLAY_A2_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A3_PM_LHS
	LEA		DISPLAY_A3_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A4_PM_LHS
	LEA		DISPLAY_A4_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A5_PM_LHS
	LEA		DISPLAY_A5_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A6_PM_LHS
	LEA		DISPLAY_A6_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
PRINT_A7_PM_LHS
	LEA		DISPLAY_A7_PM, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		CHECK_DECODE_RHS
	JMP		PRINT_LOGIC
*   END:    PRINT_AN_P_LHS Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_COUNTER/REGISTER NUMBER_LHS Logic 	Used in ASL/LSL/ROL
*----------------------------------------------------------------------------
PRINT_0_LHS
	LEA		DISPLAY_0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_1_LHS
	LEA		DISPLAY_1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_2_LHS
	LEA		DISPLAY_2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_3_LHS
	LEA		DISPLAY_3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_4_LHS
	LEA		DISPLAY_4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_5_LHS
	LEA		DISPLAY_5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	LEA		DISPLAY_COMMA, A1
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_6_LHS
	LEA		DISPLAY_6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_7_LHS
	LEA		DISPLAY_7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
PRINT_8_LHS
	LEA		DISPLAY_8, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	JSR     PRINT_COMMA
	JMP		DECODE_DATA_REG_RHS_BITS_0TO2
	JMP		PRINT_LOGIC
*   END:    PRINT_COUNTER/REGISTER NUMBER Logic
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*   PRINT_MOVEM__RHS Logic 	Used in MOVEM (ONLY MEMORY TO REGISTER)
*----------------------------------------------------------------------------
PRINT_MOVEM_RHS_D0
	LEA		DISPLAY_D0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_D1
	LEA		DISPLAY_D1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_D2
	LEA		DISPLAY_D2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC	
PRINT_MOVEM_RHS_D3
	LEA		DISPLAY_D3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_D4
	LEA		DISPLAY_D4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_D5
	LEA		DISPLAY_D5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_D6
	LEA		DISPLAY_D6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_D7
	LEA		DISPLAY_D7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A0
	LEA		DISPLAY_A0, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A1
	LEA		DISPLAY_A1, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A2
	LEA		DISPLAY_A2, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A3
	LEA		DISPLAY_A3, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A4
	LEA		DISPLAY_A4, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A5
	LEA		DISPLAY_A5, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A6
	LEA		DISPLAY_A6, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
PRINT_MOVEM_RHS_A7
	LEA		DISPLAY_A7, A1
	MOVE.B 	#14, D0
	TRAP 	#15
	CMP.B	#1,IS_MEM_TO_REG
	BEQ		MOVEM_REGISTER_RHS_LOOP		An/Dn is on RHS (Mem to Reg)
	JMP		MOVEM_REGISTER_LHS_LOOP		An/Dn is on LHS (Reg to Mem)
	JMP		PRINT_LOGIC
*   END:    PRINT_COUNTER/REGISTER NUMBER Logic
*---------------------------------------------------------------------------
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
