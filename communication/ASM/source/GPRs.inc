;**********************************************************************************************
;						    	 GPRs AND CONSTANTs DEFINITIONS
;**********************************************************************************************
		
		CBLOCK	H'00'
		   WREG_temp			; Storage memory of WREG in ISRs with low priority
		   STATUS_temp			; Storage memory of STATUS in ISRs with low priority
		   BSR_temp				; Storage memory of BSR in ISRs with low priority
		   
		   counterU				;|
		   counterH				; > Registers used in delay subroutines
		   counterL				;|
		   	   
		   TX_buffer			; Saves the byte which will be send on the SMBus 
	       Bit_counter			; Register used in TX_byte and RX_byte subroutines
		   RX_buffer			; Save the byte received from the SMbus
		   
		   flagreg0				; Defines user flags			
		   DataL				; Contains the low data byte read from MLX90614
		   DataH				; Contains the high data byte read from MLX90614
		   PecReg				; Contains the PEC byte read from MLX90614
		   
		   SlaveAddress			; Contains the device address
		   command				; Contains the SMBus command
		   Nack_Counter			; Defines the numbers of the  attempts one message to be sent in case of a failure 
		   
		   PEC4					;|
		   PEC3					;|
		   PEC2					;|
		   PEC1					;|
		   PEC0					;|
		   PEC					;|
		   CRC4					;|
		   CRC3					; > Registers used in CRC8.asm file
		   CRC2					;|
		   CRC1					;|
		   CRC0					;|
		   CRC					;|
		   BitPosition			;|
		   shift				;|
		   
		ENDC
		
;delay constants
#define TBUF	d'5'			; Defines SMBus timings(Tbuf- bus free time between Stop and Start condition)


;SMBus control signals
#define _SCL_IO TRISC,3			; Defines SCL pin direction
#define _SDA_IO TRISC,4			; Defines SDA pin direction
#define _SCL    PORTC,3			; Defines SCL data pin
#define _SDA    PORTC,4			; Defines SDA data pin

#define bit_out	flagreg0,0		; Contains the bit that will be send on the SDA line
#define bit_in	flagreg0,1		; Contains the bit that is received on the SDA lina

;MLX90614 definitions
#define  RAM_Access    0x00		; Define the MLX90614 command RAM_Accsess
#define  RAM_Tobj1	   0x07		; Define address from MLX90614 RAM memory  
#define  SA    		   0x00		; Define SMBus device address
#define  DEFAULT_SA    0x5A		; Define default SMBus device address
