;-------------------------------------------------------------------------------
; Sistemas Microprocessados - Prova 1
; Gabarito da quest�o 2
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.

;-------------------------------------------------------------------------------
RESET:      mov.w   #__STACK_END,SP        		; Initialize stackpointer
     		mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:		mov.b	#1,R5					; R5 holds the value of k
			  mov.w	#sig1,R6				; Pointer to s1 (16-bit addr)
		    mov.w	#sig2,R7				; Pointer to s2 (16-bit addr)
			  clr		R8						; Clear accumulator R8
			  call 	#conv					; Call conv subroutine
			  jmp		$						; Result should be in R8


; ------------------------------------------------------------------------------
; Subroutine conv: Produces k-th element of the convolution vector
; Inputs  : R5(k), R6(sig1), R7(sig2)
; Outputs : R8(result)
conv:
			add		R5,R7					; Go to sample s2[k]
convLoop:
			push.b	@R6+,					; Preparing mult operands
			push.b	@R7						;
			call 	#mult					; mult(sig1[j],sig2[k-j]
			pop		R15
			add.w	R15,R8					; Save result and accumulate in R8
			tst		R5						; Is R5 = 0 ?
			jz		convRet					; If true, return
			dec.w	R5						; If not, decrement R5 and R7
			dec.w	R7						;
			jmp 	convLoop				; loop while R5 != 0
convRet:
			ret								; return
; ------------------------------------------------------------------------------
; Subroutine mult: Multiplies two 8-bit signed operands
; Inputs  : from the stack (op1), (op2)
; Outputs : to the stack   (result)
mult:
			mov.w	#0x0010,&MPY32CTL0		; Signed operation
			mov.b 	4(SP),&MPYS				; Load operator 1
			mov.b	2(SP),&OP2				; Load operator 2
			mov.w	&RESLO,4(SP)			; Save result in the stack
			mov.w	0(SP),2(SP)				; Adjust the stack
			incd	SP						; dummy pop
			ret

;-------------------------------------------------------------------------------
; RAM memory
;-------------------------------------------------------------------------------
			.data
sig1:		.byte	1,2,3,1,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,1,0,0,0
sig2:		.byte	1,3,2,1,1,2,3,3,2,1,1,2,2,3,3,3,2,2,1,1,0,0,0

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
