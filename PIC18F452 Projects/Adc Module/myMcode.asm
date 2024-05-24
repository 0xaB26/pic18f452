;---------------------------------------------------------------------------------------------------
;	HERE I AM USING THE ADC INTERGATED IN THE PIC18F452 THAT ALLOWS CONVERTING 8 ANALOG SIGNALS IN DIFFERENT CHANNELS
;	THE RESULT OF THE ADC IS ENCODED IN 10 BIT
;	THE RESULT IS STORED IN THE REGISTER ADRESH:ADRESL
;	I AM USING THE POLLING TECHNIQUE
;---------------------------------------------------------------------------------------------------
						CONFIG			WDT = OFF
						#INCLUDE		<p18f452.inc>
						LIST			P = 18F452
;---------------------------------------------------------------------------------------------------
						ORG				0x00
						CLRF			TRISC
						CLRF			TRISD
						BSF				TRISA,RA0		
						MOVLW			0x41		
						MOVWF			ADCON0
						MOVLW			0x8E
						MOVWF			ADCON1
;---------------------------------------------------------------------------------------------------
REPEAT
						CALL			acquiTime
						BSF				ADCON0,GO
WAIT
						BTFSC			ADCON0,DONE
						GOTO			WAIT
						MOVF			ADRESL,W
						MOVWF			PORTC
						MOVF			ADRESH,W
						MOVWF			PORTD
						GOTO			REPEAT	
;---------------------------------------------------------------------------------------------------
acquiTime
						MOVLW			0x48
						MOVWF			T0CON
						MOVLW			D'241'
						MOVWF			TMR0L
						GOTO			TIMER_CALCULATING
;---------------------------------------------------------------------------------------------------
TIMER_CALCULATING
						BCF				INTCON,TMR0IF
						BSF				T0CON,TMR0ON
TESTX
						BTFSS			INTCON,TMR0IF	
						GOTO			TESTX
						BCF				INTCON,TMR0IF
						BCF				T0CON,TMR0ON
						RETURN
;---------------------------------------------------------------------------------------------------
						END