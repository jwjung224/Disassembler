*****************************************************************************
********************************<<VARS_AND_CHARS>>***************************
*****************************************************************************
*----------------------------------------------------------------------------
* VARS_AND_CHARS: Decloration of Variables and Constants used in the program.
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* Variables:
*----------------------------------------------------------------------------
CR                  EQU     $0D     ASCII code for Carriage Return
LF                  EQU     $0A     ASCII code for Line Feed   
YES_U               EQU     $59     ASCII code for 'Y' 
YES_L               EQU     $79     ASCII code for 'y'
NO_U                EQU     $4E     ASCII code for 'N'  
NO_L                EQU     $6E     ASCII code for 'n'
START_ADDRESS	    EQU		$6000   Store start addr at this memory addr
END_ADDRESS         EQU	    $6010   Store end addr at this memory addr
PRINT_COUNTER		EQU 	$6020   Stores the print count
PRINT_ADDR_CHAR		EQU 	$6022	Used for displaying address 1 char at a time
SHIFT_1_BITS		EQU		1		# bits to shift
SHIFT_4_BITS		EQU		4		# bits to shift
SHIFT_5_BITS		EQU		5		# bits to shift
SHIFT_6_BITS		EQU		6		# bits to shift
SHIFT_7_BITS		EQU		7		# bits to shift
SHIFT_8_BITS		EQU		8		# bits to shift
SHIFT_10_BITS       EQU     10      # bits to shift
SHIFT_11_BITS       EQU     11      # bits to shift
SHIFT_12_BITS       EQU     12      # bits to shift
SHIFT_13_BITS       EQU     13      # bits to shift
SHIFT_14_BITS       EQU     14      # bits to shift
SHIFT_15_BITS       EQU     15      # bits to shift
SHIFT_16_BITS       EQU     16      # bits to shift
VAR_BCC             EQU     %00000100
VAR_BGT             EQU     %00001110
VAR_BLE             EQU     %00001111
VAR_CLRB			EQU 	%00001000
VAR_CLRW			EQU 	%00001001
VAR_CLRL			EQU 	%00001010
VAR_CMPB			EQU 	%00000000
VAR_CMPW			EQU 	%00000001
VAR_CMPL			EQU 	%00000010
VAR_JSR				EQU		%00111010
VAR_LEA             EQU     %00000111
VAR_MOVEMW			EQU		%0010
VAR_MOVEML			EQU		%0011
VAR_ASR_RS_BITS 	EQU		%0000
VAR_LSL_RS_BITS 	EQU		%0001
VAR_ROL_RS_BITS 	EQU		%0011
VAR_MULS			EQU		%0111
VAR_DIVU			EQU		%0011
VAR_MOVEQ			EQU		%0000
LOOP_COUNTER		EQU		$6026
IS_DNTOEA           EQU     $6100
IS_EATODN           EQU     $6102
IS_CMP				EQU		$6030
IS_BYTE				EQU		$6032
IS_WORD				EQU		$6034
IS_LONG				EQU		$6036
IS_LEA              EQU     $6038
IS_MOVE             EQU     $6040
IS_MULS				EQU		$6042
IS_DIVU				EQU		$6044
IS_MOVEQ			EQU		$6046
IS_MOVEM			EQU		$6048
IS_STOP             EQU     $6050
IS_ADDB             EQU     $6052
IS_ADDA             EQU     $6054
IS_ADDI             EQU     $6056
IS_ADDW             EQU     $6058
IS_ADDL             EQU     $6060
IS_ANDB             EQU     $6062
IS_ANDW             EQU     $6064
IS_ANDL             EQU     $6066
IS_SUBI             EQU     $6068
IS_SUBB             EQU     $6070
IS_SUBW             EQU     $6072
IS_SUBL             EQU     $6074
IS_MEM_TO_REG		EQU		$6076
IS_MOVEM_EA_REG		EQU		$6078
IS_MINUSADDR		EQU		$6080
IS_IMMEDIATE_DATA	EQU		$6082
IS_LEFT				EQU		$6084

* Data Storage
DATA_8BITS			EQU		$60A0

