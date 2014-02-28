/*
 * File:   newmain.c
 * Author: razvan
 *
 * Created on February 27, 2014, 6:59 PM
 */
//Frecventa oscilatorului aparent este la 8MHZ darr teoretic pe osciloscop la valoarea asta merge:D
#define FCY   2000000  //define your instruction frequency, FCY = FOSC/2

 #define CYCLES_PER_MS ((unsigned long)(FCY * 0.001))        //instruction cycles per millisecond
 #define CYCLES_PER_US ((unsigned long)(FCY * 0.000001))   //instruction cycles per microsecond
 #define DELAY_MS(ms)  __delay32(CYCLES_PER_MS * ((unsigned long) ms));   //__delay32 is provided by the compiler, delay some # of milliseconds

 #define DELAY_US(us)  __delay32(CYCLES_PER_US * ((unsigned long) us));    //delay some number of microseconds
#include <stdio.h>
#include <stdlib.h>
#include <p24FJ64GB002.h>
#include <libpic30.h>

/*
 *
 */
void big_delay() {
    int i;
    for (i = 1; i <= 50; i++) {
        DELAY_MS(20);
    }
}
//turns left and right
int main(int argc, char** argv) {
    TRISA=0;
    PORTA=0;
    while(1){
        //turn right a lot
        int i;
        for (i = 0; i < 50; i++) {
            PORTA= 0xff;
            DELAY_MS(2.2);
            PORTA=0;
            DELAY_MS(17.8);
        }

          for (i = 0; i < 50; i++) {
            PORTA= 0xff;
            DELAY_MS(1.2);
            PORTA=0;
            DELAY_MS(18.8);
        }
    }
    return (EXIT_SUCCESS);
}

