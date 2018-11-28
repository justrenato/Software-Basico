#----------------------------
#UFPR 
#Arylson Arruda Bueno
#GRR20111066
#Software Básico
#Gerenciador de HEAP
#----------------------------

.section	.data

inicio_heap:	.long 0
heap_atual:		.long 0				#endereco do ultimo setor

.equ		TEST, 4

.equ		TAM_HEADER, 16
.equ		HEADER_STATUS_POS, 0
.equ		HEADER_TAM_POS, 4
.equ		HEADER_PREV_POS, 8
.equ		HEADER_NEXT_POS, 12
.equ        BUSY, 0
.equ        FREE, 1
.equ        PARAMETRO_1, 8

# Strings utilizadas pela função printf
inicioHeap:    		 .string "Inicio heap: %p\n"
segmento_ocupado:    .string "Segmento %d: %d bytes ocupados\n"
segmento_livre:      .string "Segmento %d: %d bytes livres\n"
segOcupados:    	 .string "Segmentos ocupados: %d / %d bytes\n"
segLivres:      	 .string "Segmentos livres: %d / %d bytes\n"
memMapFree:			 .string "|  %d  "
memMapBusy:			 .string "|--%d--"
memMapEnd:			 .string "|\n"
memMapVal:			 .string "%d - %d\n"

debug1: 	    	 .string "Debug %d\n"
debug2: 	    	 .string "test split pedido %d eax %d restante %d\n"
debug2a: 	    	 .string "extend pedido %d eax %d restante %d\n"
debug2b: 	    	 .string "split pedido %d eax %d restante %d\n"
debug4: 	    	 .string "Defrag %d\n"
debug5: 	    	 .string "Ultimo setor %d +%d!!! \n"
debug6: 	    	 .string "heap %d eax %d ebx %d ecx %d \n"
debug9: 	    	 .string "space insuficient %d / %d \n"
debug10: 	    	 .string "running %d %d %d\n"
debug3: 	    	 .string "split ecx %d eax %d \n"
debug7: 	    	 .string "test split val %d \n"
debug11: 	    	 .string "mata %d ecx %d ebx %d eax %d \n"

debug8: 	    	 .string "A nexting tam %d eax %d ecx %d\n"
debug8b: 	    	 .string "B nexting tam %d eax %d ecx %d\n"
debug8c: 	    	 .string "C nexting tam %d eax %d ecx %d\n"
debug8d: 	    	 .string "D nexting tam %d eax %d ecx %d\n"

.section        .text

.globl  meuAlocaMem
.type   meuAlocaMem, @function

#----------------------------
#meuAlocaMem
#----------------------------

meuAlocaMem:
        pushl   %ebp
        movl    %esp, %ebp

        #Se a heap esta NULL
        init:
                cmpl    $0, inicio_heap
                jne     end_init
                cmpl    $0, heap_atual
                jne     end_init

                movl    $0, %ebx							# %ebx = 0 retorna brk em %eax
                movl    $45, %eax							#Chamada para a BRK																
                int     $0x80
                movl    %eax, heap_atual        			# heap_atual <- %eax
				pushl	%eax

	            movl    %eax, %ebx							# %ebx novo tamanho da heap - %eax old end heap
				addl    $TAM_HEADER, %ebx					# %ebx = %eax + TAM_HEADER
	            movl    $45, %eax							# Chamada para a BRK	
                int     $0x80

                cmpl    $0, %eax							# Verifica erro de alocacao
                je      error

				popl	%eax
                incl    %eax								# Inicio da heap inc 1
				movl    $BUSY, HEADER_STATUS_POS(%eax)  	# seta ocupado
				movl    $0, HEADER_PREV_POS(%eax)  			# anterior n existe
				movl    $0, HEADER_NEXT_POS(%eax)  			# proximo n existe
				movl    PARAMETRO_1(%ebp), %ecx   			# Espaco desejado
				movl    %ecx, HEADER_TAM_POS(%eax)     		# seta tamanho
				
                movl    %eax, heap_atual        			# heap_atual <- %ebx
                movl    %eax, inicio_heap					# inicio_heap <- %eax

				jmp		find_sector_free_end
		end_init:
	
				movl    inicio_heap, %eax
				movl    heap_atual, %ebx
				movl    PARAMETRO_1(%ebp), %ecx   # Espaco desejado

        # Busca setor livre de tamanho desejado
        find_sector_free:

            # Verifica se espaco do setor esta livre
            cmpl    $BUSY, HEADER_STATUS_POS(%eax)				
            je      find_sector_free_next

            cmpl    %ecx, HEADER_TAM_POS(%eax)
			jge	 	find_sector_free_run

			find_sector_free_next:

                # Verifica se existe proximo setor
                cmpl    $0, HEADER_NEXT_POS(%eax)
                je      heap_extend

				movl    HEADER_NEXT_POS(%eax), %eax
				jmp		find_sector_free	

        find_sector_free_run:

				# Setor Livre?
				cmpl    $FREE, HEADER_STATUS_POS(%eax)
				je		heap_split

				heap_extend:

