;-------------------------------------------------------------------------------
; Bras�lia, 29 de Mar�o de 2018
; Sistemas Microprocessados - Teoria - 2018/1
; Gabarito da prova 1 - Quest�o 2
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

			bic.b	#BIT4,&P2OUT			; Prepara a sa�da padr�o '0'
			bis.b	#BIT4,&P2DIR			; Configura P2.4 como sa�da

; Rebote � um fen�meno indesejado que acontece com chaves mec�nicas. Todo
; acionamento das chaves resulta num ru�do que deve ser levado em considera��o
; quando escrevemos uma rotina que l� os valores das chaves mec�nicas

; Para remover os rebotes � necess�rio aguardar um tempo pr�-definido logo
; ap�s a transi��o de estado da chave para que o ru�do gerado n�o afete o
; funcionamento do programa.

loopInfinito:

s1Solta:									; Trava de execu��o 1
			bit.b	#BIT6,&P1IN				; Verifica o valor do bit -> C
			jnc		s1Solta					; Se o bit estiver em zero, a chave
											; est� solta
alternaLED:
			xor.b	#BIT4,&P2OUT			; Alterna o estado do LED
			call	#removeRebotes			; Gasta um certo tempo do processador

s1Pressionada:								; Trava de execu��o 2
			bit.b	#BIT6,&P1IN				; Verifica se o bit est� habilitado
			jc		s1Pressionada			; Se o bit estiver em 1, a chave
											; continua pressionada
			jmp		loopInfinito

;-------------------------------------------------------------------------------
removeRebotes:								; Rotina que gasta tempo da CPU
			mov.w	#0xFFFF,R5				; Definir o valor empiricamente
conta:		dec.w	R5						; fica no loop at� R5 == 0
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
