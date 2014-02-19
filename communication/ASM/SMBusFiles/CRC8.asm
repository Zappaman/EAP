;**********************************************************************************************
;						CALCULATION PEC PACKET	
;**********************************************************************************************
;Name:		PEC_calculation
;Function:	Calculates the PEC of received bytes
;Input:		PEC4:PEC3:PEC2:PEC1:PEC0:PEC- data registers
;			CRC4:CRC3:CRC2:CRC1:CRC0:CRC- CRC value=00000107h
;Output:	PEC
;Comments:  Refer to "System Managment BUS(SMBus) specification Version 2.0"
;**********************************************************************************************	
PEC_calculation
	MOVLW	0x07	;|
	MOVWF	CRC		;|	
	MOVLW	0x01	;|
	MOVWF	CRC0	;|
	CLRF	CRC1	; > Load crc value 0x0107
	CLRF	CRC2	;|
	CLRF	CRC3	;|
	CLRF	CRC4	;|
	
	
	MOVLW	d'47'			;
	MOVWF	BitPosition		; 6bytes*8bits=48bits(MSb=47)

;check PEC4 for '1'	
	BTFSC	PEC4,7
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,6
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,5
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,4
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,3
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,2
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,1
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC4,0
	BRA		shift_CRC
	
;check PEC3 for '1'
	DECF	BitPosition
	BTFSC	PEC3,7
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,6
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,5
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,4
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,3
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,2
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,1
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC3,0
	BRA		shift_CRC
	
;check PEC2 for '1'
	DECF	BitPosition
	BTFSC	PEC2,7
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,6
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,5
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,4
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,3
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,2
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,1
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC2,0
	BRA		shift_CRC

;check PEC1 for '1'
	DECF	BitPosition
	BTFSC	PEC1,7
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,6
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,5
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,4
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,3
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,2
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,1
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC1,0
	BRA		shift_CRC
	

;check PEC0 for '1'
	DECF	BitPosition
	BTFSC	PEC0,7
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,6
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,5
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,4
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,3
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,2
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,1
	BRA		shift_CRC
	DECF	BitPosition
	BTFSC	PEC0,0
	BRA		shift_CRC
	
	CLRF	PEC4
	CLRF	PEC3
	CLRF	PEC2
	CLRF	PEC1
	CLRF	PEC0
	RETURN
	
shift_CRC
	MOVLW	d'8'
	SUBWF	BitPosition,W		;BitPosition-8 ->W
	MOVWF	shift				;get shift value for CRC registers
	BCF		STATUS,C
	
shift_loop
	MOVF	shift,F				;read shift to force flag Z
	BZ		xor
	RLCF	CRC,F
	RLCF	CRC0,F
	RLCF	CRC1,F
	RLCF	CRC2,F
	RLCF	CRC3,F
	RLCF	CRC4,F
	DECFSZ	shift,F
	BRA		shift_loop
	
xor 
	MOVF	CRC4,W
	XORWF	PEC4,F
	MOVF	CRC3,W
	XORWF	PEC3,F
	MOVF	CRC2,W
	XORWF	PEC2,F
	MOVF	CRC1,W
	XORWF	PEC1,F
	MOVF	CRC0,W
	XORWF	PEC0,F
	MOVF	CRC,W
	XORWF	PEC,F
	BRA		PEC_calculation
