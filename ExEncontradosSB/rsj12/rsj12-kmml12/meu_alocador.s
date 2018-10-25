.section .data

#--Variaveis_Globais--#

heap_ini: .long 0 			#inicio da heap
break_atual: .long 0 			#posição atual da brk
salvar: .long 0
salvarc: .long 0
salvard: .long 0
memoria: .long 0
soma_seg_livre: .int 0 			#total de segmentos livres
soma_seg_ocupado: .int 0 		#total de segmentos ocupados
soma_mem_livre: .int 0 			#total de memoria livre
soma_mem_ocupado: .int 0 		#total de memoria ocupada
#-----------------------------#	
#--Strings--#

hash: .string "########"
string_inicio: .string "Inicio da Heap: %x \n\0"
string_livre: .string "-"
string_ocupado: .string "*"
livre: .string "Segmentos Livres: %d/%d bytes\n"
ocupado: .string "Segmentos Ocupados: %d/%d bytes\n" 
fim_heap: .string "\n\n\n"
#-----------------------------#	
#--Estrutura--#

.equ TAM_CAB, 8 #tamanho do cabeçalho (é 8 porque 4 bytes são da parte se esta ou nao diposnivel e os outros 4 é do tamanho)
.equ DISP_CAB, 0 # 0 se esta indisponivel e 1 se esta disponivel
.equ SIZE_CAB, 4 #tamanho que será alocado
#-----------------------------#	
#--Constantes--#
	
.equ INDISP, 0 #constante para memoria indisponivel
.equ DISP, 1	#constante para memoria disponivel
.equ BRK, 45	#System call para parar
.equ SYSCALL, 0x80 #constante para memoria indisponivel
#-----------------------------#
.section .text
#-----------------------------#
#--Main--#
#-----------------------------#
#--Meu_Malloc--#
#-----------------------------#
.globl _start

.globl malloc_inicio
.type malloc_inicio, @function
	
malloc_inicio:		#guarda o inicio da heap, quando o alocador é usado pela primeira vez
	
	pushl %ebp		#parte padrão
	movl %esp, %ebp
	
	movl $BRK, %eax		#encontra onde o ponto de parada esta
	movl $0, %ebx		#retorna a ultima posição valida contida em ebx
	int $SYSCALL
	movl %eax, heap_ini		#carrega o inicio da heap
	movl %eax, break_atual		#carrega a pos_atual
	movl %ebp, %esp			#fim da função
	popl %ebp
	ret
	
.globl MeuMalloc
.type MeuMalloc,@function

inicio:
	call malloc_inicio		#chama a função para começar a alocar
	jmp continue			#depois pule para a função que continua 
	
MeuMalloc:
	
	pushl %ebp
	movl %esp, %ebp
	
	cmpl $0, heap_ini 	#confere para ver se não é a primeira que a função é chamada no programa
	je inicio	  	#se for volte para o inicio
	
continue:

	movl TAM_CAB(%ebp), %ecx 	#ecx recebe o quanto ele precisa para alocar

	movl heap_ini, %eax		    #carrega o valor da heap em eax
	movl break_atual, %ebx		#carrega o valor da posição da brk

loop:
	
	cmpl %ebx, %eax				# verifica de ebx é igual a eax, se for pula
	je muda_break				# para a muda_break
	
	movl SIZE_CAB(%eax), %edx		#pega o tamanho da memoria
	cmpl $INDISP, DISP_CAB(%eax) 		#verifica se esta disponivel
	je prox_endereco			 #se nao estiver vá para o proximo endereço
	
	cmpl %ecx, %edx				#verifica se o tamanho pedido é menor que o tamanho de espaço disponivel
	jl prox_endereco			#se nao for, aloque aqui

aloca_nessa_pos:

	movl $INDISP, DISP_CAB(%eax)
	addl $TAM_CAB, %eax			#eax recebe o valor de memoria usavel depois do cabeçalho, que tambem é o valor de retorno
	
	movl %ebp, %esp
	popl %ebp
	ret
	
