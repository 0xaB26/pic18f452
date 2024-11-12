#include <p18f452.h>
#pragma config WDT = OFF

#define TRUE 1

void delay(unsigned char config, unsigned char HIGH, unsigned char LOW);

#pragma interrupt SERVICE
void SERVICE(void)
{
}

#pragma code VECTOR = 0x00008
void VECTOR(void)
{
	_asm
		GOTO SERVICE
	_endasm
}
#pragma code



void main(void)
{
	unsigned char counter = 0;
	TRISD = 0xF0;
	while(TRUE)
	{
		if(counter != 0x0A)
		{
			LATD = counter;
			delay(0x02, 0x0B, 0xDC);	
			++counter;
		}
		else
			counter = 0;
	}
}

void delay(unsigned char config, unsigned char HIGH, unsigned char LOW)
{
	T0CON = config;
	TMR0H = HIGH;
	TMR0L = LOW;
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 1;
	while(!INTCONbits.TMR0IF);
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 0;
}