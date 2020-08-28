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
ex2:		 	mov			#vetor,R5
				call		#menor
				jmp			$

menor:			mov.b		@R5,R8			;movendo o conteudo inicial de R5 "o tamanho do vetor 0x004"em R8
				mov.b		#0x40,R6		;numero que seja maior do que qualquer possibilidade
				clr			R7				;limpando R7

perc1:			inc			R5				;incrementa 1 em R5 ;independente de inc.w ou inc.b ele sempre incrementa UM
				inc			R5
				cmp.b		R6,0(R5) 		;compara a referencia com o atual elemento do vetor onde o valor de R5 aponta
				jeq			igualRef		;se for igual >> igualRef
				jhs			maiorRef		;se elemento do vetor for maior >> maiorRef

				jmp			perc2			;saltar para jmp


maiorRef:		mov.b		@R5,R6			;mover atual conteudo de R5 em R6
				mov.b		#1,R7			;incrementa R7
				jmp			perc2			;saltar para perc2

igualRef:		inc			R7				;incrementa R7

perc2:			dec			R8				;decrementa R8 (tamanho do vetor)
				jnz			perc1			;se diferente de zero volte para perc1
				ret							;retorna para o ultimo lugar onde houve CALL

				.data
vetor:			.word		13,"DANIELMORAESS"

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
            
