#include <p18f452.h>
#pragma config WDT = OFF

#pragma interrupt myFunction
void myFunction(void)
{
	if(INTCONbits.INT0IF)
	{
		INTCONbits.INT0IF = 0;
		LATDbits.LATD0 = ~LATDbits.LATD0;
	}
}

#pragma code myVector = 0x00008
void myVector(void)
{
	_asm
		GOTO myFunction
	_endasm
}
#pragma code


void main(void)
{
	TRISDbits.TRISD0 = 0;
	TRISBbits.TRISB0 = 1;
	INTCONbits.GIE = 1;
	INTCONbits.INT0IE = 1;
	INTCONbits.INT0IF = 0;
	while(1);
}