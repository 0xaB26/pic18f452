#include <p18f452.h>
#pragma config WDT = OFF

void delay(void);

void main(void)
{
	unsigned char position = 0x00;
	TRISD = 0x00;	
	while(1)	
	{
		LATD = (0x01 << position);
		delay();
		LATD &= ~(0x01 << position);
		++position;
		if(position == 0x08)
			position = 0x00;
	}
}
void delay(void)
{
	T0CON = 0x47;		
	TMR0L = 20;			
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 1;	
	while(!INTCONbits.TMR0IF);
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 0;
}