#-------------------------------------------------
#		pushl	%eax
#		pushl	%ebx
#		pushl	%ecx
#		pushl   heap_atual
#		pushl   $debug2a
#		call    printf                   
#		addl    $8, %esp      		        
#		popl	%ecx
#		popl	%ebx
#		popl	%eax
#-------------------------------------------------

			        movl    heap_atual, %eax					# %eax = fim da heap atual
			        movl    heap_atual, %ebx				
					addl    $TAM_HEADER, %ebx					# %ebx += header do setor atual
					addl    HEADER_TAM_POS(%eax), %ebx			# %ebx += posicao do novo setor 

					pushl   %ebx	     			    		# guarda retorno

					addl    %ecx, %ebx							# %ebx += tamanho do novo setor
					addl    $TAM_HEADER, %ebx					# %ebx += header do novo setor

			        movl    $45, %eax							# Chamada para a BRK	
		            int     $0x80

					popl	%eax								# pega retorno da pilha

					movl    $BUSY, HEADER_STATUS_POS(%eax) 		#seta ocupado
					movl    %ecx, HEADER_TAM_POS(%eax)     		#seta tamanho
			        movl    heap_atual, %edx					#carrega antigo ultimo
					movl    %edx, HEADER_PREV_POS(%eax)  		#anterior do novo setor recebe antigo ultimo  
					movl    $0, HEADER_NEXT_POS(%eax)	 		#novo setor n tem proximo
					movl	%eax, HEADER_NEXT_POS(%edx)  		#prox do anterior recebe novo setor
					movl    %eax, heap_atual					#heap_atual <- %ebx
					jmp		find_sector_free_end	

				heap_split:

#-------------------------------------------------
#		pushl	%eax
#		pushl	%ebx
#		pushl	%ecx
#		pushl   heap_atual
#		pushl   $debug2b
#		call    printf                   
#		addl    $8, %esp      		        
#		popl	%ecx
#		popl	%ebx
#		popl	%eax
#-------------------------------------------------

					#split do setor em %eax
					movl	HEADER_TAM_POS(%eax), %ebx
					movl	%ecx, HEADER_TAM_POS(%eax)			#tamanho de %eax <- %ecx
					movl	$BUSY, HEADER_STATUS_POS(%eax)		# %eax <- busy
					subl	%ecx, %ebx							# %ebx = TAM(%eax) - %ecx

					#se sobrar espaço p header, cria setor inativo (%ebx > HEADER_SIZE)
					cmpl	$TAM_HEADER, %ebx
					jle		nao_sobrou

					sobrou:
						subl	$TAM_HEADER, %ebx
						movl	%ebx, %ecx							# ecx com dados restante
						movl	%eax, %ebx							
						addl	HEADER_TAM_POS(%eax), %ebx			# %ebx = %eax + tam(%eax)
						addl	$TAM_HEADER, %ebx					# %ebx += HEADER_SIZE
						movl	HEADER_NEXT_POS(%eax), %edx			# reorganiza links
						movl	%edx, HEADER_NEXT_POS(%ebx)			# sobra recebe proximo do antigo
						movl	%ebx, HEADER_NEXT_POS(%eax)			# antigo recebe sobra como proximo
						movl	%eax, HEADER_PREV_POS(%ebx)			# sobra recebe anterior como antigo
						movl	$FREE, HEADER_STATUS_POS(%ebx)		# %ebx <- $free
						movl	%ecx, HEADER_TAM_POS(%ebx)			# TAM(%eax) <- %ebx - 16
						jmp		find_sector_free_end

					#senaum une restante ao setor splited
					nao_sobrou:
						addl	%ebx, HEADER_TAM_POS(%eax)			# TAM(%eax) += %ebx					

#----------------------------------------------------								

        find_sector_free_end:

				# Saindo da funcao chamada pelo programa em C
                movl    %ebp, %esp
                popl    %ebp
                ret

		error:
				movl    $0, %eax
				jmp 	find_sector_free_end
				

#----------------------------
#meuLiberaMem
#----------------------------

