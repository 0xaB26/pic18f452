;******************************************************************************
; Stopwatch Assembly Code for PIC18F452
;
; This code implements a stopwatch that counts up to 99. It utilizes Timer1 for
; incrementing the stopwatch and Timer0 for displaying the digits on a 7-segment
; display every 0.05 seconds. Interrupts are employed to optimize clock cycles
; and ensure smooth operation of the microcontroller. The 7-segment display is
; connected to PORTD (RD0-RD3) through a BCD to 7-segment decoder to minimize
; the number of pins used. Two buttons (RB0 and RB1) connected to PORTB control
; the stopwatch - RB0 starts the timer, and RB1, on a falling edge, stops the
; incrementation. Watchdog is disabled, and the code has been simulated using
; Proteus ISIS software.
; Author : DALI FETHI ABDELLATIF	//04/03/2024

; Note: This code is designed for PIC18F452 and may require modifications for
; compatibility with other PIC architectures.
;
;******************************************************************************
				CONFIG		WDT = OFF
				#INCLUDE	"p18f452.inc"
				LIST		P = 18F452
VALUE			EQU			0x00
COUNTER			EQU			0x01
STOPS			EQU			0x02
;---------------------------------------------
				ORG			0x00
				GOTO		MAIN
				ORG			0x00008
				GOTO		INTERRUPT
;--------------------------------------------
MAIN
				MOVLW		0xF0
				MOVWF		TRISD
				BSF			TRISB,RB0
				BCF			INTCON2,RBPU
				CLRF		TRISE
				BSF			INTCON,GIE
				BSF			INTCON,TMR0IE
				BCF			INTCON,TMR0IF
				BSF			INTCON,INT0IE
				BCF			INTCON,INT0IF
				BCF			INTCON2,INTEDG0
				BSF			INTCON3,INT1IE
				BCF			INTCON3,INT1IF
				BCF			INTCON2,INTEDG1
				MOVLW		0x08
				MOVWF		T0CON
				MOVLW		0x3C
				MOVWF		TMR0H
				MOVLW		0xB0
				MOVWF		TMR0L
				BSF			T0CON,TMR0ON
				BSF			INTCON,PEIE
				BSF			PIE1,TMR1IE
				BCF			PIR1,TMR1IF
				MOVLW		0xB4
				MOVWF		T1CON
				MOVLW		0x0B
				MOVWF		TMR1H
				MOVLW		0xDC
				MOVWF		TMR1L
				BSF			T1CON,TMR1ON
				BCF			VALUE,0
;---------------------------------------------
WAIT
				GOTO		WAIT
;---------------------------------------------
INTERRUPT
				BTFSC		INTCON,TMR0IF
				GOTO		CHECK
				BTFSC		PIR1,TMR1IF
				GOTO		NEW_VALUE
				BTFSC		INTCON,INT0IF
				GOTO		STOP
				BTFSC		INTCON3,INT1IF
				GOTO		CLEAR
CHECK
				BTFSC		VALUE,0
				GOTO		DIGIT_TWO
				GOTO		DIGIT_ONE	
;--------------------------------------------
DIGIT_ONE
				BCF			INTCON,TMR0IF
				BSF			VALUE,0
				MOVLW		0x3C
				MOVWF		TMR0H
				MOVLW		0xB0
				MOVWF		TMR0L
				MOVF		COUNTER,W
				ANDLW		0x0F
				XORLW		0x0A
				BTFSC		STATUS,Z
				CALL		NEW
				MOVLW		0x02
				MOVWF		PORTE
				MOVF		COUNTER,W
				ANDLW		0x0F
				MOVWF		PORTD
				RETFIE
NEW
				MOVF		COUNTER,W		
				ADDLW		0x06
				MOVWF		COUNTER
				RETURN		
;---------------------------------------------
DIGIT_TWO
				BCF			INTCON,TMR0IF
				BCF			VALUE,0
				MOVLW		0x3C
				MOVWF		TMR0H
				MOVLW		0xB0
				MOVWF		TMR0L
				MOVLW		0x01
				MOVWF		PORTE
				SWAPF		COUNTER,W
				ANDLW		0x0F
				MOVWF		PORTD
				RETFIE
;--------------------------------------------
NEW_VALUE
				BCF			PIR1,TMR1IF	
				MOVLW		0x0B
				MOVWF		TMR1H
				MOVLW		0xDC
				MOVWF		TMR1L
				MOVLW		0x01
				ADDWF		COUNTER,F
				MOVF		COUNTER,W
				XORLW		0x9A
				BZ			TEST
				RETFIE
TEST
				CLRF		COUNTER
				RETFIE
;--------------------------------------------
STOP
				BCF			INTCON,INT0IF
				BTFSC		STOPS,0
				GOTO		SECOND	
				BSF			STOPS,0
				BCF			PIE1,TMR1IE
				BCF			PIR1,TMR1IF
				BCF			T1CON,TMR1ON
				RETFIE
SECOND
				BCF			STOPS,0
				BSF			PIE1,TMR1IE
				BCF			PIR1,TMR1IF
				BSF			T1CON,TMR1ON
				MOVLW		0x0B
				MOVWF		TMR1H
				MOVLW		0xDC
				MOVWF		TMR1L
				RETFIE		
;--------------------------------------------
CLEAR
				BCF			INTCON3,INT1IF
				CLRF		COUNTER
				MOVLW		0x00
				MOVWF		PORTD
				MOVLW		0x0B
				MOVWF		TMR1H
				MOVLW		0xDC
				MOVWF		TMR1L
				MOVLW		0x3C
				MOVWF		TMR0H
				MOVLW		0xB0
				MOVWF		TMR0L
				RETFIE
;--------------------------------------------
				END
				
				