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
;;Lembre todos os numeros que é multiplos de 4 é multiplos de 2;;

ex3:			mov		#vetor,R5
				call	#M4M2
fim:			jmp		$

M4M2:
				clr		R6
				clr		R7
				mov.b	@R5,R10
				add.b	#1,R10
				jmp		perc

perc:			inc		R5
				dec		R10
				jz		fim
				mov		#4,R8
				mov		#2,R9
				jmp		loop_sub4

loop_sub4:		add.b	#0,0(R5)
				jz		M4
				push	0(R5)
				push	R8
sub4_x:			sub.b	R8,0(R5)
				jz		M4
				jn		loop_sub2
				jmp		sub4_x


M4:				inc		R6
				inc		R7
				jmp		perc

loop_sub2:		pop		R8
				pop		0(R5)
sub_x:			sub.b	R9,0(R5)
				jz		M2
				jn		perc
				jmp		sub_x

M2:				inc		R6
				jmp		perc


;------------------------ROM----------------------------------------------------
				.data
vetor:			.byte		5,0,16,10,3,2
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
            
