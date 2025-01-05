#include <p18f452.h>
#pragma config WDT = OFF

#define RS_LCD	LATCbits.LATC0
#define RW_LCD	LATCbits.LATC1
#define EN_LCD	LATCbits.LATC2

#define ADC_RESOLUTION  		1024
#define MAX_VALUE_TO_DISPLAY	100

#define ADC_ON()		(ADCON0bits.GO = 1)

ram unsigned char flag = 0x00, state = 0x00, etat = 0;
ram unsigned int adcResultOld = 0x0000, adcResultNew = 0x0000;
ram unsigned char valueToDisplay = 0x00;

void highDelay(void);
void smallDelay(void);
void timerOne(void);
void busyFlag(void);
void lcdInitialization(void);
void dataLcd(unsigned char data);
void commandLcd(unsigned char command);
void acquisitionTime(void);
void displayInformation(void);
void displayValue(void);

#pragma interrupt ISR
void ISR(void)
{	
	PIR1bits.ADIF = 0;
	if(state == 0)
	{
		adcResultOld = ADRESH;
		adcResultOld <<= 8;
		adcResultOld += ADRESL;
		state = 0x01;
		flag = 0x02;
	}
	else	
	{
		adcResultNew = ADRESH;
		adcResultNew <<= 8;
		adcResultNew += ADRESL;
		if(adcResultNew != adcResultOld)
		{
			adcResultOld = adcResultNew;
			flag = 0x02;
		}
	}	
}
#pragma code IVT = 0x00008
void IVT(void)
{
	_asm
		GOTO ISR
	_endasm
}
#pragma code

void main(void)
{
	TRISD = 0x00;
	TRISC = 0xF8;
	TRISEbits.TRISE0 = 1;
	ADCON0 = 0x69;
	ADCON1 = 0x80;
	lcdInitialization();
	INTCONbits.GIE = 1;
	INTCONbits.PEIE = 1;
	PIE1bits.ADIE = 1;
	PIR1bits.ADIF = 0;
	while(1)
	{
		if(flag == 0x02)		
		{
			valueToDisplay = ((unsigned short long)adcResultOld * MAX_VALUE_TO_DISPLAY) / ADC_RESOLUTION; 		
			if(! etat)
			{
				etat = 0x01;
				displayInformation();
				displayValue();
			}	
			else
			{	
				commandLcd(0x88);
				busyFlag();
				displayValue();
			}
			flag = 0x00;
		}
		acquisitionTime();			
		ADC_ON();
	}
}
void displayValue(void)
{	
	dataLcd((valueToDisplay / 100) + 0x30);
	dataLcd(((valueToDisplay % 100) / 10) + 0x30);	
	dataLcd(((valueToDisplay % 100) % 10) + 0x30);
}
void displayInformation(void)
{
	unsigned char str[] = "SOUND : ", i = 0;
	while(str[i])
		dataLcd(str[i++]);	
}
void dataLcd(unsigned char data)
{
	LATD = data;
	RS_LCD = 1;
	RW_LCD = 0;
	EN_LCD = 1;
	smallDelay();
	EN_LCD = 0;
	busyFlag();
}
void commandLcd(unsigned char command)
{
	LATD = command;
	RS_LCD = 0;
	RW_LCD = 0;
	EN_LCD = 1;
	smallDelay();
	EN_LCD = 0;
}
void lcdInitialization(void)
{
	commandLcd(0x38);
	highDelay();
	commandLcd(0x01);
	highDelay();
	commandLcd(0x0F);
	highDelay();
}
void busyFlag(void)
{
	TRISDbits.TRISD7 = 1;	
	RS_LCD = 0;
	RW_LCD = 1;
	do
	{
		EN_LCD = 1;
		smallDelay();
		EN_LCD = 0;
	}while(PORTDbits.RD7);
	TRISDbits.TRISD7 = 0;
}
void highDelay(void)
{
	T1CON = 0xB0;
	TMR1H = 0x85;
	TMR1L = 0xEE;
	timerOne();
}
void smallDelay(void)
{
	T1CON = 0x80;
	TMR1H = 0xFE;
	TMR1L = 0x3E;
	timerOne();
}
void timerOne(void)
{
	PIR1bits.TMR1IF = 0;
	T1CONbits.TMR1ON = 1;
	while(PIR1bits.TMR1IF == 0);
	PIR1bits.TMR1IF = 0;
	T1CONbits.TMR1ON = 0;	
}
void acquisitionTime(void)
{
	T1CON = 0x80;
	TMR1H = 0xFF;
	TMR1L = 0xEC;
	timerOne();
}