;-------------------------------------------------------------------------------
; Brasília, 29 de Março de 2018
; Sistemas Microprocessados - Teoria - 2018/1
; Gabarito da prova 1 - Questão 1
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
; Program section : Flash Memory
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
main:
			mov.w	#vetor,R4				; R4 é o ponteiro do vetor de entrada
			mov.w	#resultado,R10			; R10 aponta para o vetor resultante
			mov.b	@R4+,R7					; R7 tem o número de elementos
			mov.w	R7,0(R10)				; Copia o número de elementos
			inc.w	R10						; para o resultado e avança um byte.
loop:
			mov.b	@R4+,R5					; x
			mov.b	@R4+,R6					; y
			call	#inOrOut				; Está dentro ou fora?
			mov.b	R8,0(R10)				; resultado vai para o vetor resultante
			inc.w	R10
			dec.b	R7						; Decrementa o número de elementos
			jnz		loop					; itera enquanto houver elementos

			jmp		$						; fim

; ------------------------------------------------------------------------------
dentroOuFora:
			mov.w	R5,R8					; x^2
			call	#pow2					;
			mov.w	R9,R12					; salva em R12
			mov.w	R6,R8					; y^2
			call	#pow2					;
			mov.w	R9,R13					; salva em R13
			add.w	R12,R13					; x^2 + y^2
			cmp		#6400,R13				; x^2 + y^2 < 80^2 ?
			jlo		dentro					; se R13 for menor, então está dentro
fora:
			mov.w	#0,R8					; Se estiver fora, retorna 0
			ret								;
dentro:
			mov.w	#1,R8					; Se estiver dentro, retorna 1
			ret								;

; ------------------------------------------------------------------------------
pow2:
			bit.b	#BIT7,R8				; Verifica se o número é neg.
			jnc		pow2Pos					; Se for positivo, realiza a mult
pow2Neg:
			xor.b	#0xFF,R8				; Se for negativo, transformar em
			inc.b	R8						; positivo: Inverte e soma 1.
pow2Pos:
			mov.w	R8,&MPYS				; Usar o multiplicador dedicado
			mov.w	R8,&OP2					; para palavras de 16-bits com sinal
			mov.w	&RES0,R9				; resultado em R9
			ret

;-------------------------------------------------------------------------------
; Data section: RAM memory
;-------------------------------------------------------------------------------
			.data
vetor		.byte	4, 19,53, -107,-125		; Vetor de pontos
			.byte	79,-79,   90,-10		; em duas linhas
resultado	.word	0,0,0,0,0				; Vetor resultante

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
