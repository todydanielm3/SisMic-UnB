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
main:		mov			#NUM_ROM,R6
			mov			#retorna,R5
			clr			R11
			call		#ROM_ARAB
;incR6:		inc			R6
;			cmp.b		#0,0(R6)
;			jeq			fim1
;
;ROM_ARAB:	cmp.b		0(R6),0(R7)
;			jeq			achou
;			inc			R7
;			cmp			#0x00,0(R7)
;			jeq			incR6
;			jmp			ROM_ARAB
;
;achou:		mov.b		@R6,0(R5)
;			mov			#0x2405,R7
;			inc			R6
;			cmp.b		#0,0(R6)
;			jeq			fim1
;			inc			R5
;			jmp			ROM_ARAB

;fim1:		mov			#0x240d,R5
;			call		#part2

incr:		inc			R6
			cmp.b		#0,0(R6)
			jeq			fim_do_programa

ROM_ARAB:	cmp.b		#0x56,0(R6)
			jhs			XouV
			jeq			XouV
			jlo			cdmi

;''''''''''''''''''''''''''''''''''''''''
XouV:		cmp.b			#0x56,0(R6)
			jeq				cinco
			cmp.b			#0x58,0(R6)
dez:		add				#10,R11
			jmp				incr

cinco:		add				#5,R11
			jmp				incr
;''''''''''''''''''''''''''''''''''''''''

;##########################################
cdmi:
			cmp.b		#0x49,0(R6)
			jeq			um
			cmp.b		#0x4c,0(R6)
			jeq			cinq
			cmp.b		#0x43,0(R6)
			jeq			cem
			cmp.b		#0x44,0(R6)
			jeq			quin
			cmp.b		#0x4d,0(R6)
			jeq			mil

um:			add			#1,R11
			jmp			incr
cinq:		add			#50,R11
			jmp			incr
cem:		add			#100,R11
			jmp			incr
quin:		add			#500,R11
			jmp			incr
mil:		add			#1000,R11
			jmp			incr
;##########################################

fim_do_programa:
			mov			R11,R5
			jmp			$
;----------------------------------------------------------------------------
; Segmento de dados inicializados (0x2400)
;----------------------------------------------------------------------------
					.data
NUM_ROM:			.byte 		"MMXX",0
retorna:			.byte		"RRRR",0

;------TABELA---;
;var1:	 .byte	0X49
;var5:	 .byte	0X56
;var10:	 .byte	0X58
;var50:	 .byte	0X4C
;var100:	 .byte	0X43
;var500:	 .byte	0X44
;var1000: .byte	0x4D
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
            
