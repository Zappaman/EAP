;********************************************************************************************** 				
						SUBTITLE	"SMBus Comunication Subroutines"  
;**********************************************************************************************
;**********************************************************************************************
;									START CONDITION ON SMBus	
;**********************************************************************************************
;Name:		START_bit
;Function:	Generate START condition on SMBus
;Input:		No
;Output:	No
;Comments:  Refer to "System Managment BUS(SMBus) specification Version 2.0" and
;			AN "SMBus communication with MLX90614"
;**********************************************************************************************
START_bit
	
	_SDA_HIGH			;Set SDA line
	MOVLW 	TBUF		;Wait a few us
	CALL  	delay		;
	_SCL_HIGH			;Set SCL line
	
	MOVLW 	TBUF		;Generate bus free time between Stop
	CALL  	delay		;and Start condition (Tbuf=4.7us min)
		
	_SDA_LOW			;Clear SDA line
	MOVLW 	TBUF		;Hold time after (Repeated) Start
    CALL  	delay		;Condition. After this period, the first clock is generated.
    					;(Thd:sta=4.0us min)
    _SCL_LOW			;Clear SCL line
	MOVLW	TBUF		;
	CALL	delay		;Wait	
										
    RETURN													
;**********************************************************************************************
;									STOP CONDITION ON SMBus	
;**********************************************************************************************
;Name:		STOPbit
;Function:	Generate STOP condition on SMBus
;Input:		No
;Output:	No
;Comments:  Refer to "System Managment BUS(SMBus) specification Version 2.0" and
;			AN "SMBus communication with MLX90614"
;**********************************************************************************************	
STOP_bit

	_SCL_LOW				;Clear SCL line
	MOVLW 	TBUF			;Wait a few microseconds
	CALL  	delay			;
	_SDA_LOW				;Clear SDA line
	
	MOVLW	TBUF			;
	CALL	delay			;Wait
	
	_SCL_HIGH				;Set SCL line			
	MOVLW	TBUF	    	;Stop condition setup time 
	CALL	delay	    	;(Tsu:sto=4.0us min)
	_SDA_HIGH				;Set SDA line
	
	
	RETURN													
;**********************************************************************************************
;									TRANSMIT DATA ON SMBus	
;**********************************************************************************************
;Name:		TX_byte
;Function:	Send a byte on SMBus
;Input:		TX_buffer
;Output:	WREG - contains acknowledge value, 0 for ACK and 1 for NACK
;Comments:   
;**********************************************************************************************
TX_byte
	MOVWF	TX_buffer
	MOVLW	D'8'
	MOVWF	Bit_counter			; Load Bit_counter
tx_loop
	BCF		bit_out				; 0 -> bit_out
	RLCF	TX_buffer,F			; Tx_buffer<MSb> -> C
	BTFSC	STATUS,C			; C is 0 or 1?	If C=0 don’t set bit_out
	BSF		bit_out				; 1 -> bit_out
	CALL	Send_bit			; Send bit_out	 on SDA line
	DECFSZ	Bit_counter,F		; All 8th bits are sent? If not, send next bit ,else check for 
              				    ; acknowledgement from the receiver
	GOTO	tx_loop				; Send next bit
	CALL	Receive_bit			; Check for acknowledgement from the receiver
	BTFSS	bit_in				; Receiver send ACK?
	RETLW 	0					; Yes,return 0
	RETLW	1					; No ,return 1

;----------------------------------------------------------------------------------------------    
Send_bit
 	BTFSC	bit_out				;|
 	GOTO	bit_high			;|
 	_SDA_LOW					;|	
 	GOTO	clock				; > Send bit on SDA line
bit_high						;|
	 _SDA_HIGH					;|
	NOP							;|
clock							
	_SCL_HIGH					;|
	NOP							;|
	NOP							;|
	NOP							;|
	NOP							;|
	NOP							;|
	NOP							;|
	NOP							;|
	NOP							; > Send clock pulse
	NOP							;|
	NOP							;|
	NOP							;|
	NOP							;| 
	NOP							;|
	_SCL_LOW					;|
	NOP							;|
	NOP							;|
	RETURN	
;**********************************************************************************************
;									RECEIVE DATA ON SMBus	
;**********************************************************************************************
;Name:		RX_byte
;Function:	Receive a byte on SMBus
;Input:		No
;Output:	RX_buffer(Received byte),bit_in(acknowledge bit)
;Comments:  
;**********************************************************************************************
RX_byte
	CLRF	RX_buffer		;Clear the receiving buffer
	MOVLW	D'8'
	MOVWF	Bit_counter		;Load Bit_counter
	BCF		STATUS,C		;C=0
RX_again
	RLCF	RX_buffer,F		;RX_buffer< MSb> -> C
	CALL	Receive_bit		;Check bit on SDA line	
	BTFSC	bit_in			;If received bit is ‘1’ set RX_buffer<LSb>
	BSF		RX_buffer,0		;Set RX_buffer<LSb>
	DECFSZ	Bit_counter,F	;ALL 8th bis are received? If no receive next bit
	GOTO	RX_again		;Receive next bit
	CALL	Send_bit		;Send NACK or ACK
	RETURN					;End of “RX_byte”
;----------------------------------------------------------------------------------------------	
Receive_bit
	BSF		bit_in			;Set bit_in
	BSF		_SDA_IO			;Make SDA-input
	_SCL_HIGH				;|
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						; > Send 9th clock and check for acknowledge from Slave
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						;|
	NOP						;| 
	BTFSS	_SDA			;|
	BCF		bit_in			;|
	_SCL_LOW				;|
	NOP						;|
	NOP						;|
	RETURN					;Bit is received
;----------------------------------------------------------------------------------------------
