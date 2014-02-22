/* 
 * File:   SMBus.h
 * Author: andu
 *
 * Created on February 22, 2014, 1:31 PM
 */

//*HEADER FILES********************************************************************************
#include<p24FJ64GB002.h>
#include"main.h"

//*High and Low level of clock
#define HIGHLEV	3
#define LOWLEV	1


//*PROTOTYPES**********************************************************************************
void START_bit(void);
void STOP_bit(void);
unsigned char TX_byte(unsigned char Tx_buffer);
unsigned char RX_byte(unsigned char ack_nack);
void send_bit(unsigned char bit_out);
unsigned char Receive_bit(void);
//*EXTERNAL FUNCTION***************************************************************************
extern	void delay( unsigned long i);


