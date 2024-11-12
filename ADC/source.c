#include <p18f452.h>					// PIC18F452 HEADER FILE
#pragma config WDT = OFF				// WATCH DOG OFF

unsigned char flag = 0x00;				// FLAG 

void acquisitionTime(void);				// ACQUISITION TIME NEEDED FOR CAPACITOR CHARGING

#pragma interrupt myFunction
void myFunction(void)
{
	if(PIR1bits.ADIF)				// CHECK IF ADC TERMINATES CONVERSION ?
	{
		PIR1bits.ADIF = 0;			// CLEAR INTERRUPT FLAG
		LATD = ADRESL;				// LOWEST BYTE IN PORTD
		LATB = ADRESH;				// HIGHEST BYTE IN PORTC
		flag = 1;				// FLAG 
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
	TRISD = 0x00;			// OUTPUT
	TRISB = 0x00;			// OUTPUT
	TRISAbits.TRISA0 = 1;		// INPUT	
	ADCON0 = 0x41;			// CHANNEL 0, ADC ON, FOSC/8 CLOCK SPEED
	ADCON1 = 0x84;			// RIGHT JUSTIFIED, RA0 ANALOG
	INTCONbits.GIE = 1;		// ENABLE INTERRUPT GLOBALY
	INTCONbits.PEIE = 1;		// ENABLE PERIPHERAL
	PIE1bits.ADIE = 1;		// ENABLE ADC INTERRUPT
	PIR1bits.ADIF = 0;	
	flag = 0x01;			
	while(1)
	{
		if(flag)		IF FLAG NON ZERO THEN START CONVERSION 
		{
			acquisitionTime();
			ADCON0bits.GO = 1;			
			flag = 0;
		}
	}
}
void acquisitionTime(void)
{
	T0CON = 0x48;			// TIMER0 MODE 8, NO PRESCALER
	TMR0L = 236;			
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 1;		// START TIMER 0
	while(!INTCONbits.TMR0IF);	// POLLING TIMER 0 FLAG
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 0;
}
