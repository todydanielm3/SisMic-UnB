;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
DELAY1	.equ	12
DELAY2	.equ	34

config:
			bis.b	#BIT0,P1DIR 	;led vermelho

			bis.b	#BIT7,P4DIR		;led verde


ascende_leds:
			bis.b	#BIT0,P1OUT
			bis.b	#BIT7,P4OUT
			call	#ROT_ATZ
			bic.b	#BIT0,P1OUT
			bic.b	#BIT7,P4OUT
			jmp		$

ROT_ATZ:
			mov		#DELAY1,R6
RT1:		mov		#DELAY2,R5
RT2:		dec		R5
			jnz		RT2
			dec		R6
			jnz		RT1
			ret
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
