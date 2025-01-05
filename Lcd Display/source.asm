				#include <p18f452.inc>
				CONFIG	WDT = OFF
				LIST	P = 18F452	
				RADIX 	HEX

#define 		RS_PIN			LATC,LATC0
#define 		RW_PIN			LATC,LATC1
#define			EN_PIN			LATC,LATC2
#define 		LCD_DATA_BUS	LATD

STATE			EQU		0x000

				ORG		0x00000
				CLRF	TRISD,0
				MOVLW	0xF8
				MOVWF	TRISC,0
				CALL	LCD_INIT		
				MOVLW	0x31
				CALL	DATA_SEND
				MOVLW	'/'
				CALL	DATA_SEND
				MOVLW	0x32
				CALL	DATA_SEND
				MOVLW	'/'
				CALL	DATA_SEND
				MOVLW	0x32
				CALL	DATA_SEND
				MOVLW	0x30
				CALL	DATA_SEND
				MOVLW	0x32
				CALL	DATA_SEND
				MOVLW	0x35
				CALL	DATA_SEND
				GOTO	$
LCD_INIT							; LCD INITIALIZATION(FUNCTION SET) : 2 LINES, 5*7 PIXEL MODE, 8 BIT MODE INTERFACE
				MOVLW	0x38
				CALL	COMMAND_SEND
				CALL	DELAY_250_MS
				MOVLW	0x01		; CLEAR HOME
				CALL	COMMAND_SEND
				CALL	DELAY_250_MS
				MOVLW	0x0F		; LCD ON, CURSOR ON, CURSOR BLINCKING
				CALL	COMMAND_SEND
				CALL	DELAY_250_MS
				RETURN
DELAY_250_MS
				MOVLW	0x01
				MOVWF	T0CON
				MOVLW	0x0B
				MOVWF	TMR0H
				MOVLW	0xDC
				MOVWF	TMR0L
				CALL	TIMER_0
				RETURN
TIMER_0
				BCF		INTCON,TMR0IF
				BSF		T0CON,TMR0ON		
WAIT
				BTFSS	INTCON,TMR0IF
				GOTO	WAIT
				BCF		INTCON,TMR0IF
				BCF		T0CON,TMR0ON
				RETURN
DELAY_450_US
				MOVLW	0x40
				MOVWF	T0CON
				MOVLW	D'31'
				MOVWF	TMR0L
				CALL	TIMER_0
				RETURN
DATA_SEND								; SUBROUTINE TO HANDL DATA SENDED TO LCD
				MOVWF	LCD_DATA_BUS
				BSF		RS_PIN
				BCF		RW_PIN
				BSF		EN_PIN
				CALL	DELAY_450_US
				BCF		EN_PIN
				CALL	BUSY_FLAG
				RETURN
COMMAND_SEND							; SUBROUTINE TO HANDL COMMAND SENDED TO LCD
				MOVWF	LCD_DATA_BUS
				BCF		RS_PIN
				BCF		RW_PIN
				BSF		EN_PIN
				CALL	DELAY_450_US			
				BCF		EN_PIN
				CALL	BUSY_FLAG
				RETURN	
BUSY_FLAG							; BUSY FLAG TO CHECK IF LCD CONTROLLER IS READY OR BUSY 
				BSF		TRISD,TRISD7
				BCF		RS_PIN
				BSF		RW_PIN
CHECK
				BSF		EN_PIN
				CALL	DELAY_450_US
				BCF		EN_PIN		
				BTFSC	PORTD,RD7
				GOTO	CHECK
				BCF		TRISD,TRISD7
				RETURN
				END