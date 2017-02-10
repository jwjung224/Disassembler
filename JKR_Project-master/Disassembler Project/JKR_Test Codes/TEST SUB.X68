*-----------------------------------------------------------
* Title      :  Test sub
* Written by :  Joon Jung
* Date       :  03/13/2016
* Description:  Test SUB
*-----------------------------------------------------------
    ORG    $7000
START:                  ; first instruction of program

* Put program code here

	*SUB.B	
		SUB.B	D0,D7
		SUB.B	D1,D6
		SUB.B	D2,D5
		SUB.B	D3,D4

		
		SUB.B	(A1),D0
		SUB.B	(A2),D1
		SUB.B	(A3),D2
		SUB.B	(A4),D3
		
		SUB.B	(A1)+,D4
		SUB.B	(A2)+,D5
		SUB.B	(A3)+,D6
		SUB.B	(A4)+,D7
		
		SUB.B	-(A1),D0
		SUB.B	-(A2),D1
		SUB.B	-(A3),D2
		SUB.B	-(A4),D3
		
		SUB.B	$1020,D0
		SUB.B	$1800,D1
		SUB.B	$FFFF8500,D2
		SUB.B	$FFFFA200,D3
		
		SUB.B	$0000A030,D4
		SUB.B	$00031810,D5
		SUB.B	$FFFF2580,D6
		SUB.B	$F0000210,D7
		
		SUB.B	#$E2,D4
		SUB.B	#$42,D5
		SUB.B	#$F4,D6
		SUB.B	#$CD,D7
		
		SUB.B	D0,(A0)
		SUB.B	D1,(A1)
		SUB.B	D2,(A2)
		SUB.B	D3,(A3)
		
		SUB.B	D4,(A4)+
		SUB.B	D5,(A5)+
		SUB.B	D6,(A6)+
		SUB.B	D7,(A7)+
		
		SUB.B	D4,-(A4)
		SUB.B	D5,-(A5)
		SUB.B	D6,-(A6)
		SUB.B	D7,-(A7)

		SUB.B	D0,$1020
		SUB.B	D1,$1800
		SUB.B	D2,$FFFF8500
		SUB.B	D3,$FFFFA200
		
		SUB.B	D4,$0000A030
		SUB.B	D5,$00031810
		SUB.B	D6,$FFFF2580
		SUB.B	D7,$F0000210		
		
		
		
	*SUB.W	
		SUB.W	D0,D7
		SUB.W	D1,D6
		SUB.W	D2,D5
		SUB.W	D3,D4
		SUB.W	D4,D3
		SUB.W	D5,D2
		SUB.W	D6,D1
		SUB.W	D7,D0
		
		SUB.W	A4,D3
		SUB.W	A5,D2
		SUB.W	A6,D1
		SUB.W	A7,D0
		
		SUB.W	(A1),D0
		SUB.W	(A2),D1
		SUB.W	(A3),D2
		SUB.W	(A4),D3
		
		SUB.W	(A1)+,D4
		SUB.W	(A2)+,D5
		SUB.W	(A3)+,D6
		SUB.W	(A4)+,D7
		
		SUB.W	-(A1),D0
		SUB.W	-(A2),D1
		SUB.W	-(A3),D2
		SUB.W	-(A4),D3
		
		SUB.W	$1020,D0
		SUB.W	$1800,D1
		SUB.W	$FFFF8500,D2
		SUB.W	$FFFFA200,D3
		
		SUB.W	$00AA1030,D4
		SUB.W	$00231810,D5
		SUB.W	$FFFF2580,D6
		SUB.W	$F0000210,D7
		
		SUB.W	#$EEE2,D4
		SUB.W	#$AA42,D5
		SUB.W	#$12F4,D6
		SUB.W	#$83CD,D7		
		
		SUB.W	D0,(A0)
		SUB.W	D1,(A1)
		SUB.W	D2,(A2)
		SUB.W	D3,(A3)

		SUB.W	D4,(A4)+
		SUB.W	D5,(A5)+
		SUB.W	D6,(A6)+
		SUB.W	D7,(A7)+
		
		SUB.W	D4,-(A4)
		SUB.W	D5,-(A5)
		SUB.W	D6,-(A6)
		SUB.W	D7,-(A7)

		SUB.W	D0,$1020
		SUB.W	D1,$1800
		SUB.W	D2,$FFFF8500
		SUB.W	D3,$FFFFA200
		
		SUB.W	D4,$0000A030
		SUB.W	D5,$00031810
		SUB.W	D6,$FFFF2580
		SUB.W	D7,$F0000210		
		
		
	*SUB.L
		SUB.L	D0,D7
		SUB.L	D1,D6
		SUB.L	D2,D5
		SUB.L	D3,D4
		SUB.L	D4,D3
		SUB.L	D5,D2
		SUB.L	D6,D1
		SUB.L	D7,D0
		
		SUB.L	A4,D3
		SUB.L	A5,D2
		SUB.L	A6,D1
		SUB.L	A7,D0
		
		SUB.L	(A1),D0
		SUB.L	(A2),D1
		SUB.L	(A3),D2
		SUB.L	(A4),D3
		
		SUB.L	(A1)+,D4
		SUB.L	(A2)+,D5
		SUB.L	(A3)+,D6
		SUB.L	(A4)+,D7
		
		SUB.L	-(A1),D0
		SUB.L	-(A2),D1
		SUB.L	-(A3),D2
		SUB.L	-(A4),D3
		
		SUB.L	$1020,D0
		SUB.L	$1800,D1
		SUB.L	$FFFF8500,D2
		SUB.L	$FFFFA200,D3
		
		SUB.L	$00AA1030,D4
		SUB.L	$00231810,D5
		SUB.L	$FFFF2580,D6
		SUB.L	$F0000210,D7
		
		SUB.L	#$EEE2,D4
		SUB.L	#$AA42,D5
		SUB.L	#$12F4,D6
		SUB.L	#$83CD,D7

		SUB.L	D0,(A0)
		SUB.L	D1,(A1)
		SUB.L	D2,(A2)
		SUB.L	D3,(A3)

		SUB.L	D4,(A4)+
		SUB.L	D5,(A5)+
		SUB.L	D6,(A6)+
		SUB.L	D7,(A7)+
		
		SUB.L	D4,-(A4)
		SUB.L	D5,-(A5)
		SUB.L	D6,-(A6)
		SUB.L	D7,-(A7)

		SUB.L	D0,$1020
		SUB.L	D1,$1800
		SUB.L	D2,$FFFF8500
		SUB.L	D3,$FFFFA200
		
		SUB.L	D4,$0000A030
		SUB.L	D5,$00031810
		SUB.L	D6,$FFFF2580
		SUB.L	D7,$F0000210		
		

		
* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
