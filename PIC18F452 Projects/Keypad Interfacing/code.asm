; ASSEMBLY CODE FOR INTERFACING A KEYPAD(NUMBERS[0-9] + CLEAR)
; THE CODE USES TIMER0 INTERRUPT AND PORTB CHANGE INTERRUPT
; THE AUTHOR : DALI FETHI ABDELLATIF 15/02/2024
;----------- ASM SOURCE FILE ----------------------------------
			CONFIG		WDT = OFF
			#INCLUDE	"p18f452.inc"
			LIST		P = 18F452
COUNTER		EQU			0x00
VALUE		EQU			0x01
NUMBER		EQU			0x02
;--------------- STARTING ADDRESS PRGRAM -----------------------
			ORG			0x00
			BRA			MAIN
			ORG			0x08 		; HIGH PRIORITY INTERRUPT
			BRA			INTERRUPT
;--------------- MAIN PROGRAM -----------------------------------
MAIN
			MOVLW		0x00
			MOVWF		TRISD		; PORTD : OUTPUT
			BCF			NUMBER,0
			CLRF		COUNTER
			MOVLW		0xF8		; PORTC(RC0-RC2) : OUTPUT
			MOVWF		TRISC
			MOVLW		0xFF		; PORTB (RB4-RB7) : INPUT
			MOVWF		TRISB
			; INTERRUPT CONFIGURATION 
			BCF			INTCON2,RBPU
			BSF			INTCON,GIE
			BSF			INTCON,RBIE
			BCF			INTCON,RBIF
			BSF			INTCON,TMR0IE
			BCF			INTCON,TMR0IF
 			; TIMER0 CONFIGURATION
			MOVLW		0x08	
			MOVWF		T0CON
			MOVLW		0x3C
			MOVWF		TMR0H
			MOVLW		0xB0
			MOVWF		TMR0L
			MOVLW		0x06
			MOVWF		VALUE
			BSF			T0CON,TMR0ON
;----------------- LOOP ---------------------
WAIT
			MOVF		COUNTER,W	; SENDING TO PORTD
			MOVWF		PORTD
			BRA			WAIT
;---------------- INTERRUPT VECTOR TABLE ----------------------
INTERRUPT
			; TESTING THE FLAGS INTERRUPT
			BTFSC		INTCON,RBIF
			GOTO		TEST
			BTFSC		INTCON,TMR0IF
			GOTO		FUNCTION
;-----------------------------------------
TEST
			; WHICH COLUMN IS ACTIVE
			BTFSS		PORTC,0
			GOTO		HERE
			BTFSS		PORTC,1
			GOTO		NEXT
			BTFSS		PORTC,2
			GOTO		BELOW
;---------------------------------------
HERE
			; WHICH THE PIN CHANGES ITS STATE
			BTFSS		PORTB,4
			BRA			NUMBER3
			BTFSS		PORTB,5
			BRA			NUMBER6
			BTFSS		PORTB,6
			BRA			NUMBER9
			BTFSS		PORTB,7
			BRA			CLEAR
;--------------------------------------
NEXT
			; WHICH THE PIN CHANGES ITS STATE
			BTFSS		PORTB,4
			BRA			NUMBER2
			BTFSS		PORTB,5
			BRA			NUMBER5
			BTFSS		PORTB,6
			BRA			NUMBER8
;--------------------------------------
BELOW
			; WHICH THE PIN CHANGES ITS STATE
			BTFSS		PORTB,4
			BRA			NUMBER1
			BTFSS		PORTB,5
			BRA			NUMBER4
			BTFSS		PORTB,6
			BRA			NUMBER7
;------------ ACTIVING ONE COLUMN PER 50 MS --------------------------
FUNCTION
			BCF			INTCON,TMR0IF
			MOVF		VALUE,W
			XORLW		0x06
			BZ			FIRST
			MOVF		VALUE,W
			XORLW		0x03
			BZ			KIKAG
			MOVLW		0x03
			MOVWF		VALUE
			MOVLW		0x05
			MOVWF		PORTC
			MOVLW		0x3C
			MOVWF		TMR0H
			MOVLW		0xB0
			MOVWF		TMR0L
			BRA			FINALE
FIRST
			MOVLW		0x05
			MOVWF		VALUE
			MOVLW		0x06
			MOVWF		PORTC
			MOVLW		0x3C
			MOVWF		TMR0H
			MOVLW		0xB0
			MOVWF		TMR0L
			BRA			FINALE
KIKAG
			MOVLW		0x06
			MOVWF		VALUE
			MOVLW		0x03
			MOVWF		PORTC
			MOVLW		0x3C
			MOVWF		TMR0H
			MOVLW		0xB0
			MOVWF		TMR0L
			BRA			FINALE									
;------------- SUBROUTINE FOR SENDING 1 TO COUNTER -------------------------
NUMBER1
			BCF			INTCON,RBIF
			MOVF		PORTB,W
			MOVLW		0x01
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 2 TO COUNTER -------------------------
NUMBER2
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x02
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 3 TO COUNTER -------------------------
NUMBER3
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x03
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 4 TO COUNTER -------------------------
NUMBER4
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x04
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 5 TO COUNTER ---------------------------
NUMBER5
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x05
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 6 TO COUNTER ---------------------------
NUMBER6
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x06
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 7 TO COUNTER ---------------------------
NUMBER7
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x07
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 8 TO COUNTER ----------------------------
NUMBER8
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x08
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR SENDING 9 TO COUNTER ----------------------------
NUMBER9
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x09
			MOVWF		COUNTER
			BRA			FINALE
;------------- SUBROUTINE FOR CLEARING THE OUTPUT ZERO ----------------------------
CLEAR
			MOVF		PORTB,W
			BCF			INTCON,RBIF
			MOVLW		0x00
			MOVWF		COUNTER
			BRA			FINALE
;-------------------------------------------------------------------------------
FINALE
			RETFIE
;------------- END SOURCE FILE -------------------------------------------------
			END
;--------------------------------------------------------------------------------
