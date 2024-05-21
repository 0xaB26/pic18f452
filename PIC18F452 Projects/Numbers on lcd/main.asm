;CREATOR : DALI FETHI ABDELLATIF
;EDITED : 21/05/2024
;PLATFORM : PIC18F452
;THIS CODE IS FOR A PIC18F452 INTERFACED WITH EXTERNAL SWTICHES AND LCD 16*2
;THE SWITCHES ARE USED TO ALLOW THE USER TO ENTER NUMBERS AND DISPLAY THEM IN THE LCD
;SWITCHES ALLOW :
;-CLEAR THE SCREEN
;-ENTER NUMBERS FROM 0 TO 9 EACH SWITCH CORRESPONDS TO A NUMBER
;THE CODE WAS TESTED IN PROTEUS AND WORKS WELL 
;--------------------------------------------------------------------------------------------------- 
				CONFIG		WDT = OFF
				#INCLUDE	<p18F452.inc>
				LIST		P = 18F452
;---------------------------------------------------------------------------------------------------
#DEFINE 			RS			PORTC,RC0
#DEFINE 			RW			PORTC,RC1
#DEFINE 			EN			PORTC,RC2
;---------------------------------------------------------------------------------------------------
CBLOCK	0x00
STATE
ETAT
VALUE
COUNTER
VALEUR
ENDC
;---------------------------------------------------------------------------------------------------
					ORG			0x00
					BRA			MAIN				; BRANCH TO MAIN FUNCTION 
					ORG			0x08
					BRA			INTERRUPT			; BRACH TO INTERRUPT VECTOR TABLE WHEN AN INTERRUPT OCCURS
;---------------------------------------------------------------------------------------------------
MAIN
					; MAKE THEM OUTPUT
					CLRF		TRISD
					CLRF		TRISC
					; MAKE IT INPUT
					SETF		TRISB
					; CHANGE PORTA TO DIGITAL PORT
					MOVLW		0x07
					MOVWF		ADCON1
					CLRF		TRISA
					RCALL		INITIALIZATION			; INITIALIZE THE LCD
					BSF			INTCON,GIE				; ACTIVATING THE GLOBAL INTERRUPT
					BSF			INTCON,PEIE				; ACTIVATING PERIPHERAL INTERRUPT ENABLE BIT
					BSF			INTCON,RBIE				; ACTIVATING PORTB CHANGE INTERRUPT 
					BCF			INTCON,RBIF
					BSF			PIE1,TMR1IE				; ACTIVATING TIMER1 INTERRUPT
					BCF			PIR1,TMR1IF
					MOVLW		0xD4					; CONFIGURING THE TIMER1
					MOVWF		T1CON
					MOVLW		0x3C
					MOVWF		TMR1H
					MOVLW		0xB0
					MOVWF		TMR1L
					BSF			T1CON,TMR1ON
					MOVLW		0x01	
					MOVWF		STATE
					MOVLW		0x0E
					MOVWF		LATA
					; CLEAR THE REGISTERS
					CLRF		ETAT		
					CLRF		VALUE
					BCF			VALEUR,0
					CLRF		COUNTER
;---------------------------------------------------------------------------------------------------
WAIT
					BRA		WAIT				; JUMP HERE FOREVER
;---------------------------------------------------------------------------------------------------
INTERRUPT										; INTERRUPT VECTOR TABLE
					BTFSC		PIR1,TMR1IF		; IS THE TIMER1 INTERRUPTS THE MICROCONTROLLER
					BRA			TIMER1			; JUMP TO TIMER1 ISR IF YES
					BTFSC		INTCON,RBIF		; DOES A SWITCH INTERRUPTS THE MICRCONTROLLER	
					BRA			TEST			; JUMP TO TEST ISR
;---------------------------------------------------------------------------------------------------
TEST											
					RCALL		DELAY_50_US		; DEBOUNCING BY WAITING 50 US TO CHECK INPUT
					MOVF		PORTB,W			; THIS TEST SUBROUTINE IS RESPONIBLE ABOUT CHECKING WHICH COLUMN WAS ACTIVE LOW
					BTFSS		LATA,RA0		; IF ONE OF THE COLUMN WAS ACTIVE LOW IF YES : WE GO THE CHECK THE SWITCHS THAT ARE CONNECTED
					BRA			COLUMN_1		; IF WE FOUND ONE OF THE COLUMN IS ACTIVE LOW THEN GO AND FIND WHICH SWITCH WAS THE RESPONSBILE OF INTERRUPTING THE PIC
					BTFSS		LATA,RA1
					BRA			COLUMN_2
					BTFSS		LATA,RA2
					BRA			COLUMN_3
					BTFSS		LATA,RA3
					BRA			COLUMN_4	
