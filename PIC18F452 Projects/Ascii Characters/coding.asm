; PIC18F452 MICRCONTROLLER INTERFACED WITH MATRIX OF BUTTONS AND 14 SEGMENT TO DISPLAY ASCII CHARACTERS
; THE CODE WRITTEN IN ASSEMBLY LANGUAGE FOR PIC18F452
; USING INTERRUPTS (PORTB CHANGE INTERRUPT AND TIMER0 INTERRUPT)
; WATCHDOG IS OFF AND THE CODE IS TESTED IN PROTEUS SOFTWARE AND WORKS GOOD
; USING PORTA, PORTB, PORTC, PORTD
; VALUE IS THE KEY TO ACTIVE ONE COLUMN EACH 30MS
; CHOOSE IS THE KEY TO CHANGE THE SWITCHES TO THE SECOND FACE
; WE HAVE 26 ASCII CHARACTER FROM(A-Z) AND EACH BUTTON HAS 2 ASCII CHARACTER
; THE USER THE CHARACTER HE WANTS HE NEEDS TO PUSH THE BUTTON (CHANGE) TO GET THE SECOND FACE OF THE KEYPAD
; DALI FETHI ABDELLATIF 17/03/2024
;-------------------------------------------------------------
					CONFIG			WDT = OFF
					#INCLUDE		<p18f452.inc>
					LIST			P = 18F452
;-------------------------------------------------------------
VALUE				EQU				0x00
CHOOSE				EQU				0x01
;-------------------------------------------------------------
					ORG				0x00
					BRA				MAIN
					ORG				0x08
					BRA				INTERRUPT
;-------------------------------------------------------------
MAIN
					MOVLW			0x00
					MOVWF			TRISD
					MOVLW			0x00	
					MOVWF			TRISC
					MOVLW			0xFF		
					MOVWF			TRISB
					MOVLW			0x07		;PORTA(RA0, RA1, RA2, RA3, RA5) AND PORTE(RE0, RE1, RE2) AS DIGITAL OUTPUT
					MOVWF			ADCON1
					CLRF			TRISA
					; SETTING THE INTERRUPT BITS
					BSF				INTCON,GIE
					BSF				INTCON,TMR0IE
					BCF				INTCON,TMR0IF
					BSF				INTCON,RBIE
					BCF				INTCON2,RBPU
					BCF				INTCON,RBIF
					; CONFIGURING TIMER0 (VALUE, PRESCALER)
					MOVLW			0x08
					MOVWF			T0CON
					MOVLW			0x8A
					MOVWF			TMR0H
					MOVLW			0xD0
					MOVWF			TMR0L
					BSF				T0CON,TMR0ON
					MOVLW			0x01	
					MOVWF			VALUE
					BSF				PORTA,RA3
					BSF				PORTA,RA2
					BSF				PORTA,RA1
					BCF				PORTA,RA0
;--------------------- KEEP BRANCHING UNTIL INTERRUPT OCCURS ----------------------------------------
WAIT
					NOP
					BRA				WAIT
;--------------------------- INTERRUPT VECTOR TABLE TO GET THE ADDRESS OF INTERRUPT SERVICE ROUTINE -----------------------------------
INTERRUPT
					BTFSC			INTCON,RBIF				; PORTB CHANGE INTERRUPT FLAG
					BRA				TEST					
					BTFSC			INTCON,TMR0IF			; TIMER0 INTERRUPT FLAG
					BRA				ACTIVE
TEST
					BTFSS			PORTA,RA3				; TEST WHICH COLUMN WAS ACTIVATED
					BRA				COLUMN_1
					BTFSS			PORTA,RA2
					BRA				COLUMN_2
					BTFSS			PORTA,RA1
					BRA				COLUMN_3
					BTFSS			PORTA,RA0
					BRA				COLUMN_4
COLUMN_1													
					BTFSS			PORTB,RB4		;	 TEST WHICH INPUT WAS TRIGGERED FROM HIGH TO LOW
					BRA				AB
					BTFSS			PORTB,RB5
					BRA				CD
					BTFSS			PORTB,RB6
					BRA				EF
					BTFSS			PORTB,RB7
					BRA				GH
COLUMN_2
					BTFSS			PORTB,RB4
					BRA				IJ
					BTFSS			PORTB,RB5
					BRA				KL
					BTFSS			PORTB,RB6
					BRA				MN
					BTFSS			PORTB,RB7
					BRA				OP
COLUMN_3
					BTFSS			PORTB,RB4
					BRA				QR
					BTFSS			PORTB,RB5
					BRA				ST
					BTFSS			PORTB,RB6
					BRA				UV
					BTFSS			PORTB,RB7
					BRA				WX
COLUMN_4
					BTFSS			PORTB,RB4
					BRA				YZ
					BTFSS			PORTB,RB5
					BRA				CLEAR
					BTFSS			PORTB,RB6
					BRA				CHANGE
;-------------------- ACTIVATING ONE COLUMN PER 30 MS -----------------------------------------
ACTIVE
					BCF				INTCON,TMR0IF
					MOVLW			0x8A
					MOVWF			TMR0H
					MOVLW			0xD0
					MOVWF			TMR0L
					MOVF			VALUE,W
					XORLW			0x00
					BZ				FIRST
					MOVF			VALUE,W
					XORLW			0x01
					BZ				SECOND	
					MOVF			VALUE,W
					XORLW			0x02
					BZ				THIRD
					MOVLW			0x00
					MOVWF			VALUE
					BCF				PORTA,RA3
					BSF				PORTA,RA2
					BSF				PORTA,RA1
					BSF				PORTA,RA0
					RETFIE