*----------------------------------------------------------------------------
* Constants:
*----------------------------------------------------------------------------
* MESSAGE VARIABLES
STARTADDRESS_PROMPT DC.B ' Enter START Address in Hex: ',0
ENDADDRESS_PROMPT   DC.B ' Enter END Address in Hex: ',0
MSG_WELCOME		    DC.B ' WELCOME TO TEAM JKR PROJECT ',CR,LF,0
MSG_INVALID_ENTRY   DC.B ' Invalid Entry: Inupt 0-9, A-F, a-f only.',CR,LF,0
MSG_INVALID_LENGTH  DC.B ' Invalid Length: Address length must be between 1~8 chars long. ',CR,LF,0
MSG_INVALID_ADDRESS DC.B ' Invalid Address: END Address can not be <= to the START address! ',CR,LF,0
MSG_INVALID_ODDADDR DC.B ' Invalid Address: START Adress can not be ODD! ',CR,LF,0
MSG_DECODE          DC.B ' Valid Addresses received, begin decompiling! ',CR,LF,0   
MSG_FINAL_PROMPT    DC.B ' Would you like to continue? (Y/N): ',0
MSG_ENDPROGRAM      DC.B ' Program Terminated! ',0
MSG_INVALID_PROMPT  DC.B ' Invalid Selection: Enter (Y,y || N,n) only. ',CR,LF,0
PRESS_ENTER_PROMPT  DC.B ' Press Enter to continue printing: ',0
CLEAR_LINE          DC.B ' ',CR,LF,0
DISPLAY_SPACE       DC.B ' ',0

* Special Chars
DISPLAY_DOLLAR		DC.B '$',0
DISPLAY_HASH      	DC.B '#',0
DISPLAY_COMMA     	DC.B ',',0
DISPLAY_SLASH		DC.B '/',0

* Single Char       Used in ASR/LSL/ROL
DISPLAY_D			DC.B 'D',0
DISPLAY_R			DC.B 'R',0
DISPLAY_B			DC.B 'B',0
DISPLAY_W			DC.B 'W',0
DISPLAY_L			DC.B 'L',0
DISPLAY_DOT_B		DC.B '.B ',0
DISPLAY_DOT_W		DC.B '.W ',0
DISPLAY_DOT_L		DC.B '.L ',0

* Opcode Words
DISPLAY_LEA        	DC.B '      LEA ',0
DISPLAY_RTS        	DC.B '      RTS ',0
DISPLAY_JSR        	DC.B '      JSR ',0
DISPLAY_NOP        	DC.B '      NOP ',0
DISPLAY_STOP        DC.B '      STOP ',0
DISPLAY_DATA		DC.B '      DATA ',0

DISPLAY_CLRB        DC.B '      CLR.B ',0
DISPLAY_CLRW        DC.B '      CLR.W ',0
DISPLAY_CLRL        DC.B '      CLR.L ',0

DISPLAY_MOVEB		DC.B '      MOVE.B ',0
DISPLAY_MOVEW		DC.B '      MOVE.W ',0
DISPLAY_MOVEL		DC.B '      MOVE.L ',0
DISPLAY_MOVEQL		DC.B '      MOVEQ.L ',0
DISPLAY_MOVEMW		DC.B '      MOVEM.W ',0
DISPLAY_MOVEML		DC.B '      MOVEM.L ',0

DISPLAY_ADDB		DC.B '      ADD.B ',0
DISPLAY_ADDW		DC.B '      ADD.W ',0
DISPLAY_ADDL		DC.B '      ADD.L ',0

DISPLAY_ADDAW		DC.B '      ADDA.W ',0
DISPLAY_ADDAL		DC.B '      ADDA.L ',0

DISPLAY_ADDIB		DC.B '      ADDI.B ',0
DISPLAY_ADDIW		DC.B '      ADDI.W ',0
DISPLAY_ADDIL		DC.B '      ADDI.L ',0

DISPLAY_SUBIB		DC.B '      SUBI.B ',0
DISPLAY_SUBIW		DC.B '      SUBI.W ',0
DISPLAY_SUBIL		DC.B '      SUBI.L ',0

DISPLAY_ANDB		DC.B '      AND.B ',0
DISPLAY_ANDW		DC.B '      AND.W ',0
DISPLAY_ANDL		DC.B '      AND.L ',0

