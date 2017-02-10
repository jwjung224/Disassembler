*****************************************************************************
********************************<<FINAL LOGIC>>******************************
*****************************************************************************
*----------------------------------------------------------------------------
* FINAL LOGIC: Check to see if user wants to continue or end program.
*              This logic runs at the end of decompiling.
*              If user selects No, program terminates, ELSE, it restarts. 
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
* FINAL_PROMPT
*----------------------------------------------------------------------------
FINAL
    JSR     CLEAR_NEXT_LINE
    LEA     MSG_FINAL_PROMPT, A1    Load "FINAL_PROMPT" message and display
    MOVE.B  #14,D0                  |
    TRAP    #15                     |
    MOVE.B  #5,D0                   V
    TRAP    #15                     Read a char from the keyboard into D1.B.
    
    CMP.B   #13,D1                  Checking for "ENTER" as an input,
    BEQ     BAD_SELECTION           which is a bad selection
    
    CMP.B   #YES_U, D1              IF equal to 'Y',
    BEQ     INTRO                   Start new session
    CMP.B   #YES_L, D1              IF equal to 'y',
    BEQ     INTRO                   Start new session
    
    CMP.B   #NO_U, D1               IF equal to 'N',  
    BEQ     END_MSG                 Display End Message                             
    CMP.B   #NO_L, D1               IF equal to 'n',
    BEQ     END_MSG                 Display End Message  

BAD_SELECTION
    JSR     CLEAR_NEXT_LINE
    LEA     MSG_INVALID_PROMPT, A1  Load and display invalid prompt message
    MOVE.B  #14,D0                  |
    TRAP    #15                     V
    BRA     FINAL       			Loop back to FINAL
    
END_MSG
    JSR     CLEAR_NEXT_LINE         
    LEA     MSG_ENDPROGRAM, A1      Display End program msg
    MOVE.B  #14,D0                  |
    TRAP    #15                     V
    JMP     END_PROGRAM             Terminate program                   
*   END:    FINAL_PROMPT LOGIC
*-----------------------------------------------------------------------------



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
