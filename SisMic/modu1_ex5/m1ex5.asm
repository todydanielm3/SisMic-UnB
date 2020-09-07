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
main:		mov		#0x2400,R5
			mov		#0x2410,R6
			mov		#0x2420,R7
			mov.w	#vetor1,R5
			mov.w	#vetor2,R6
			mov.w	#vetorS,R7
			call	#sum16
			jmp		$

sum16:		mov		@R5,R8			;tamnho dos vetores
adic:		add		#2,R5
			add		#2,R6
			add		#2,R7
soma:		add		0(R5),0(R6)
			mov		0(R6),0(R7)
			dec		R8
			jnz		adic
			ret


			.data
vetor1:		.word		3,65000, 50054,26472
vetor2:		.word		3,226,3400,26472
vetorS:		.word		3,00000,00000,00000
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
            