prox_endereco:

	addl $TAM_CAB, %eax	#o endereço seguinte para verificar é cabeçalho + tamanho do espaço atual, que ainda não esta disponivel
	addl %edx, %eax		#adiciona o tam da memoria que esta sendo usada
	jmp loop

muda_break:

	addl $TAM_CAB, %ebx 	#adiciona cabeçario
	addl %ecx, %ebx 		#adiciona o espaço que foi solicitado
	
	pushl %eax		#empilha eax
	pushl %ecx		#empilha ebx
	pushl %ebx		#empilha edx
	
	movl $BRK, %eax		#pedido de mais mamoria
	int $SYSCALL 		#Retorna eax, com o endereço novo, caso contrario, retorna erro
	cmpl $0, %eax		#verifica se tem zero em eax
	je erro			#se sim, vá para a função de erro
	
	popl %ebx		#desempilha edx
	popl %ecx		#desempilha ebx
	popl %eax		#desempilha eax 
	
	movl $INDISP, DISP_CAB (%eax)	#marca como indisponivel
	movl %ecx, SIZE_CAB (%eax)		#coloca o tamanho que foi alocado
	addl $TAM_CAB, %eax
	
	movl %ebx, %edx		#monta o outro cabeçalho
	addl $8, %edx 		#adiciona cabeçario
	movl $INDISP, DISP_CAB (%edx)  #marca como indisponivel
	movl %ecx, SIZE_CAB(%edx) #coloca o tamanho que foi alocado
	
	movl %edx, break_atual 		#atualiza o tamanho atual da brk
	
	movl %ebp, %esp
	popl %ebp
	ret

erro:
	movl $0, %eax 		#retorna zero
	movl %ebp, %esp
	popl %ebp
	ret
	
#-----------------------------#
#--Meu_Calloc--#

.globl MeuCalloc
.type MeuCalloc, @function

MeuCalloc:

	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%esp), %edx		#recebe quando deve usar o MeuRealloc
	pushl %edx 				#empilha edx
	call MeuMalloc			#chama a função do malloc
	addl $4, %esp
	
zera_inicio:
	
	movl 4(%eax), %edx
	addl $8, %eax
	movl $0, %ebx			#colocando 0 em ebx

zera_loop:

	movl $0, %eax
	addl $4, %eax
	addl $4, %ebx
	cmpl %ebx, %edx			#compara para ver se edz e ebx estão com o mesmo tamanho
	jl zera_loop
	
fim:
	
	movl %ebp, %esp
	popl %ebp
	ret
	
#-----------------------------#
#--Meu_Realloc--#

.globl MeuRealloc
.type MeuRealloc, @function

MeuRealloc:

	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%esp), %ebx 			#endereço para realocar
	movl 12 (%esp), %ecx 			#quando deve realocar
	
	cmpl 4 (%ebx), %ecx 			#se forem iguais
	jle fim_realloc				#vá para o final
	
diferente:

	pushl %ecx			#empilha ecx
	pushl %ebx			#empilha ebx
	
	call MeuLiberaMemoria
	addl $4, %esp
	
	popl %ebx			#desempilha ebx
	popl %ecx			#desempilha ecx
	
	movl break_atual, %ebx 		#coloca o tamanho atual em ebx
	movl %ebx, %eax
	addl $8, %ebx
	movl $INDISP, 0 (%eax)		#muda pra indisponivel
	movl %ecx, 4(%eax)			#coloca o tamanho
	
	addl %ecx, %ebx
	movl %ebx, %eax
	addl $8, %ebx
	movl $INDISP, 0 (%eax)		#muda pra indisponivel
	movl %ecx, 4(%eax)			#coloca o tamanho
	movl %ebx, break_atual		#atualiza o tamanho

fim_realloc:
	movl %ebp, %esp
	popl %ebp
	ret
	
#-----------------------------#
#--Meu_Libera_Memoria--#

.globl MeuLiberaMemoria
.type MeuLiberaMemoria, @function

MeuLiberaMemoria:

	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %ecx 		#desmontando o cabeçalho
	subl $8, %ecx
	movl $DISP, 0 (%ecx)	#coloca disponivel
	
	movl 4(%ecx), %ebx
	addl $8, %ecx			#desmonta o segundo cabeçalho
	addl %ebx, %ecx
	movl $DISP, 0 (%ecx)	#coloca disponivel
	
	movl %ebp, %esp
	popl %ebp
	ret
