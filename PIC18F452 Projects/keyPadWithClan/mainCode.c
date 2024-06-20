#include <p18f452.h>
#include <string.h>

#pragma config WDT = OFF

#define		rs		PORTCbits.RC0
#define 	rw 		PORTCbits.RC1
#define 	en		PORTCbits.RC2

unsigned char state = 0;

void initiaLcd(void);			
void delay250ms(void);		
void delay3us(void);			
void commandInst(void);
void busyFlag(void);				
void dataInst(void);				
void timer0Generation(void);

#pragma interrupt myFunction
void myFunction(void)
{
	if(PIR1bits.TMR1IF == 1)		
	{
		PIR1bits.TMR1IF = 0;
		TMR1H = 0x3C;
		TMR1L = 0xB0;
		switch(state)
		{
			case 0 :
				state = 1;
				LATA = 0x7E;
				break;
			case 1:
				state = 2;
				LATA = 0x7D;
				break;
			case 2:
				state = 0;
				LATA = 0x7B;
				break;
		}
	}
	else if(INTCONbits.RBIF == 1)
	{
		PORTB = PORTB;
		if(PORTAbits.RA0 == 0)
		{
			if(PORTBbits.RB4 == 0)
			{
				LATD = '3';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB5 == 0)	
			{
				LATD = '6';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB6 == 0)
			{
				LATD = '9';
				dataInst();
				busyFlag();
			}
		}
		else if(PORTAbits.RA1 == 0)
		{
			if(PORTBbits.RB4 == 0)
			{
				LATD = '2';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB5 == 0)	
			{
				LATD = '5';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB6 == 0)
			{
				LATD = '8';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB7 == 0)
			{
				LATD = '0';
				dataInst();
				busyFlag();
			}
		}
		else if(PORTAbits.RA2 == 0)
		{
			if(PORTBbits.RB4 == 0)
			{
				LATD = '1';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB5 == 0)	
			{
				LATD = '4';
				dataInst();
				busyFlag();
			}
			else if(PORTBbits.RB6 == 0)
			{
				LATD = '7';
				dataInst();
				busyFlag();
			}
		}
	}
		INTCONbits.RBIF = 0;		
}

#pragma code myInterruptVector = 0x00008
void myInterruptVector(void)
{
	_asm
		GOTO myFunction
	_endasm
}
#pragma code


void main(void)
{
		TRISB = 0xF1;			
		TRISD = 0x00;	
		TRISC = 0xF8;
		TRISA = 0x78;
		ADCON1 = 0x07;	
		initiaLcd();
		INTCONbits.GIE = 1;				
		INTCONbits.PEIE = 1;		
		INTCONbits.RBIE = 1;			
		PIE1bits.TMR1IE = 1;		
		PIR1bits.TMR1IF = 0;	
		INTCONbits.RBIF = 0;
		T1CON = 0x14;
		TMR1H = 0x3C;
		TMR1L = 0xB0;
		T1CONbits.TMR1ON = 1;			
		while(1);				
}
void initiaLcd(void)
{
		LATD = 0x38;
		commandInst();
		delay250ms();
		LATD = 0x01;
		commandInst();
		delay250ms();
		LATD = 0x0F;
		commandInst();
		delay250ms();
}
void delay250ms(void)
{
		T0CON = 0x01;
		TMR0H = 0x0B;
		TMR0L = 0xBC;
		timer0Generation();		
}
void delay3us(void)
{
		T0CON = 0x48;
		TMR0L = 253;
		timer0Generation();
}
void commandInst(void)
{
		rs = 0;
		rw = 0;
		en = 1;
		delay3us();
		en = 0;
}
void dataInst(void)
{
		rs = 1;
		rw = 0;
		en = 1;
		delay3us();
		en = 0;
}
void busyFlag(void)
{
		rs = 0;
		rw = 1;	
		TRISDbits.TRISD7 = 1;
		do
		{
			en = 0;
			delay3us();
			en = 1;
		}while(PORTDbits.RD7 == 1);
		en = 0;
		TRISDbits.TRISD7 = 0;
}
void timer0Generation(void)
{
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 1;
	while(INTCONbits.TMR0IF == 0);
	INTCONbits.TMR0IF = 0;
	T0CONbits.TMR0ON = 0;	
}