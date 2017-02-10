*-----------------------------------------------------------
* Title      :  Test rotation
* Written by :  Joon Jung
* Date       :  03/13/2016
* Description:  Tests file for rotation cases W16
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program
		LSL.B	D1,D2
		LSR.W	D1,D3
		ASL.W	D0,D1
		ASR.W	D7,D2
		ROL.L	D4,D2
		LSL.W	#3,D2
		LSR.L	#7,D3
		ASL.B	#8,D1
		ASR.L	#2,D2
		ROL.B	D7,D2
		ROR.L	D1,D6
		ROR.B	D3,D6
		
		ROL		$FFFF6000
		ROR		$FFFF8233
		ASR		$00008000
		LSR		$2021023
		LSL		$5034
		ASL		$FF0234
		
		LSL.L	#5,D2
		LSR		D1,D3
		ASL.W	D0,D1
		ASR.W	D7,D4
		ROL		D4,D2
		LSL.L	#3,D6
		LSR.L	#7,D3
		ASL.W	#8,D1
		ASR.W	#2,D2
		ROL.L	D7,D0
		ROR		D1,D4
		ROR.W	D2,D3
		CMP.L	#$50000, D5		
		CMP.B	#12, D2
		CMP.W	#1000, D3
		CMP.L	#4300, D4
		CMP.W	#$1235, D5
		CMP.B	D1,D2
		CLR.L	D0
		CLR.B	D1
		CMP.B	(A1),D2
		CMP.B	(A1)+,D2
		CMP.B	-(A1),D2
		CMP.B	$6000,D2
		CMP.B	$00A05999,D2
		CLR.B	D0
		CLR.W	$4ABCD
		CLR.W	D0
		CLR.W	$AB5000
		CLR.W	(A2)
		CLR.B	D5
		CLR.L	$2302
		CLR.L	(A1)+
		CLR.B	D4
		CMP.B	D1,D2
		CLR.W	-(A0)
		CLR.L	-(A5)
		CLR.W	-(A6)
		CLR.L	-(A3)
		CLR.L	-(A4)

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
