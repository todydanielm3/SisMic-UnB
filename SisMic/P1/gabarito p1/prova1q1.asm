;-------------------------------------------------------------------------------
; Sistemas Microprocessados - Prova 1
; Gabarito da quest�o 1
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.

;-------------------------------------------------------------------------------
RESET:      mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:		mov.b	#1,R5					; R5 holds the value of k
				mov.w	#sig1,R6				; Pointer to s1 (16-bit addr)
				mov.w	#sig2,R7				; Pointer to s2 (16-bit addr)
				clr	R8						    ; Clear accumulator R8
				call 	#conv					  ; Call conv subroutine
				jmp	$						      ; Result should be in R8


; ------------------------------------------------------------------------------
; Subroutine conv: Produces k-th element of the convolution vector
; Inputs  : R5(k), R6(sig1), R7(sig2)
; Outputs : R8(result)
conv:
			add		R5,R7					  ; Go to sample s2[k]
convLoop:
			mov.b	@R6+,R13				; Preparing mult operands
			mov.b	@R7,R14					;
			call 	#mult					  ; mult(sig1[j],sig2[k-j]
			add.w	R15,R8					; Save result and accumulate in R8
			tst		R5						  ; Is R5 = 0 ?
			jz		convRet					; If true, return
			dec.w	R5						  ; If not, decrement R5 and R7
			dec.w	R7						  ;
			jmp 	convLoop				; loop while R5 != 0
convRet:
			ret								    ; return
; ------------------------------------------------------------------------------
; Subroutine mult: Multiplies two 8-bit signed operands
; Inputs  : R13(op1), R14(op2)
; Outputs : R15(result)
mult:
			mov.w	#0x0010,&MPY32CTL0		; Signed operation
			mov.b 	R13,&MPYS				; Load operator 1
			mov.b	R14,&OP2				; Load operator 2
			mov.w	&RESLO,R15				; Save result in R15 (16-bits)
			ret

;-------------------------------------------------------------------------------
; RAM memory
;-------------------------------------------------------------------------------
			.data
sig1:		.byte	1,2,3,1,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,1,0,0,0
sig2:		.byte	1,3,2,1,1,2,3,3,2,1,1,2,2,3,3,3,2,2,1,1,0,0,0
