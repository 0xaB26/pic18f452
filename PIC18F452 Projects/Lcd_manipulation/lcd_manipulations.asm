;---------------------------------------------------------------------------------------------
; CREATOR : DALI FETHI ABDELLATIF		
; DATE : 13/05/2024
; MICROCONTROLLER : MICROCHIP PIC18F452
; IDE : MPLAB IDE v8.91
; LANGUAGE : ASSEMBLY LANGUAGE
;---------------------------------------------------------------------------------------------
; SIMPLE PROGRAM TO DISPLAY AND SHIFT THE STRING ("HELLO AND GOOD MORNING") ON AN LCD 16*2
; THE CODE WAS TESTED ON PROTEUS WORKS CORRECT 
;---------------------------------------------------------------------------------------------
; BASIC OF LCD :
; TO COMMUNICATE TO AN LCD YOU HAVE TO KNOW SOME COMMANDS
; COMMANDS ALLOW MICROCONTROLLER TO COMMUNICATE WITH LCD
; FIRST OF ALL WE NEED TO MAKE AN INITIALIZATION BY PROVIDING THE NUMBER OF LINE, THE PIXELS, CLEARING THE ENTIRE SCREEN
; AFTER MAKING INITIALIZATION YOU CAN SEND ANY DATA YOU WANT IN FORM OF ASCII
; TO LET THE LCD CONTROLLER RECEIVE THE DATA OR COMMAND WE NEED TO FOLLOW SOME STEPS : 
; FOR COMMANDS :
				; RS = 0;
				; RW = 0
				; EN = PULSE HIGH TO LOW
; FOR DATA :
				; RS = 1;
				; RW = 0;
				; EN = PULSE HIGH TO LOW
; AFTER SENDING A COMMAND OR DATA WE NEED EITHER TO WAIT A TIME OR TESTING THE BUSYFLAG
; BUSYFLAG INDICATE IF THE LCD CONTROLLER IS READY TO ACCEPT NEW DATA OR COMMAND OR IS BUSY PROCESSING THE PREVIOUS DATA OR COMMAND
; JUST BY KNOWING THE PROTOCOL OF COMMUNICATION WITH THE LCD YOU CAN DISPLAY WHATEVEV YOU WANT
;---------------------------------------------------------------------------------------------
					CONFIG		WDT = OFF
					#INCLUDE	<p18f452.inc>
					LIST		P = 18F452
;---------------------------------------------------------------------------------------------
#DEFINE 			RS			PORTC,RC0
#DEFINE 			RW			PORTC,RC1
#DEFINE 			EN			PORTC,RC2
;---------------------------------------------------------------------------------------------
COUNTER				EQU			0x00
;---------------------------------------------------------------------------------------------
					ORG			0x00F00
DISPL				DB			"HELLO AND GOOD MORNING\0"									; STORING THIS STRING IN PROGRAM MEMORY
;---------------------------------------------------------------------------------------------
					ORG			0x00000			
					CLRF		TRISD	; MAKE THE PORTD AS OUTPUT
					MOVLW		0xF8	
					MOVWF		TRISC 	; MAKE THE PORTC(RC0, RC1, RC2) AS OUTPUT
					CALL		INITIALIZATION	; INITIALIZE THE LCD
					CALL		DISPLAY			; DISPLAY THE STRING ON THE LCD
					CLRF		COUNTER			; CLEAR THE COUNTER
;---------------------------------------------------------------------------------------------
WAIT	
					CALL		DELAY_250_MS
					MOVLW		0x18
					MOVWF		PORTD
					CALL		COMMAND
					CALL		BUSY_FLAG	
					INCF		COUNTER,F
					MOVF		COUNTER,W
					XORLW		D'22'
					BNZ			WAIT		
					MOVLW		0x01	
					MOVWF		PORTD
					CALL		COMMAND
					CALL		DELAY_250_MS
					CALL		DISPLAY
					CLRF		COUNTER
					GOTO		WAIT					
;---------------------------------------------------------------------------------------------
DISPLAY
					MOVLW		0x0F			
					MOVWF		TBLPTRH
					MOVLW		0x00
					MOVWF		TBLPTRL
REPEAT
					TBLRD*+					; FITCH THE FIRST CHARACTER FROM THE $00F00
					MOVF		TABLAT,W	
					XORLW		'\0'		; IF THE CHARACTER IS '\0' THEN RETURN, ELSE DISPLAY IT ON PORTD
					BTFSC		STATUS,Z
					RETURN
					MOVF		TABLAT,W
					MOVWF		PORTD
					CALL		DATTA
					CALL		BUSY_FLAG	; TEST THE BUSY FLAG (MAKE SURE THAT THE LCD IS READY TO ACCEPT NEW DATA OR COMMAND
					GOTO		REPEAT				
;---------------------------------------------------------------------------------------------
INITIALIZATION
					CALL		DELAY_250_MS
					MOVLW		0x38		; TWO LINES 	
					MOVWF		PORTD
					CALL		COMMAND
					CALL		DELAY_1_60_MS
					MOVLW		0x01		; CLEAR SCREEN
					MOVWF		PORTD
					CALL		COMMAND
					CALL		DELAY_1_60_MS		
					MOVLW		0x0C		; DISPLAY ON, CURSOR OFF
					MOVWF		PORTD
					CALL		COMMAND
					CALL		DELAY_1_60_MS
					RETURN		
;-------------------------- THIS CHECKS THE BUSY FLAG ?---------------------------------------
BUSY_FLAG
					BSF				TRISD,RD7	
					BCF				RS
					BSF				RW
WAITT
					BCF				EN
					RCALL			DELAY_3000_NS
					BSF				EN
					BTFSC			PORTD,RD7
					GOTO			WAITT
					BCF				EN
					BCF				TRISD,RD7
					RETURN
;---------------------------- HERE WE ENABLE THE LCD CONTROLLER TO RECEIVE COMMANDS -------------------------------------
COMMAND
					BCF				RS
					BCF				RW
					BSF				EN
					RCALL			DELAY_3000_NS
					BCF				EN
					RETURN
;---------------------------- HERE WE ENABLE THE LCD CONTROLLER TO RECEIVE DATAS -------------------------------------
DATTA
					BSF				RS
					BCF				RW
					BSF				EN
					RCALL			DELAY_3000_NS
					BCF				EN
					RETURN	
;--------------------------- GENERATING A DELAY OF 250 MS ------------------------------------------------------------------------
DELAY_250_MS
					MOVLW			0x01
					MOVWF			T0CON
					MOVLW			0x0B
					MOVWF			TMR0H
					MOVLW			0xDC
					MOVWF			TMR0L
					GOTO			TIMER_CALCULATING
;--------------------------- GENERATING A DELAY OF 3000 NS --------------------------------------------------------------------
DELAY_3000_NS
					MOVLW			0x48
					MOVWF			T0CON
					MOVLW			0xFD
					MOVWF			TMR0L
					GOTO			TIMER_CALCULATING
;--------------------------  GENERATING A DELAY OF 1.60 MS -------------------------------------------------------------------------
DELAY_1_60_MS
					MOVLW			0x42
					MOVWF			T0CON
					MOVLW			0x38
					MOVWF			TMR0L
					GOTO			TIMER_CALCULATING
;------------------------- GENERATING TIME BY TIMER0 ----------------------------------------
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