COLUMN_1
					BTFSS		PORTB,RB4
					BRA			CLEAR_ALL		
					BTFSS		PORTB,RB5
					BRA			DIGIT_0
					BRA			FINALE_1
COLUMN_2
					BTFSS		PORTB,RB4
					BRA			DIGIT_1
					BTFSS		PORTB,RB5
					BRA			DIGIT_2
					BTFSS		PORTB,RB6
					BRA			DIGIT_3
					BRA			FINALE_1
COLUMN_3
					BTFSS		PORTB,RB4
					BRA			DIGIT_4
					BTFSS		PORTB,RB5
					BRA			DIGIT_5
					BTFSS		PORTB,RB6
					BRA			DIGIT_6
					BRA			FINALE_1
COLUMN_4
					BTFSS		PORTB,RB4
					BRA			DIGIT_7
					BTFSS		PORTB,RB5
					BRA			DIGIT_8
					BTFSS		PORTB,RB6
					BRA			DIGIT_9
					BRA			FINALE_1
;---------------------------------------------------------------------------------------------------
DIGIT_0	
					MOVLW		A'0'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_1	
					MOVLW		A'1'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_2
					MOVLW		A'2'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_3
					MOVLW		A'3'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_4
					MOVLW		A'4'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_5
					MOVLW		A'5'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_6
					MOVLW		A'6'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_7
					MOVLW		A'7'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_8
					MOVLW		A'8'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
DIGIT_9
					MOVLW		A'9'
					MOVWF		PORTD
					RCALL		DATTA
					RCALL		BUSYFLAG
					BRA			FINALE
;---------------------------------------------------------------------------------------------------
CHANGE										; CHANGING THE CHARACTER OF THE SWITCHES(EACH SWTICH HAS THREE CHARACTER CAN BE DISPLAYED)
					BRA			FINALE_1										
;---------------------------------------------------------------------------------------------------
CLEAR_ALL
					RCALL		CLEAR_SECOND_LINE	; CLEAR THE SECOND LINE
					RCALL		CLEAR_FIRST_LINE	; CLEAR THE FIRST LINE
					RCALL		FINALE_1											
;---------------------------------------------------------------------------------------------------
INITIALIZATION									; SUBROUTINE RESPONSINLE ABOUT INITIALIZING THE LCD
					RCALL		DELAY_250_MS	; WAIT 250 MS
					MOVLW		0x38			; TELL THE LCD CONTROLLER I NEED 2 LINES + 5*7 DOT
					MOVWF		PORTD
					RCALL		COMMAND
					RCALL		DELAY_250_MS
					MOVLW		0x01			; CLEAR THE ENTIRE SCREEN
					MOVWF		PORTD
					RCALL		COMMAND
					RCALL		DELAY_250_MS
					MOVLW		0x0F			; DISPLAY ON + CURSOR BLINKING
					MOVWF		PORTD
					RCALL		COMMAND
					RCALL		DELAY_250_MS
					RETURN
;---------------------------------------------------------------------------------------------------
TIMER1											; SUBROUTINE RESPONSIBLE FOR ACTIVATING ONE COLUMN AT TIME(COLUMN IS ACTIVE LOW)
					BCF			PIR1,TMR1IF		
					MOVLW		0x3C
					MOVWF		TMR1H
					MOVLW		0xB0
					MOVWF		TMR1L	
					MOVF		STATE,W
					XORLW		0x00
					BZ			FIRST
					MOVF		STATE,W
					XORLW		0x01
					BZ			SECOND
					MOVF		STATE,W
					XORLW		0x02
					BZ			THIRD
					CLRF		STATE
					MOVLW		0x07
					MOVWF		LATA
					RETFIE					
FIRST
					MOVLW		0x01
					MOVWF		STATE
					MOVLW		0x0E
					MOVWF		LATA
					RETFIE
SECOND
					MOVLW		0x02
					MOVWF		STATE
					MOVLW		0x0D
					MOVWF		LATA
					RETFIE
THIRD
					MOVLW		0x03
					MOVWF		STATE
					MOVLW		0x0B
					MOVWF		LATA
					RETFIE					
;---------------------------------------------------------------------------------------------------
TIMER_CALCULATING									; DELAY ROUTINE WITH THE POLLING METHOD
					BCF				INTCON,TMR0IF
					BSF				T0CON,TMR0ON
TESTX
					BTFSS			INTCON,TMR0IF	
					BRA				TESTX
					BCF				INTCON,TMR0IF
					BCF				T0CON,TMR0ON
					RETURN
;---------------------------------------------------------------------------------------------------
DELAY_250_MS
					MOVLW			0x01
					MOVWF			T0CON
					MOVLW			0x0B
					MOVWF			TMR0H
					MOVLW			0xDC
					MOVWF			TMR0L
					BRA				TIMER_CALCULATING			