FIRST
					MOVLW			0x01
					MOVWF			VALUE
					BSF				PORTA,RA3
					BSF				PORTA,RA2
					BSF				PORTA,RA1
					BCF				PORTA,RA0
					RETFIE
SECOND
					MOVLW			0x02
					MOVWF			VALUE
					BSF				PORTA,RA3
					BSF				PORTA,RA2
					BCF				PORTA,RA1
					BSF				PORTA,RA0
					RETFIE	
THIRD
					MOVLW			0x03
					MOVWF			VALUE
					BSF				PORTA,RA3
					BCF				PORTA,RA2
					BSF				PORTA,RA1
					BSF				PORTA,RA0
					RETFIE			
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (A AND B) ---------------------------------------
AB
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				HERE
					MOVLW			0x3B
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
HERE
					MOVLW			0x3C
					MOVWF			PORTC
					MOVLW			0x2A
					MOVWF			PORTD
					RETFIE				
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (C AND D) ---------------------------------------
CD
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				HER
					MOVLW			0x27
					MOVWF			PORTC
					MOVLW			0x00
					MOVWF			PORTD
					RETFIE
HER
					MOVLW			0x3C
					MOVWF			PORTC
					MOVLW			0x22
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (F AND E) ---------------------------------------
EF
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				HE
					MOVLW			0x27
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
HE
					MOVLW			0x23
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (G AND H) ---------------------------------------
GH
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TESTING
					MOVLW			0x1B
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
TESTING
					MOVLW			0x2F
					MOVWF			PORTC
					MOVLW			0x28
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (I AND J) ---------------------------------------
IJ
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TESTIN
					MOVLW			0x24
					MOVWF			PORTC
					MOVLW			0x22
					MOVWF			PORTD
					RETFIE
TESTIN
					MOVLW			0x1E
					MOVWF			PORTC
					MOVLW			0x00
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (K AND L) ---------------------------------------
KL
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TESTI
					MOVLW			0x07
					MOVWF			PORTC
					MOVLW			0x00
					MOVWF			PORTD
					RETFIE
TESTI
					MOVLW			0x03
					MOVWF			PORTC
					MOVLW			0x94
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (M AND N) ---------------------------------------
MN
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TESTT
					MOVLW			0x1B
					MOVWF			PORTC
					MOVLW			0x05
					MOVWF			PORTD
					RETFIE
TESTT
					MOVLW			0x1B
					MOVWF			PORTC
					MOVLW			0x11
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (O AND P) ---------------------------------------
OP
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TES
					MOVLW			0x3F
					MOVWF			PORTC
					MOVLW			0x00
					MOVWF			PORTD
					RETFIE
TES
					MOVLW			0x33
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (R AND Q) ---------------------------------------
QR
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TE
					MOVLW			0x3F
					MOVWF			PORTC
					MOVLW			0x10
					MOVWF			PORTD
					RETFIE
TE
					MOVLW			0x33
					MOVWF			PORTC
					MOVLW			0x98
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (S AND T) ---------------------------------------
ST
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TESTNG
					MOVLW			0x2D
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
TESTNG
					MOVLW			0x20
					MOVWF			PORTC
					MOVLW			0x22
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (C AND D) ---------------------------------------
UV
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TETING
					MOVLW			0x1F
					MOVWF			PORTC
					MOVLW			0x00
					MOVWF			PORTD
					RETFIE
TETING
					MOVLW			0x03
					MOVWF			PORTC
					MOVLW			0x44
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (X AND W) ---------------------------------------
WX
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				ESTING
					MOVLW			0x0A
					MOVWF			PORTC
					MOVLW			0x50
					MOVWF			PORTD
					RETFIE
ESTING
					MOVLW			0x00
					MOVWF			PORTC
					MOVLW			0x55
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE FOR DISPLAYING ASCII CODE OF (Y AND Z) ---------------------------------------
YZ
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				TSTING
					MOVLW			0x1D
					MOVWF			PORTC
					MOVLW			0x88
					MOVWF			PORTD
					RETFIE
TSTING
					MOVLW			0x24
					MOVWF			PORTC
					MOVLW			0xCC
					MOVWF			PORTD
					RETFIE
;---------------------- SUBROUTINE TO CLEAR THE OUTPUT ---------------------------------------
CLEAR
					BCF				INTCON,RBIF
					CLRF			PORTC
					CLRF			PORTD
					MOVF			PORTB,W
					RETFIE
;---------------------- SUBROUTINE TO CHANGE THE KEYPAD TO SECOND FACE ---------------------------------------
CHANGE
					MOVF			PORTB,W
					BCF				INTCON,RBIF
					MOVF			CHOOSE,W
					XORLW			0x00
					BZ				CHANGING
					MOVLW			0x00	
					MOVWF			CHOOSE
					RETFIE
CHANGING
					MOVLW			0x01
					MOVWF			CHOOSE	
					RETFIE
;---------------------- END ---------------------------------------
					END
