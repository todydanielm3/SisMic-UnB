;-------------------------------------------------------------------------------
; Sistemas Microprocessados - Prova 1
; Gabarito da questão 4
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.

;-------------------------------------------------------------------------------
RESET       mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

init:
			mov		#0xACE1,R5
			mov		#0x3400,R6

main:
			call	#randNum				; Generate a pseudo-random number
			call	#extractNibble			; Extract 3rd nibble
			jmp		main					; loop forever
; ------------------------------------------------------------------------------
; Subroutine randNum: Generate a pseudo-random number
; Inputs  : R5 (seed), R6 (polynom generator)
; Outputs : R5 (next number)
randNum:
			bit		#1,R5
			rrc		R5
			jnc		randNumRet
			xor		R6,R5
randNumRet:
			ret

; ------------------------------------------------------------------------------
; Subroutine extractNibble: Extract 3rd nibble and make it a 1-6 number
; Inputs  : R5
; Outputs : R10 -> extracted number [1-6]

extractNibble:
			mov		R5,R10
			and		#0x0F00,R10				; Mask only 3rd nibble
			swpb	R10						; Swap bytes 0F.00 -> 00.0F
			add		R10,R10					; R10 x 2, cause addr is a
											; multiple of 2
			add		R10,PC					; Switch (R5) case ...
											; ----------------------------------
case0:		jmp		group1					;
case1:		jmp		group1					;
case2:		jmp		group1					;
case3:		jmp		group1					;
case4:		jmp		group1					;
case5:		jmp		group1					;
case6:		jmp		group2					;
case7:		jmp		group2					;
case8:		jmp		group2					;
case9:		jmp		group2					;
caseA:		jmp		group2					;
caseB:		jmp		group2					;
caseC:		jmp		error					; If R5 > 11, sort another number
caseD:		jmp		error					;
caseE:		jmp		error					;
caseF:		jmp		error					;
											; ----------------------------------

group1:		rra		R10						; Adjust R10 --> R10/2
			add		#1,R10					; [0,1,2,3,4,5] : Just add +1
			jmp		end

group2:		rra		R10						; Adjust R10 --> R10/2
			sub		#5,R10					; [6,7,8,9,A,B] : Subtract -5
			jmp 	end

error:		call	#randNum				; [C,D,E,F] : Sort another number
			jmp		extractNibble			; and hope it is a valid one.

end:		ret


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
            