.globl meuLiberaMem
.type meuLiberaMem, @function
.equ PARAMETRO, 4
meuLiberaMem:

		movl    PARAMETRO(%esp), %ecx   # Setor para free

        #Localiza posicao do valor ->free e seta 1
		movl    $FREE, HEADER_STATUS_POS(%ecx)

		#Se setor liberado é primeiro setor não é necessario ver_anterior
		cmpl    %ecx, inicio_heap
		je		verifica_proximo
		
		#Verifica ANTERIOR ao que esta sendo liberado
		verifica_anterior:

		cmpl    %ecx, inicio_heap					#se setor liberado nao for o primeiro
		je		verifica_proximo

		movl	HEADER_PREV_POS(%ecx), %eax			#anterior esta livre?
		cmpl	$FREE, HEADER_STATUS_POS(%eax)
		jne		verifica_proximo

			movl	HEADER_NEXT_POS(%ecx), %ebx			#carrega next
			movl	%ebx, HEADER_NEXT_POS(%eax)			#prev recebe next

			cmpl	$0, %ebx
			je		nao_existe_prox
			movl	%eax, HEADER_PREV_POS(%ebx)			#prox muda anterior

			nao_existe_prox:	
			movl	HEADER_TAM_POS(%ecx), %ebx			#tamanho do anterior += tamanho do liberado
			addl	$TAM_HEADER, %ebx					#tamanho do anterior += tam header
			addl	%ebx, HEADER_TAM_POS(%eax)

			cmpl	heap_atual, %ecx					#verifica se eh ultimo
			je		ajustes_heap_atual

			movl	HEADER_NEXT_POS(%ecx), %ebx			#ajuste PREV do proximo
			movl	%ebx, HEADER_PREV_POS(%eax)			

			ajustes_heap_atual:

			movl	HEADER_PREV_POS(%ecx), %eax
			movl	%eax, heap_atual					#proximo do liberado <- proximo do anterior
			jmp		defrag
		
		#Verifica PROXIMO ao que esta sendo liberado
		verifica_proximo:

		cmpl    %ecx, heap_atual					#se setor liberado nao for o ultimo
		je		defrag

		movl	HEADER_NEXT_POS(%ecx), %eax			#proximo esta livre?
		cmpl	$FREE, HEADER_STATUS_POS(%eax)
		jne		defrag
										
		movl	HEADER_NEXT_POS(%ecx), %eax			#proximo do liberado <- proximo do proximo
		movl	HEADER_NEXT_POS(%eax), %ebx			
		movl	%ebx, HEADER_NEXT_POS(%ecx)
		movl	HEADER_TAM_POS(%eax), %ebx			# tamanho do proximo
		addl	$TAM_HEADER, %ebx					# += tam header
		addl	%ebx, HEADER_TAM_POS(%ecx)

		defrag:

		#Defragmentacao - Verica se ultimo setor esta free e libera espaço na heap
		movl    heap_atual, %ecx
		cmpl	$FREE, HEADER_STATUS_POS(%ecx)		#ultimo setor = free
		jne		fim_libera

		reset_heap:

#-------------------------------------------------
#		pushl	%eax
#		pushl	%ebx
#		pushl	%ecx
#		pushl   heap_atual
#		pushl   $debug11
#		call    printf                   
#		addl    $8, %esp      		        
#		popl	%ecx
#		popl	%ebx
#		popl	%eax
#-------------------------------------------------

		movl    heap_atual, %ebx					# %ebx += header do novo setor
		movl	HEADER_PREV_POS(%ebx), %eax			# carrega novo ultimo
		movl	$0, HEADER_NEXT_POS(%eax)
		movl	%eax, heap_atual
		movl	%eax, %ebx
		addl	HEADER_TAM_POS(%ebx), %ebx
		addl	$TAM_HEADER, %ebx
	    movl    $45, %eax							# Chamada para a BRK	
        int     $0x80

#		movl	$0, inicio_heap
#		movl	$0, heap_atual

		fim_libera:		
        ret											#Retorno

#----------------------------
#imprMapa
#----------------------------
imprMapaDetalhado:

			movl    inicio_heap, %eax
			cmpl	$0, %eax				# Heap n iniciada
			je		end_imprMapaDetails_null

			do_next_detail:

				cmpl    $BUSY, HEADER_STATUS_POS(%eax)
				je		detail_ocupado

				detail_livre:

				    pushl   %eax
				    pushl   HEADER_TAM_POS(%eax) 		# Tam Setor
				    pushl   $memMapFree		            # Empilha a string que será impressa na tela
				    call    printf                   
				    addl    $8, %esp      		        # Restaura a pilha das variáveis usadas para o printf
				    popl    %eax

					jmp		end_detail
				detail_ocupado:

				    pushl   %eax
				    pushl   HEADER_TAM_POS(%eax) 		# Tam Setor
				    pushl   $memMapBusy		            # Empilha a string que será impressa na tela
				    call    printf                   
				    addl    $8, %esp      		        # Restaura a pilha das variáveis usadas para o printf
				    popl    %eax

				end_detail:	

				cmpl    $0, HEADER_NEXT_POS(%eax)
				je		end_imprMapaDetails
				movl	HEADER_NEXT_POS(%eax), %eax
				jmp		do_next_detail

			end_imprMapaDetails:

		    pushl   $memMapEnd		            # Empilha a string que será impressa na tela
		    call    printf                   
		    addl    $4, %esp      		        # Restaura a pilha das variáveis usadas para o printf

			end_imprMapaDetails_null:
            ret                            		# Termina a função

