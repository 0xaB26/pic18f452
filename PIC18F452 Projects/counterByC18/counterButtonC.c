/*
	IMPLEMETING A SIMPLE COUNTER USING C18 COMPILER C LANGUAGE
	USING THE TIMER0 INTERRUPT.
	THE EXTERNAL SWITCH IS USED TO INCREMENT THE COUNTER AND THE RESULT IS DISPLAYED IN 7 SEGMENT
*/
#include <p18f452.h>
#define true 1
#pragma config WDT = OFF

void displayRigth(unsigned char counter);
void displayLeft(unsigned char counter);

#pragma interrupt function
void function(void)
{
	static unsigned char state = 0, counter = 0;
	if(INTCONbits.TMR0IF == 1)	
	{
		TMR0H = 0x3C;
		TMR0L = 0xB0;
		INTCONbits.TMR0IF = 0;
		if(state == 0)
		{
			PORTE = 0x01;
			state = 1;
			displayRigth(counter);
		}
		else
		{
			PORTE = 0x02;
			state = 0;	
			displayLeft(counter);	
		}
	}	
	else if(INTCONbits.INT0IF == 1)
	{
		INTCONbits.INT0IF = 0;
		++counter;
		if(counter == 100)
			counter = 0;
	}	
}

#pragma code myVector = 0x00008
void myVector(void)
{
	_asm
		GOTO function
	_endasm
}

#pragma code main = 0x0F00
void main(void)
{
	TRISBbits.TRISB0 = 1;
	TRISC = 0xF0;
	PORTC = 0xF0;
	TRISE = 0x04;
	ADCON1 = 0X06;
	INTCONbits.GIE = 1;
	INTCONbits.TMR0IE = 1;
	INTCONbits.TMR0IF = 0;
	INTCONbits.INT0IE = 1;
	INTCONbits.INT0IF = 0;
	T0CON = 0x08;	
	TMR0H = 0x3C;
	TMR0L = 0xB0;
	T0CONbits.TMR0ON = 1;
	while(true);
}
void displayRigth(unsigned char counter)
{
	PORTC = (counter%10);
}
void displayLeft(unsigned char counter)
{
	PORTC = (counter/10);
}
