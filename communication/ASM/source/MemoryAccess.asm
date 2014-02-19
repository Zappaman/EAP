
					SUBTITLE "MLX90614 RAM Memory Access Subroutines"

;**********************************************************************************************
;							Read MLX90614 RAM address subroutine
;**********************************************************************************************
;Name:		MemRead
;Function:	Read specified RAM address of a MLX90614 module
;Input:		SlaveAddress,command=RAM_Address(EE_Address) | RAM_Access(EE_Address)
;Output:	DataH:DataL
;Comments:	Refer to AN "SMBus communication with MLX90614"
;			If receiver doesn’t answer with ACK, the number of the attempts to be send will be  
;			equal  of the unsigned value in Nack_Counter-1 
;**********************************************************************************************
MemRead
	LoadNACKcounter				; Set Nack_Counter
restart
	CALL	STOP_bit			; STOP SMBus communication
	DECF	Nack_Counter,F		; If((Nack_Counter-1) == 0) stop transmission
	BNZ		start				; Else start transmission					
	RETURN						; Go out
	
start			
	CALL	START_bit			; Start SMBus comunication
	
	MOVF	SlaveAddress,W		;|
	MOVWF	TX_buffer			; > Send Slave address(Bit R/-W no meaning)
	CALL	TX_byte				;|

	ANDLW	0x01				; W & 0x01 -> W
	BTFSS	STATUS,Z			; If Slave acknowledge,continue 
	GOTO	restart				; Else restart communication

	MOVF	command,W			;|
	MOVWF	TX_buffer			; > Send Command
	CALL	TX_byte				;|
	
	ANDLW	0x01				; W & 0x01 -> W
	BTFSS	STATUS,Z			; If Slave acknowledge,continue 
	GOTO	restart				; Else restart communication
	
	CALL	START_bit			; Send Repeated START bit
	
	MOVF	SlaveAddress,W		;|
	MOVWF	TX_buffer			; > Send Slave address again(Bit R/-W no meaning)
	CALL	TX_byte				;|
	
	ANDLW	0x01				; W & 0x01 -> W
	BTFSS	STATUS,Z			; If Slave acknowledge,continue 
	GOTO	restart				; Else restart communication
	
	BCF		bit_out				; Master must send acknowledge after this received byte
	CALL	RX_byte				; Receive low data byte
	MOVFF	RX_buffer,DataL		; Save it in DataL
	
	BCF		bit_out				; Master must send acknowledge after this received byte
	CALL	RX_byte				; Receive high data byte
	MOVFF	RX_buffer,DataH		; Save it in DataH
	
	BSF		bit_out				; Master not need to send acknowledge after this received byte
	CALL	RX_byte				; Receive PEC byte
	MOVFF	RX_buffer,PecReg	; Save it in PecReg
	
	CALL	STOP_bit			; Stop SMBus comunication
	
	
	MOVF	SlaveAddress,W		;|
	MOVWF	PEC4				;|
	MOVFF	command,PEC3		;|
    MOVF	SlaveAddress,W		; > Load PEC3:PEC2:PEC1:PEC0:PEC
	MOVWF	PEC2				;|
	MOVFF	DataL,PEC1			;|
	MOVFF	DataH,PEC0			;|
	CLRF	PEC					;|
	
	CALL	PEC_calculation		; Result is in PEC
	MOVF	PecReg,W			; PecReg -> WREG
	XORWF	PEC,W				; PEC xor WREG ->WREG
	BTFSS	STATUS,Z			; If PEC=PecReg go out
	GOTO	restart				; Else repeat all transmission
	
	RETURN


	