.globl imprMapa
.type imprMapa, @function
imprMapa:
            pushl   %ebp
            movl    %esp, %ebp

            subl    $28, %esp
            movl    $1, -4(%ebp)            # i = -4(%ebp)
            movl    $0, -8(%ebp)            # o = -8(%ebp)
            movl    $0, -12(%ebp)           # Total memoria livre
            movl    $0, -16(%ebp)           # Total memoria ocupada
            movl    $0, -20(%ebp)           # Total memoria

			movl    inicio_heap, %eax
			movl    heap_atual, %ebx

			cmpl	$0, %eax				# Heap n iniciada
			je		mapa_null
	
            pushl   %eax
            pushl   $inicioHeap             # Empilha a string que será impressa na tela
            call    printf        
            addl    $4, %esp  
			popl	%eax

			do_next_setor:

				cmpl    $BUSY, HEADER_STATUS_POS(%eax)
				je		ocupado

				livre:

		            pushl   %eax                    			# Salva %eax
		            pushl   HEADER_TAM_POS(%eax)    			# Tamanho do setor atual
		            pushl   -4(%ebp)                			# Variável i que tem o nº do segmento atual de memória
		            pushl   $segmento_livre         			# Empilha a string que será impressa na tela
		            call    printf                  			# Já vimos como que tem que "linkar"
		            addl    $12, %esp               			# Restaura a pilha
		            popl    %eax                    			# Restaura %eax

		            addl    $1, -16(%ebp)          				# Inc segmentos livres
		            movl    HEADER_TAM_POS(%eax), %ebx          # Tamanho do setor atual
		            movl    -20(%ebp), %ecx         			# Total Memória livre %ecx
		            addl    %ecx, %ebx              			# Soma
		            movl    %ebx, -20(%ebp)         			# Total memoria livre

					jmp		end_if

				ocupado:

		            pushl   %eax                    			# Salva %eax
		            pushl   HEADER_TAM_POS(%eax)   				# Tamanho do setor atual
		            pushl   -4(%ebp)                			# num setor atual
		            pushl   $segmento_ocupado       			# Empilha a string que será impressa na tela
		            call    printf                  			# Já vimos como que tem que "linkar"
		            addl    $12, %esp               			# Restaura a pilha
		            popl    %eax                    			# Restaura %eax

		            addl    $1, -8(%ebp)            			# Inc segmentos ocupados
		            movl    HEADER_TAM_POS(%eax), %ebx          # Tamanho do setor atual
		            movl    -12(%ebp), %ecx         			# Total Memória ocupada %ecx
		            addl    %ecx, %ebx              			# Soma
		            movl    %ebx, -12(%ebp)         			# Total memoria ocupada

				end_if:	
	            addl    $1, -4(%ebp)            				# Inc num do setor

				cmpl    $0, HEADER_NEXT_POS(%eax)
				je		end_imprMapa
				movl	HEADER_NEXT_POS(%eax), %eax

				jmp		do_next_setor

			end_imprMapa:

            pushl   %eax
            pushl   -12(%ebp)               # Bytes Ocupados
            pushl   -8(%ebp)                # Setores Ocupados
            pushl   $segOcupados            # Empilha a string que será impressa na tela
            call    printf                   
            addl    $12, %esp               # Restaura a pilha das variáveis usadas para o printf
            popl    %eax

            pushl   %eax
            pushl   -20(%ebp)               # Bytes Livres
            pushl   -16(%ebp)               # Setores Livres
            pushl   $segLivres              # Empilha a string que será impressa na tela
            call    printf                   
            addl    $12, %esp               # Restaura a pilha das variáveis usadas para o printf
            popl    %eax

# ----------------- Imprime mapa de valores
#			movl	heap_atual, %ecx
#			addl	$TAM_HEADER, %ecx
#			movl	inicio_heap, %ebx	
#			nextval:
#
#				pushl	%ecx
#				pushl   0(%ebx)
#				pushl	%ebx
#				pushl   $memMapVal
#				call    printf                   
#				addl    $12, %esp      		        
#				popl	%ecx
#
#				incl	%ebx
#				cmpl	%ebx, %ecx
#				jge		nextval
# ----------------- 

			mapa_null:
            addl    $28, %esp               # Restaura a pilha inteira
			movl    %ebp, %esp
            popl    %ebp	

			jmp		imprMapaDetalhado

            ret                             # Termina a função

