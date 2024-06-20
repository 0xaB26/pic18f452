#include 	<p18f452.h>
#pragma 	config WDT = OFF
#define 	TRUE		1
			
void delay250ms(void);						
void timer0Generation(void);

void main(void)
{	
	TRISC = 0xFE;
	while(TRUE)
	{
		PORTCbits.RC0 = ~PORTCbits.RC0;
		delay250ms();
	}			
}
void delay250ms(void)
{
	T0CON = 0x01;
	TMR0H = 0x0B;
	TMR0L = 0xBC;
	timer0Generation();		
}
void timer0Generation(void)
{
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 1;
	while(INTCONbits.TMR0IF == 0);
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 0;	
}