DISPLAY_AS			DC.B '      AS',0
DISPLAY_ASR			DC.B '      ASR ',0

DISPLAY_LS			DC.B '      LS',0
DISPLAY_LSL			DC.B '      LSL ',0

DISPLAY_RO			DC.B '      RO',0
DISPLAY_ROL			DC.B '      ROL ',0

DISPLAY_CMPB		DC.B '      CMP.B ',0
DISPLAY_CMPW		DC.B '      CMP.W ',0
DISPLAY_CMPL		DC.B '      CMP.L ',0

DISPLAY_SUBB		DC.B '      SUB.B ',0
DISPLAY_SUBW		DC.B '      SUB.W ',0
DISPLAY_SUBL		DC.B '      SUB.L ',0

DISPLAY_MULS		DC.B '      MULS.W ',0
DISPLAY_DIVU		DC.B '      DIVU.W ',0

DISPLAY_BCC			DC.B '      BCC ',0
DISPLAY_BGT			DC.B '      BGT ',0
DISPLAY_BLE			DC.B '      BLE ',0

* Data Registers
DISPLAY_D0			DC.B 'D0',0
DISPLAY_D1			DC.B 'D1',0
DISPLAY_D2			DC.B 'D2',0
DISPLAY_D3			DC.B 'D3',0
DISPLAY_D4			DC.B 'D4',0
DISPLAY_D5			DC.B 'D5',0
DISPLAY_D6			DC.B 'D6',0
DISPLAY_D7			DC.B 'D7',0

* Addr Registers
DISPLAY_A0			DC.B 'A0',0
DISPLAY_A1			DC.B 'A1',0
DISPLAY_A2			DC.B 'A2',0
DISPLAY_A3			DC.B 'A3',0
DISPLAY_A4			DC.B 'A4',0
DISPLAY_A5			DC.B 'A5',0
DISPLAY_A6			DC.B 'A6',0
DISPLAY_A7			DC.B 'A7',0

* Addr Registers w/P
DISPLAY_A0_P		DC.B '(A0)',0
DISPLAY_A1_P		DC.B '(A1)',0
DISPLAY_A2_P		DC.B '(A2)',0
DISPLAY_A3_P		DC.B '(A3)',0
DISPLAY_A4_P		DC.B '(A4)',0
DISPLAY_A5_P		DC.B '(A5)',0
DISPLAY_A6_P		DC.B '(A6)',0
DISPLAY_A7_P		DC.B '(A7)',0

* Addr Registers w/P+
DISPLAY_A0_PP		DC.B '(A0)+',0
DISPLAY_A1_PP		DC.B '(A1)+',0
DISPLAY_A2_PP		DC.B '(A2)+',0
DISPLAY_A3_PP		DC.B '(A3)+',0
DISPLAY_A4_PP		DC.B '(A4)+',0
DISPLAY_A5_PP		DC.B '(A5)+',0
DISPLAY_A6_PP		DC.B '(A6)+',0
DISPLAY_A7_PP		DC.B '(A7)+',0

* Addr Registers w/P-
DISPLAY_A0_PM		DC.B '-(A0)',0
DISPLAY_A1_PM		DC.B '-(A1)',0
DISPLAY_A2_PM		DC.B '-(A2)',0
DISPLAY_A3_PM		DC.B '-(A3)',0
DISPLAY_A4_PM		DC.B '-(A4)',0
DISPLAY_A5_PM		DC.B '-(A5)',0
DISPLAY_A6_PM		DC.B '-(A6)',0
DISPLAY_A7_PM		DC.B '-(A7)',0

* NUMBER 0 - 8
DISPLAY_0			DC.B '0',0
DISPLAY_1			DC.B '1',0
DISPLAY_2			DC.B '2',0
DISPLAY_3			DC.B '3',0
DISPLAY_4			DC.B '4',0
DISPLAY_5			DC.B '5',0
DISPLAY_6			DC.B '6',0
DISPLAY_7			DC.B '7',0
DISPLAY_8			DC.B '8',0
BUFFER              DS.W  1   *Buffer to ensure last line of code is even
* END:      VARS_AND_CHARS Logic
*----------------------------------------------------------------------------
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
