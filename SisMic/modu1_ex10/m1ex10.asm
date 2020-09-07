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
W16_ASC:	mov		#retorna,R5
			mov		#35243,R6
			mov		#6,R8
			mov		#16,R7				;16 bits
			call	#PSC
			jmp		$

fim:		ret

PSC:		dec		R8
			jz		fim
			dec		R7
			push	R6
			and.b	R7,R6				;ISOLA O BIT correspondente ao valor de R7

NIB_ASC:
			cmp		#10,R6
			jhs		letra
			add		#0x30,R6
			jmp		incluir

letra:		add		#0x37,R6
			jmp		incluir

incluir:	mov		R6,0(R5)
			add		#2,R5
			pop		R6
			jmp		PSC


			.data
retorna:

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
            
