*-----------------------------------------------------------
* Title      :  Test other
* Written by :  Joon Jung
* Date       :  03/13/2016
* Description:  test MULS/LEA/AND/CLR
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program
		MOVE.L #$0034,D2
		MOVE.L #$0020,D3
		
	*MULS
		MULS.W D0,D1
		MULS.W D2,D3
		
		MULS.W (A1),D0
		MULS.W (A2),D2
		
		MULS.W (A1)+,D0
		MULS.W (A2)+,D2
		
		MULS.W -(A1),D0
		MULS.W -(A2),D2
		
		MULS.W $500,D0
		MULS.W $200,D2
		
		MULS.W $A204,D0
		MULS.W $FFFF5000,D2
	
		MULS.W #$50,D0
		MULS.W #$700,D2
									
		
	*CLR.L
		CLR.L D2
		CLR.L D3
		CLR.L (A0)
		CLR.L (A1)
		CLR.L -(A2)
		CLR.L -(A3)
		CLR.L (A2)+
		CLR.L (A3)+
		CLR.L $6910
		CLR.L $02A2
		CLR.L $A1942BE4
		CLR.L $000A00A0		
		
		
		MOVE.W #$5000,D0
		MOVE.W #$2000,D1
		MOVE.W #$4000,D2
		MOVE.W #$0020,D3
		MOVE.W #$2000,(A1)
		MOVE.W #$1000,(A2)
		
	*DIVU
		DIVU.W D0,D1
		DIVU.W D2,D3
		
		DIVU.W (A1),D1
		DIVU.W (A2),D3
		
		DIVU.W (A1)+,D5
		DIVU.W (A2)+,D6
		
		DIVU.W -(A1),D5
		DIVU.W -(A2),D6
		
		DIVU.W $500,D0
		DIVU.W $200,D2
		
		DIVU.W $A204,D0
		DIVU.W $FFFF5000,D2
	
		DIVU.W #$50,D0
		DIVU.W #$700,D2

	
	*LEA
		LEA	(A0),A1
		LEA	(A2),A3
		LEA	$00006500,A4
		LEA	$1010,A5
		LEA	$0000AA02,A6
		LEA	$FFFF2102,A7
		
	*CLR.B
		CLR.B D0
		CLR.B D1
		CLR.B (A0)
		CLR.B (A1)
		CLR.B (A2)+
		CLR.B (A3)+
		CLR.B -(A2)
		CLR.B -(A3)
		CLR.B $6910
		CLR.B $02A2
		CLR.B $A1942BE2
		CLR.B $000A00A0
		
	*CLR.W
		CLR.W D0
		CLR.W D1
		CLR.W (A0)
		CLR.W (A1)
		CLR.W -(A2)
		CLR.W -(A3)		
		CLR.W (A2)+
		CLR.W (A3)+
		CLR.W $6910
		CLR.W $02A2
		CLR.W $A1942BE0
		CLR.W $000A00A0		
		
	*CLR.L
		CLR.L D2
		CLR.L D3
		CLR.L (A0)
		CLR.L (A1)
		CLR.L -(A2)
		CLR.L -(A3)
		CLR.L (A2)+
		CLR.L (A3)+
		CLR.L $6910
		CLR.L $02A2
		CLR.L $A1942BE4
		CLR.L $000A00A0
		
	*AND.B	
		AND.B D0,D7
		AND.B D1,D6
		AND.B D2,D5
		AND.B D3,D4

		AND.B (A1),D0
		AND.B (A2),D1
		AND.B (A3),D2
		AND.B (A4),D3
		
		AND.B (A1)+,D4
		AND.B (A2)+,D5
		AND.B (A3)+,D6
		AND.B (A4)+,D7
		
		AND.B -(A1),D0
		AND.B -(A2),D1
		AND.B -(A3),D2
		AND.B -(A4),D3
		
		AND.B	$1020,D0
		AND.B	$1800,D1
		AND.B	$FFFF8500,D2
		AND.B	$FFFFA200,D3
		
		AND.B	$0000A030,D4
		AND.B	$00031810,D5
		AND.B	$FFFF2580,D6
		AND.B	$F0000210,D7
		
		AND.B	#$E2,D4
		AND.B	#$42,D5
		AND.B	#$F4,D6
		AND.B	#$CD,D7
		
		AND.B	D0,(A0)
		AND.B	D1,(A1)
		AND.B	D2,(A2)
		AND.B	D3,(A3)
		
		AND.B	D4,(A4)+
		AND.B	D5,(A5)+
		AND.B	D6,(A6)+
		AND.B	D7,(A7)+
		
		AND.B	D4,-(A4)
		AND.B	D5,-(A5)
		AND.B	D6,-(A6)
		AND.B	D7,-(A7)

		AND.B	D0,$1020
		AND.B	D1,$1800
		AND.B	D2,$FFFF8500
		AND.B	D3,$FFFFA200
		
		AND.B	D4,$0000A030
		AND.B	D5,$00031810
		AND.B	D6,$FFFF2580
		AND.B	D7,$F0000210		

		
	*AND.W	
		AND.W	D0,D7
		AND.W	D1,D6
		AND.W	D2,D5
		AND.W	D3,D4
		AND.W	D4,D3
		AND.W	D5,D2
		AND.W	D6,D1
		AND.W	D7,D0

		AND.W	(A1),D0
		AND.W	(A2),D1
		AND.W	(A3),D2
		AND.W	(A4),D3
		
		AND.W	(A1)+,D4
		AND.W	(A2)+,D5
		AND.W	(A3)+,D6
		AND.W	(A4)+,D7
		
		AND.W	-(A1),D0
		AND.W	-(A2),D1
		AND.W	-(A3),D2
		AND.W	-(A4),D3
		
		AND.W	$1020,D0
		AND.W	$1800,D1
		AND.W	$FFFF8500,D2
		AND.W	$FFFFA200,D3
		
		AND.W	$00AA1030,D4
		AND.W	$00231810,D5
		AND.W	$FFFF2580,D6
		AND.W	$F0000210,D7
		
		AND.W	#$12E2,D4
		AND.W	#$4542,D5
		AND.W	#$77F4,D6
		AND.W	#$FFCD,D7		
		
		AND.W	D0,(A0)
		AND.W	D1,(A1)
		AND.W	D2,(A2)
		AND.W	D3,(A3)

		AND.W	D4,(A4)+
		AND.W	D5,(A5)+
		AND.W	D6,(A6)+
		AND.W	D7,(A7)+
		
		AND.W	D4,-(A4)
		AND.W	D5,-(A5)
		AND.W	D6,-(A6)
		AND.W	D7,-(A7)
		
		AND.W	D0,$1020
		AND.W	D1,$1800
		AND.W	D2,$FFFF8500
		AND.W	D3,$FFFFA200
		
		AND.W	D4,$0000A030
		AND.W	D5,$00031810
		AND.W	D6,$FFFF2580
		AND.W	D7,$F0000210		
	
	
	*AND.L		
		AND.L	D0,D7
		AND.L	D1,D6
		AND.L	D2,D5
		AND.L	D3,D4
		AND.L	D4,D3
		AND.L	D5,D2
		AND.L	D6,D1
		AND.L	D7,D0

		AND.L	(A1),D0
		AND.L	(A2),D1
		AND.L	(A3),D2
		AND.L	(A4),D3
		
		AND.L	(A1)+,D4
		AND.L	(A2)+,D5
		AND.L	(A3)+,D6
		AND.L	(A4)+,D7
		
		AND.L	-(A1),D0
		AND.L	-(A2),D1
		AND.L	-(A3),D2
		AND.L	-(A4),D3
		
		AND.L	$1020,D0
		AND.L	$1800,D1
		AND.L	$FFFF8500,D2
		AND.L	$FFFFA200,D3
		
		AND.L	$00AA1030,D4
		AND.L	$00231810,D5
		AND.L	$FFFF2580,D6
		AND.L	$F0000210,D7
		
		AND.L	#$001203E2,D4
		AND.L	#$20042242,D5
		AND.L	#$12FFFFF4,D6
		AND.L	#$FFCC23CD,D7

		AND.L	D0,(A0)
		AND.L	D1,(A1)
		AND.L	D2,(A2)
		AND.L	D3,(A3)

		AND.L	D4,(A4)+
		AND.L	D5,(A5)+
		AND.L	D6,(A6)+
		AND.L	D7,(A7)+
		
		AND.L	D4,-(A4)
		AND.L	D5,-(A5)
		AND.L	D6,-(A6)
		AND.L	D7,-(A7)

		AND.L	D0,$1020
		AND.L	D1,$1800
		AND.L	D2,$FFFF8500
		AND.L	D3,$FFFFA200
		
		AND.L	D4,$0000A030
		AND.L	D5,$00031810
		AND.L	D6,$FFFF2580
		AND.L	D7,$F0000210	

		MOVE.L #$0000126C,(A7)
		JSR	(A7)
		*JSR $00001268
		JSR COME
		
		
COME
		RTS

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
