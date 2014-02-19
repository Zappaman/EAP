;**********************************************************************************************
;							BASIC INFORMATION ABOUT THIS PROGRAM
;**********************************************************************************************
;	File name:	 main.asm
;	Data:		 21/09/2007
;	Version:	 02.00
;	Company:	 Melexis-Bulgaria(www.melexis.com)
;	Description: Software SMBus implementation for MLX90614 using PIC18F4320
;				 Language: Microchip Assembler
;			     Fosc=11.0592MHz, Tcy=362ns
;   Author:		 Dimo petkov, dpv@melexis.com
;**********************************************************************************************
;							DEFINE MCU TYPE AND INCLUDE HEADER FILES
;**********************************************************************************************
				LIST 		p=18F4320
				#include	<p18F4320.inc>
				#include	"boot.inc"
				#include	"config.inc"
				#include	"GPRs.inc"
				#include	"macros.inc"
;**********************************************************************************************
;							   			BEGINNING OF THE PROGRAM
;**********************************************************************************************

TYPE_PICSTART=1		;Bootloader not used
TYPE_BOOTLOAD=2		;Bootloader (http://members.rogers.com/martin.dubuc/Bootloader/) is used

					;(http://mdubuc.freeshell.org/Colt/)

type_prog=2			;EQU THE PROGRAMMING TOOL HERE! - results in vectors' offEQU (e.g. reEQU 0x0000 <-> 0x0200)

					IF type_prog == 2
						ORG 0x0000
						#include "BLOAD_PM.asm"	;NB: EQU the last EEPROM address to 0xFF ! At the end of code...
						ORG 0x0200	;revised in order to add bootloader, http://members.rogers.com/martin.dubuc/Bootloader/
					ELSE
						ORG 0x0000
					ENDIF	
					
							
	
	GOTO	MAIN	;JUMP TO MAIN PROGRAM 
		
;**********************************************************************************************
;									INTERRUPT SERVISE ROUTINES 		
;**********************************************************************************************
					IF type_prog == 2
						ORG	0x00208
					ELSE
						ORG	0x00008
					ENDIF
	GOTO 	isr_high		

					IF type_prog == 2
						ORG	0x00218
					ELSE
						ORG	0x00018
					ENDIF
	GOTO	isr_low
	
;------------------------HIGH PRIORITY LEVEL	INTERRUPT SERVISE ROUTINE---------------------
isr_high
;Check for low interrupt source
;..............
	RETFIE	FAST					;If interrupt source is different go out
	

	
;-------------------------LOW PRIORITY LEVEL	INTERRUPT SERVISE ROUTINE---------------------- 		
isr_low

	MOVWF 	WREG_temp 				;| 
	MOVFF 	STATUS,	STATUS_temp 	; > Save STATUS, WREG and BSR register in RAM
	MOVFF 	BSR, BSR_temp 			;| 
	
;Check for low interrupt source
;...........
	RETFIE							;If interrupt source is different go out
	
isr_low_end
	
    MOVFF	 BSR_temp,BSR  			;|
	MOVF 	 WREG_temp,W 			; > Restore BSR,WREG,STATUS
	MOVFF 	 STATUS_temp,STATUS 	;|
	
	RETFIE
			
	
;**********************************************************************************************
;											SUBROUTINES 		
;**********************************************************************************************
#include "MemoryAccess.asm"
#include "SMBusSubr.asm"
#include "CRC8.asm"
#include "MCUinit.asm"
#include "delay.asm"
;**********************************************************************************************
;												MAIN
;**********************************************************************************************
MAIN
	CALL	MCUinit					; MCU initialization
	
	MOVLW	SA<<1					; Put SA in the upper 7 bits 
	MOVWF	SlaveAddress			; Set SMBus Address				
	MOVLW	RAM_Tobj1|RAM_Access	; Form RAM access command + RAM address
	MOVWF	command					; Load the command register
	
	CALL	delay_200ms				; Wait after POR,Tvalid=0.15s
									; See the datasheet of MLX90614	
ReadLoop
    
	CALL	MemRead					; Read RAM address
	CALL	delay_200ms				;|
	CALL	delay_200ms				; > Wait before next measurement
	CALL	delay_200ms				;| 
	BRA		ReadLoop				; Read again

	END
;*********************************** END OF PROGRAM *******************************************
