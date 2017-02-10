*-----------------------------------------------------------
* Title      :  Test lsl
* Written by :  Joon Jung
* Date       :  03/13/2016
* Description:	Tests for LSL/ASR/ROL/CMP/Bcc(LE,GT,CC)
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

* Put program code here
		MOVE.B #2,D1
		MOVE.B #$A,D2
		MOVE.L #$12349873,D6
		MOVE.L #$FFFF1024,D7
		
*	*CMP & BGT/BLE/BCC
*		CMP.B D0,D1
*		BGT NEXT1
*NEXT1
*		CMP.B D1,D2
*		BLE NEXT2
*NEXT2
*		CMP.B (A0),D6
*		BCC	NEXT3
*NEXT3
*		CMP.B (A1),D7
*		BGT NEXT4
*NEXT4
*		CMP.B (A0)+,D1
*		BLE NEXT5
*NEXT5
		CMP.B (A1)+,D1
		CMP.B -(A0),D1
		CMP.B -(A1),D1
		CMP.B $1234,D2
		CMP.B $FFFFAA00,D2
		*BCC NEXT6
NEXT6
		CMP.B $EECA,D6
		CMP.B $0000C000,D7
		CMP.B #$FF,D1
		CMP.B #$1,D1
		
		
	*CMP.B
		CMP.B D0,D1
		CMP.B D1,D2
		CMP.B (A0),D6
		CMP.B (A1),D7
		CMP.B (A0)+,D1
		CMP.B (A1)+,D1
		CMP.B -(A0),D1
		CMP.B -(A1),D1
		CMP.B $1234,D2
		CMP.B $FFFFAA00,D2
		CMP.B $EECA,D6
		CMP.B $0000C000,D7
		CMP.B #$FF,D1
		CMP.B #$1,D1
	
	*CMP.W
		CMP.W D0,D1
		CMP.W D1,D2
		CMP.W (A0),D6
		CMP.W (A1),D7
		CMP.W (A0)+,D1
		CMP.W (A1)+,D1
		CMP.W -(A0),D1
		CMP.W -(A1),D1
		CMP.W $5668,D2
		CMP.W $FFFFBB00,D2
		CMP.W $BBBA,D6
		CMP.W $0000EEFA,D7
		CMP.W #$CF,D1
		CMP.W #$2,D1
		
	*CMP.L
		CMP.L D0,D1
		CMP.L D1,D2
		CMP.L (A0),D6
		CMP.L (A1),D7
		CMP.L (A0)+,D1
		CMP.L (A1)+,D1
		CMP.L -(A0),D1
		CMP.L -(A1),D1
		CMP.L $8642,D2
		CMP.L $FFFFAAA0,D2
		CMP.L $EECA,D6
		CMP.L $0000AAA0,D7
		CMP.L #$AF,D1
		CMP.L #$3,D1

	*LSL
		LSL.B #2,D0
		LSR.B #2,D0
		LSL.B D1,D0
		
		LSL.W #2,D0
		LSR.W #2,D0
		LSL.W D1,D0

		LSL.L #2,D0
		LSR.L #2,D0
		LSL.L D1,D0
		
		LSL (A1)
		LSL (A2)
		LSL (A1)+
		LSL (A2)+
		LSL -(A1)
		LSL -(A2)
		LSL $2000
		LSL $1222
		LSL $A200
		LSL $FFFF5500
		
	*ASR
		ASR.B #2,D0
		ASL.B #2,D0
		ASR.B D1,D0
		
		ASR.W #2,D0
		ASL.W #2,D0
		ASR.W D1,D0

		ASR.L #2,D0
		ASL.L #2,D0
		ASR.L D1,D0
		
		ASR (A1)
		ASR (A2)
		ASR (A1)+
		ASR (A2)+
		ASR -(A1)
		ASR -(A2)
		ASR $2000
		ASR $1222
		ASR $A200
		ASR $FFFF5500	

	
	*ROL
		ROL.B #2,D0
		ROR.B #2,D0
		ROL.B D1,D0
		
		ROL.W #2,D0
		ROR.W #2,D0
		ROL.W D1,D0

		ROL.L #2,D0
		ROR.L #2,D0
		ROL.L D1,D0
		
		ROL (A1)
		ROL (A2)
		ROL (A1)+
		ROL (A2)+
		ROL -(A1)
		ROL -(A2)
		ROL $2000
		ROL $1222
		ROL $A200
		ROL $FFFF5500

* Put variables and constants here

    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