#-----------------------------#
#--Imprime_Mapa--#

.globl ImprimeMapa
.type ImprimeMapa, @function

ImprimeMapa:

	pushl %ebp
	movl %esp, %ebp
	
	movl $0, %ecx
	
	movl break_atual, %ebx 		#coloca em ebx o valor atual da brk
	movl heap_ini, %eax			#coloca o inicio da Heap em eax
	
	
	movl $0, soma_seg_ocupado	#coloca 0 no numero de segmentos ocupados
	movl $0, soma_mem_ocupado	#coloca 0 no numero de memoria ocupados
	
	movl $0, soma_seg_livre 	#coloca 0 no numero de segmentos livre
	movl $0, soma_mem_livre		#coloca 0 no numero de memoria livre
	
loop_imprime:

	addl $1, %ecx
	cmpl %eax, %ebx				#compara eax com ebx
	je final
	
inicio_imprime:


	movl 0(%eax), %edx
	cmpl $INDISP, %edx			#compara se esta indisponivel
	je imprime_ocupado
	
	movl 0(%eax), %edx
	cmpl $DISP, %edx			#compara se esta disponivel
	je imprime_livre

imprime_ocupado:
	movl %eax, salvar			#guarda o inicio da Heap na variavel salvar
	pushl $hash
	call printf
	addl $4, %esp
	movl salvar, %eax			#coloca o valor do inicio da Heap em eax

	movl %eax, salvar			#coloca eax em salvar
	movl 4(%eax), %edx
	
	pushl %edx					#empilha edx
	pushl %ecx					#empilha ecx
	movl $0, %ecx
for1:
	cmpl %edx, %ecx
	jge fimfor1

	movl %ecx, salvarc
	movl %edx, salvard
	pushl $string_ocupado
	call printf
	addl $4, %esp 				#restaurando valores dos registradores
	movl salvarc, %ecx
	movl salvard, %edx

	addl $1, %ecx 				#restaurando valores dos registradores
	jmp for1
fimfor1:
	movl salvar, %eax
	movl %eax, salvar			#guarda o inicio da Heap na variavel salvar
	pushl $hash
	call printf
	addl $4, %esp
	movl salvar, %eax			#coloca o valor do inicio da Heap em eax
	
	popl %ecx					#desempilha ecx
	popl %edx					#desempilha ebx
	
	addl $16, %eax
	addl %edx, %eax
	jmp loop_imprime
	
imprime_livre:
	movl %eax, salvar			#guarda o inicio da Heap na variavel salvar
	pushl $hash
	call printf
	addl $4, %esp
	movl salvar, %eax			#coloca o valor do inicio da Heap em eax

	movl %eax, salvar			#coloca eax em salvar
	movl 4(%eax), %edx
	
	pushl %edx					#empilha edx
	pushl %ecx					#empilha ecx
	movl $0, %ecx
for2:
	cmpl %edx, %ecx
	jge fimfor2

	movl %ecx, salvarc
	movl %edx, salvard
	pushl $string_livre
	call printf
	addl $4, %esp 				#restaurando valores dos registradores
	movl salvarc, %ecx
	movl salvard, %edx

	addl $1, %ecx 				#restaurando valores dos registradores
	jmp for2
fimfor2:
	movl salvar, %eax
	movl %eax, salvar			#guarda o inicio da Heap na variavel salvar
	pushl $hash
	call printf
	addl $4, %esp
	movl salvar, %eax			#coloca o valor do inicio da Heap em eax
	
	popl %ecx					#desempilha ecx
	popl %edx					#desempilha ebx
	
	addl $16, %eax
	addl %edx, %eax
	jmp loop_imprime
	
final:

	
	movl salvar, %eax
	pushl $fim_heap
	call printf
	
	addl $4, %esp
	movl salvar, %eax
	
	movl %ebp, %esp
	popl %ebp
	ret
#-----------------------------#


