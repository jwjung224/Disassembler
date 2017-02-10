*-----------------------------------------------------------------------------
* Title      : Disassembler Project 
* Written by : Team JKR: Joon Jung, Kevin Tan, Ryu Muthui 
* Date       : Start Date 02/13/2016 - End Data 03/13/2016
* Description: CSS422: Computer Hardware and Organization - Final Project
*-----------------------------------------------------------------------------
* Main entry into the program.
* Below are the list of instructions and addressing modes assigned for this project. 
* 
* Effective Addressing Modes:
* Data Register Direct
* Address Register Direct
* Address Register Indirect
* Immediate Data
* Address Register Indirect with Post incrementing
* Address Register Indirect with Pre decrementing
* Absolute Long Address
* Absolute Word Address
*
* Instructions:
* NOP
* MOVE
* MOVEQ
* MOVEM
* ADD
* ADDA
* ADDI
* SUB
* MULS
* DIVU
* LEA
* CLR
* AND
* LSL
* ASR
* ROL
* CMP
* Bcc (BCC, BGT, BLE)
* JSR
* RTS
* Additonal added by us:
* STOP
* SUBI
* ASL
* LSR
* ROR
*----------------------------------------------------------------------------- 
START:  ORG $1000   First line of source code
        INCLUDE     'JKR_STARTING_LOGIC_W16.X68'
        INCLUDE     'JKR_DECIPHER_LOGIC_W16.X68'
        INCLUDE     'JKR_PRINT_LOGIC_W16.X68'
        INCLUDE     'JKR_GET_LOGIC_W16.X68'
        INCLUDE     'JKR_DECODE_LOGIC_W16.X68'
        INCLUDE     'JKR_FINAL_LOGIC_W16.X68'
        INCLUDE     'JKR_VARS_AND_CHARS_W16.X68'
END_PROGRAM
    MOVE.B  #9,D0
    TRAP    #15
    END     START    Final line of source code
*-----------------------------------------------------------------------------



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