;---------------------------------------------------------------------------------------------------
DELAY_3000_NS
					MOVLW			0x48
					MOVWF			T0CON
					MOVLW			0xFD
					MOVWF			TMR0L
					BRA				TIMER_CALCULATING
;---------------------------------------------------------------------------------------------------
DELAY_50_US
					MOVLW			0x48
					MOVWF			T0CON
					MOVLW			D'206'
					MOVWF			TMR0L
					BRA				TIMER_CALCULATING
;---------------------------------------------------------------------------------------------------
COMMAND												; SUBROUTINE FOR COMMANDS 
					BCF				RS
					BCF				RW
					BSF				EN
					RCALL			DELAY_3000_NS
					BCF				EN
					RETURN
;---------------------------------------------------------------------------------------------------
DATTA													; SUBROUTINE FOR DATA
					BSF				RS
					BCF				RW
					BSF				EN
					RCALL			DELAY_3000_NS
					BCF				EN
					RETURN
;---------------------------------------------------------------------------------------------------
BUSYFLAG												; CHECK BUSY FLAG 
					BSF				TRISD,RD7	
					BCF				RS
					BSF				RW
WAITA
					BCF				EN
					RCALL			DELAY_3000_NS
					BSF				EN
					BTFSC			PORTD,RD7
					BRA				WAITA
					BCF				EN
					BCF				TRISD,RD7
					RETURN
;---------------------------------------------------------------------------------------------------	
FINALE													; HERE THIS SUBROUTINE IS RESPONIBLE ABOUT RETURING FROM ISR BY CLEARING THE BIT FLAG AND RETURN TO POSITION
														; WHERE IT WAS INTERRUPTED FIRST
					BTFSC			VALEUR,0			; HERE THE VARIABLE VALEUR IS USED TO ENSURE THAT THE USER ENTERS MAXIMUM CHARACTERS WHCIH IS 16 CHARACTER PER LINE
					BRA				HERER				; ONE THE FIRST LINE IS FULL BY 16 CHARACTER WE FORCE THE LCD TO JUMP TO SECOND LINE AND START ACCEPTING NEW CHAR
					INCF			COUNTER,F			; AND ASLO WHEN THE SECOND LINE IS FULL WE CLEAR THE ENTIRE SCREEN
					MOVF			COUNTER,W			; THIS ALLOWS TO DISPLAY MAXIMUM OF 32 CHAR IN 2 LINES
					XORLW			0x10
					BZ				HERE
FINALE_1
					BCF				INTCON,RBIF
					RETFIE	
HERE			
					RCALL			SECOND_LINE
					CLRF			COUNTER
					BSF				VALEUR,0
					BRA				FINALE_1	
HERER	
					INCF			COUNTER,F
					MOVF			COUNTER,W		
					XORLW			0x10
					BZ				HEREF
					BRA				FINALE_1
HEREF
					RCALL			CLEAR_SECOND_LINE
					RCALL			CLEAR_FIRST_LINE
					CLRF			COUNTER
					BCF				VALEUR,0
					BRA				FINALE_1	
;---------------------------------------------------------------------------------------------------
SECOND_LINE									; JUMP TO SECOND LINE
					MOVLW			0xC0		
					MOVWF			PORTD
					RCALL			COMMAND
					RCALL			BUSYFLAG	
					RETURN		
;---------------------------------------------------------------------------------------------------	
CLEAR_FIRST_LINE							; CLEAR FIRST LINE
					CLRF			VALUE	
					MOVLW			0x80
					MOVWF			PORTD
					RCALL			COMMAND
					RCALL			BUSYFLAG
BACKA
					MOVLW			A' '
					MOVWF			PORTD
					RCALL			DATTA
					RCALL			BUSYFLAG	
					INCF			VALUE,F
					MOVF			VALUE,W	
					XORLW			0x10
					BTFSS			STATUS,Z
					BRA				BACKA
					MOVLW			0x80
					MOVWF			PORTD
					RCALL			COMMAND
					RCALL			BUSYFLAG
					CLRF			VALUE					
					BRA				FINALE
;---------------------------------------------------------------------------------------------------
CLEAR_SECOND_LINE							; CLEAR SECOND LINE
					CLRF			VALUE	
					MOVLW			0xC0
					MOVWF			PORTD
					RCALL			COMMAND
					RCALL			BUSYFLAG
BACK	
					MOVLW			A' '
					MOVWF			PORTD
					RCALL			DATTA
					RCALL			BUSYFLAG	
					INCF			VALUE,F
					MOVF			VALUE,W	
					XORLW			0x10
					BTFSS			STATUS,Z
					BRA				BACK
					MOVLW			0xC0
					MOVWF			PORTD
					RCALL			COMMAND
					RCALL			BUSYFLAG
					CLRF			VALUE					
					BRA				FINALE
;---------------------------------------------------------------------------------------------------
					END