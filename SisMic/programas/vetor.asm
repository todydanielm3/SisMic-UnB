ordv:		mov.b		#vetor,R5			;coloca em R5 o indereço de inico de um vetor
				call		#loop				;chamar loop

loop:		mov.b		#12,R9				;contador
				mov.b		#1,R6				;R6 inicia com 1
				clr			R5					;R5 inicia com 0
				call		#ordena				;chama	ordena

ordena:		add.b		#1,R5				;adiciona 1 em R5 (R5 = 1)
					add.b		#1,R6				;adiciona 1 em R6 (R6 = 2)
					cmp.b		vetor(R5),vetor(R6)	;compara valor no indice R5 do vetor com o valor no indice R6 do vetor (R6 referencia)
					jlo	 		troca1				;condição, se o valor contido no indice R6 for menor --> trocar
					dec			R9					;decrementa um do contador
					jnz			ordena				;se contador for diferente de 0 --> volta para ordena
					jmp			$


troca1:		mov.b		vetor(R5),R7		;colocar o valor do vetor de indice R5 em R7
			mov.b		vetor(R6),R8		;colocar o valor do vetor de indice R6 em R8
			mov.b		R8,vetor(R5)		;colocar R8 no valor do vetor de indice R5
			mov.b		R7,vetor(R6)		;colocar R7 no valor do vetor de indice R6
			call		#loop


			.data
vetor:		.byte		12,"DANIELMORAES"	;vetor de tamanho 12
