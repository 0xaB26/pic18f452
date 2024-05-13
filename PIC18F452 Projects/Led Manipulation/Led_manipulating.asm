					CONFIG		WDT = OFF
					#INCLUDE	<p18f452.inc>
					LIST		P = 18F452
;----------------------------------------------------
					ORG			0x00000
					GOTO		MAIN	
					ORG			0x00008	
					GOTO		INTERRUPT
;----------------------------------------------------
MAIN
					CLRF		TRISD
					BSF			INTCON,GIE
					BSF			INTCON,PEIE
					BSF			PIE2,TMR3IE
					BCF			PIR2,TMR3IF
					MOVLW		0x94
					MOVWF		T3CON
					MOVLW		0x3C
					MOVWF		TMR3H
					MOVLW		0xB0
					MOVWF		TMR3L
					BSF			T3CON,TMR3ON
					MOVLW		0x01
					MOVWF		PORTD
;----------------------------------------------------
WAIT
					GOTO		WAIT
;----------------------------------------------------
INTERRUPT
					BTFSC		PIR2,TMR3IF	
					GOTO		TIMER3
;----------------------------------------------------
TIMER3
					BCF			PIR2,TMR3IF
					MOVLW		0x3C
					MOVWF		TMR3H
					MOVLW		0xB0
					MOVWF		TMR3L
					MOVF		PORTD,W
					XORLW		0xFF
					BZ			HERE
					RLNCF		PORTD,F
					MOVF		PORTD,W
					IORLW		0x01
					MOVWF		PORTD
					RETFIE		
HERE
					MOVLW		0x01
					MOVWF		PORTD
					RETFIE		
;----------------------------------------------------
					END