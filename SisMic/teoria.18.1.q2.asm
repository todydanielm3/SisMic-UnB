;-------------------------------------------------------------------------------
; Brasília, 29 de Março de 2018
; Sistemas Microprocessados - Teoria - 2018/1
; Gabarito da prova 1 - Questão 2
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

config:
			bic.b	#(BIT6|BIT7),&P1DIR		; Configura P1.6 e P1.7 como entradas
			bis.b	#(BIT6|BIT7),&P1REN		; Habilita o resistor
			bic.b	#(BIT6),&P1OUT			; P1.6 -> pull-down
			bis.b	#(BIT7),&P1OUT			; P1.6 -> pull-up

			bic.b	#BIT4,&P2OUT			; Prepara a saída padrão '0'
			bis.b	#BIT4,&P2DIR			; Configura P2.4 como saída

; Rebote é um fenômeno indesejado que acontece com chaves mecânicas. Todo
; acionamento das chaves resulta num ruído que deve ser levado em consideração
; quando escrevemos uma rotina que lê os valores das chaves mecânicas

; Para remover os rebotes é necessário aguardar um tempo pré-definido logo
; após a transição de estado da chave para que o ruído gerado não afete o
; funcionamento do programa.

loopInfinito:

s1Solta:									; Trava de execução 1
			bit.b	#BIT6,&P1IN				; Verifica o valor do bit -> C
			jnc		s1Solta					; Se o bit estiver em zero, a chave
											; está solta
alternaLED:
			xor.b	#BIT4,&P2OUT			; Alterna o estado do LED
			call	#removeRebotes			; Gasta um certo tempo do processador

s1Pressionada:								; Trava de execução 2
			bit.b	#BIT6,&P1IN				; Verifica se o bit está habilitado
			jc		s1Pressionada			; Se o bit estiver em 1, a chave
											; continua pressionada
			jmp		loopInfinito

;-------------------------------------------------------------------------------
removeRebotes:								; Rotina que gasta tempo da CPU
			mov.w	#0xFFFF,R5				; Definir o valor empiricamente
conta:		dec.w	R5						; fica no loop até R5 == 0
			jnz		conta
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
