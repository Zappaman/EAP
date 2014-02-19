;************************************************************************************************************
;										TUNABLE DELAY	
;************************************************************************************************************
;Name:		delay
;Function:	Produces time delay depending on the value in counterL
;Input:		WREG
;Output:	No
;Comments:  Used in START _bit and STOP_bit subroutines to meet SMBus timing 
;	        requirements.
;	        Refer to "System Management BUS(SMBus) specification Version 2.0" and
;	        AN ”SMBus communication with MLX90614”		
;************************************************************************************************************
delay	
  	MOVWF	counterL	;WREG -> counterL
   	DECFSZ	counterL,f	;If (counerL=counterL-1) =0 go out
   	BRA		$-2			;else decrement counterL again	
   	RETURN				;End of “delay”

;************************************************************************************************************
;							   		FIXED	DELAY 50ms@Fosc=11.0592MHz	
;************************************************************************************************
;Name:		delay_50ms 
;Function:	Produces time delay 50ms
;Input:		No
;Output:	No
;Comments:   
;************************************************************************************************************
delay_50ms				;Fcpu=11.0592MHz
	MOVLW	d'7'
	MOVWF	counterU

	MOVLW	d'26'
	MOVWF	counterH

	MOVLW	d'252'
	MOVWF	counterL
	
	DECFSZ	counterL,F
	BRA		$-2
	DECFSZ	counterH,F
	BRA		$-d'10'
	DECFSZ	counterU,F
	BRA		$-d'18'
	
	RETURN

;************************************************************************************************************
;							   		FIXED	DELAY 200ms@Fosc=11.0592MHz	
;************************************************************************************************
;Name:		delay_200ms 
;Function:	Produces time delay 200ms
;Input:		No
;Output:	No
;Comments:   
;************************************************************************************************************
delay_200ms				;Fcpu=11.0592MHz
	MOVLW	d'28'
	MOVWF	counterU

	MOVLW	d'26'
	MOVWF	counterH

	MOVLW	d'252'
	MOVWF	counterL
	
	DECFSZ	counterL,F
	BRA		$-2
	DECFSZ	counterH,F
	BRA		$-d'10'
	DECFSZ	counterU,F
	BRA		$-d'18'
	
	RETURN
;----------------------------------------------------------------------------------------------
