			CONFIG		WDT = OFF	
			#INCLUDE	<p18f452.inc>
			LIST 		P=18F452
;----------------------------------------
			ORG			0x00
			CLRF		TRISD
			CLRF		PORTD
;-------------- MAIN SUBROUTINE --------------------------
MAIN
			CLRF		PORTD
			BSF			PORTD,RD0
			CALL		TIMER0
BACK
			BTFSC		PORTD,RD7
			BRA			MAIN
			RLNCF		PORTD
			CALL		TIMER0
			BRA			BACK
;---------------- TIMER0 SUBROUTINE ------------------------
TIMER0
			MOVLW		0x02
			MOVWF		T0CON
			MOVLW		0x0B
			MOVWF		TMR0H
			MOVLW		0xDC
			MOVWF		TMR0L
			BCF			INTCON,TMR0IF
			BSF			T0CON,TMR0ON
TEST
			BTFSS		INTCON,TMR0IF
			BRA			TEST
			BCF			INTCON,TMR0IF
			BCF			T0CON,TMR0ON
			RETURN
;-----------------------------------------
			END
