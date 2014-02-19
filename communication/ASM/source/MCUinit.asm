;----------------------------------------------------------------------------------------------					
						SUBTITLE "PIC18F4320 initialization"
;----------------------------------------------------------------------------------------------				
MCUinit
;Set all I/O as digital
	MOVLW	B'00001111'
	MOVWF	ADCON1			; All channels are digital I/O
;----------------------------------------------------------------------------------------------	
;SMBus_init 	 
	_SCL_HIGH				; The bus is in idle state
   	_SDA_HIGH				; SDA and SCL are in high level from pull up resistors
;----------------------------------------------------------------------------------------------

	RETURN
