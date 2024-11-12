#include <p18f452.h>
#pragma config WDT = OFF

#define TRUE 1

void delay(void);


void main(void)
{
	TRISDbits.TRISD0 = 0;
	LATDbits.LATD0 = 0;
	while(TRUE)
	{
		delay();
		LATDbits.LATD0 = ~LATDbits.LATD0;
	}
}

void delay(void)
{
	T0CON = 0x03;
	TMR0H = 0x0B;
	TMR0L = 0xDC;
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 1;
	while(!INTCONbits.TMR0IF);
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 0;
}