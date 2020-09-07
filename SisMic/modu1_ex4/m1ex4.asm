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
ex4:		 	mov.w		#vetor,R5
				call		#EXTREMOS
				jmp			$

EXTREMOS:		mov			@R5,R8			    	;movendo o conteudo inicial de R5 "o tamanho do vetor em R8
				mov			#-128,R6				;numero que seja menor do que qualquer possibilidade// representaçõe op com sinal intervalo -> [-128:127]
				mov			#-128,R7				;numero que seja maior do que qualquer possibilidade// representaçõe op com sinal intervalo -> [-128:127]
				push		R8
				push		vetor

perc1:			dec			R8
				jz			part2
				add			#2,R5
				cmp			R6,0(R5)
				jlo			refmenor
				jmp			perc1



refmenor:		mov			@R5,R6
				jmp			perc1

;-----------------maior-------------------;
part2:			pop			R8
				pop			vetor


perc2:			dec			R8
				jz			fim
				add			#2,R5
				cmp			R7,0(R5)
				jhs			refmaior


refmaior:		mov			@R5,R7
				jmp			perc2


fim:			ret
;-----------------------ROM----------------------------------------------------
				.data
vetor:			.word	8, -1661, 234, 567, -1660, 117, 867, 45, -1670
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
            
