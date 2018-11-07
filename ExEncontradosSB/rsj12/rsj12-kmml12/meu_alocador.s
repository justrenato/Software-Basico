.section .data

# --Variaveis_Globais--# 

heap_ini: .long 0 			# inicio da heap
break_atual: .long 0 			# posição atual da brk
salvar: .long 0
salvarc: .long 0
salvard: .long 0
memoria: .long 0
soma_seg_livre: .int 0 			# total de segmentos livres
soma_seg_ocupado: .int 0 		# total de segmentos ocupados
soma_mem_livre: .int 0 			# total de memoria livre
soma_mem_ocupado: .int 0 		# total de memoria ocupada
# -----------------------------# 	
# --Strings--# 

hash: .string ";;;;;;;;"
string_inicio: .string "Inicio da Heap: %x \n\0"
string_livre: .string "-"
string_ocupado: .string "*"
livre: .string "Segmentos Livres: %d/%d bytes\n"
ocupado: .string "Segmentos Ocupados: %d/%d bytes\n" 
fim_heap: .string "\n\n\n"
# -----------------------------# 	
# --Estrutura--# 

.equ TAM_CAB, 8 # tamanho do cabeçalho (é 8 porque 4 bytes são da parte se esta ou nao diposnivel e os outros 4 é do tamanho)
.equ DISP_CAB, 0 #  0 se esta indisponivel e 1 se esta disponivel
.equ SIZE_CAB, 4 # tamanho que será alocado
# -----------------------------# 	
# --Constantes--# 
	
.equ INDISP, 0 # constante para memoria indisponivel
.equ DISP, 1	# constante para memoria disponivel
.equ BRK, 12	# System call para parar
# .equ SYSCALL, 0x80 # constante para memoria indisponivel
# -----------------------------# 
.section .text
# -----------------------------# 
# --Main--# 
# -----------------------------# 
# --Meu_Malloc--# 
# -----------------------------# 
.globl _start

.globl malloc_inicio
.type malloc_inicio, @function
	
malloc_inicio:		# guarda o inicio da heap, quando o alocador é usado pela primeira vez
	
	pushq %rbp		# parte padrão
	movq %rsp, %rbp
	
	movq $BRK, %rax		# encontra onde o ponto de parada esta
	movq $0, %rdi		# retorna a ultima posição valida contida em rbx
	syscall
	movq %rax, heap_ini		# carrega o inicio da heap
	movq %rax, break_atual		# carrega a pos_atual
	movq %rbp, %rsp			# fim da função
	popl %rbp
	ret
	
.globl MeuMalloc
.type MeuMalloc,@function

inicio:
	call malloc_inicio		# chama a função para começar a alocar
	jmp continue			# depois pule para a função que continua 
	
MeuMalloc:
	
	pushq %rbp
	movq %rsp, %rbp
	
	cmpq $0, heap_ini 	# confere para ver se não é a primeira que a função é chamada no programa
	je inicio	  	# se for volte para o inicio
	
continue:

	movq TAM_CAB(%rbp), %rcx 	# rcx recebe o quanto ele precisa para alocar

	movq heap_ini, %rax		    # carrega o valor da heap em rax
	movq break_atual, %rbx		# carrega o valor da posição da brk

loop:
	
	cmpq %rbx, %rax				#  verifica de rbx é igual a rax, se for pula
	je muda_break				#  para a muda_break
	
	movq SIZE_CAB(%rax), %rdx		# pega o tamanho da memoria
	cmpq $INDISP, DISP_CAB(%rax) 		# verifica se esta disponivel
	je prox_endereco			 # se nao estiver vá para o proximo endereço
	
	cmpq %rcx, %rdx				# verifica se o tamanho pedido é menor que o tamanho de rspaço disponivel
	jl prox_endereco			# se nao for, aloque aqui

aloca_nessa_pos:

	movq $INDISP, DISP_CAB(%rax)
	addq $TAM_CAB, %rax			# rax recebe o valor de memoria usavel depois do cabeçalho, que tambem é o valor de retorno
	
	movq %rbp, %rsp
	popl %rbp
	ret
	
prox_endereco:

	addq $TAM_CAB, %rax	# o endereço seguinte para verificar é cabeçalho + tamanho do rspaço atual, que ainda não esta disponivel
	addq %rdx, %rax		# adiciona o tam da memoria que esta sendo usada
	jmp loop

muda_break:

	addq $TAM_CAB, %rbx 	# adiciona cabeçario
	addq %rcx, %rbx 		# adiciona o rspaço que foi solicitado
	
	pushq %rax		# empilha rax
	pushq %rcx		# empilha rbx
	pushq %rbx		# empilha rdx
	
	movq $BRK, %rax		# pedido de mais mamoria
	syscall 		# Retorna rax, com o endereço novo, caso contrario, retorna erro
	cmpq $0, %rax		# verifica se tem zero em rax
	je erro			# se sim, vá para a função de erro
	
	popl %rbx		# desempilha rdx
	popl %rcx		# desempilha rbx
	popl %rax		# desempilha rax 
	
	movq $INDISP, DISP_CAB (%rax)	# marca como indisponivel
	movq %rcx, SIZE_CAB (%rax)		# coloca o tamanho que foi alocado
	addq $TAM_CAB, %rax
	
	movq %rbx, %rdx		# monta o outro cabeçalho
	addq $8, %rdx 		# adiciona cabeçario
	movq $INDISP, DISP_CAB (%rdx)  # marca como indisponivel
	movq %rcx, SIZE_CAB(%rdx) # coloca o tamanho que foi alocado
	
	movq %rdx, break_atual 		# atualiza o tamanho atual da brk
	
	movq %rbp, %rsp
	popl %rbp
	ret

erro:
	movq $0, %rax 		# retorna zero
	movq %rbp, %rsp
	popl %rbp
	ret
	
# -----------------------------# 
# --Meu_Calloc--# 

.globl MeuCalloc
.type MeuCalloc, @function

MeuCalloc:

	pushq %rbp
	movq %rsp, %rbp
	
	movq 8(%rsp), %rdx		# recebe quando deve usar o MeuRealloc
	pushq %rdx 				# empilha rdx
	call MeuMalloc			# chama a função do malloc
	addq $4, %rsp
	
zera_inicio:
	
	movq 4(%rax), %rdx
	addq $8, %rax
	movq $0, %rdi			# colocando 0 em rbx

zera_loop:

	movq $0, %rax
	addq $4, %rax
	addq $4, %rbx
	cmpq %rbx, %rdx			# compara para ver se edz e rbx estão com o mesmo tamanho
	jl zera_loop
	
fim:
	
	movq %rbp, %rsp
	popl %rbp
	ret
	
# -----------------------------# 
# --Meu_Realloc--# 

.globl MeuRealloc
.type MeuRealloc, @function

MeuRealloc:

	pushq %rbp
	movq %rsp, %rbp
	
	movq 8(%rsp), %rbx 			# endereço para realocar
	movq 12 (%rsp), %rcx 			# quando deve realocar
	
	cmpq 4 (%rbx), %rcx 			# se forem iguais
	jle fim_realloc				# vá para o final
	
diferente:

	pushq %rcx			# empilha rcx
	pushq %rbx			# empilha rbx
	
	call MeuLiberaMemoria
	addq $4, %rsp
	
	popl %rbx			# desempilha rbx
	popl %rcx			# desempilha rcx
	
	movq break_atual, %rbx 		# coloca o tamanho atual em rbx
	movq %rbx, %rax
	addq $8, %rbx
	movq $INDISP, 0 (%rax)		# muda pra indisponivel
	movq %rcx, 4(%rax)			# coloca o tamanho
	
	addq %rcx, %rbx
	movq %rbx, %rax
	addq $8, %rbx
	movq $INDISP, 0 (%rax)		# muda pra indisponivel
	movq %rcx, 4(%rax)			# coloca o tamanho
	movq %rbx, break_atual		# atualiza o tamanho

fim_realloc:
	movq %rbp, %rsp
	popl %rbp
	ret
	
# -----------------------------# 
# --Meu_Libera_Memoria--# 

.globl MeuLiberaMemoria
.type MeuLiberaMemoria, @function

MeuLiberaMemoria:

	pushq %rbp
	movq %rsp, %rbp
	
	movq 8(%rbp), %rcx 		# desmontando o cabeçalho
	subl $8, %rcx
	movq $DISP, 0 (%rcx)	# coloca disponivel
	
	movq 4(%rcx), %rbx
	addq $8, %rcx			# desmonta o segundo cabeçalho
	addq %rbx, %rcx
	movq $DISP, 0 (%rcx)	# coloca disponivel
	
	movq %rbp, %rsp
	popl %rbp
	ret
# -----------------------------# 
# --Imprime_Mapa--# 

.globl ImprimeMapa
.type ImprimeMapa, @function

ImprimeMapa:

	pushq %rbp
	movq %rsp, %rbp
	
	movq $0, %rcx
	
	movq break_atual, %rbx 		# coloca em rbx o valor atual da brk
	movq heap_ini, %rax			# coloca o inicio da Heap em rax
	
	
	movq $0, soma_seg_ocupado	# coloca 0 no numero de segmentos ocupados
	movq $0, soma_mem_ocupado	# coloca 0 no numero de memoria ocupados
	
	movq $0, soma_seg_livre 	# coloca 0 no numero de segmentos livre
	movq $0, soma_mem_livre		# coloca 0 no numero de memoria livre
	
loop_imprime:

	addq $1, %rcx
	cmpq %rax, %rbx				# compara rax com rbx
	je final
	
inicio_imprime:


	movq 0(%rax), %rdx
	cmpq $INDISP, %rdx			# compara se esta indisponivel
	je imprime_ocupado
	
	movq 0(%rax), %rdx
	cmpq $DISP, %rdx			# compara se esta disponivel
	je imprime_livre

imprime_ocupado:
	movq %rax, salvar			# guarda o inicio da Heap na variavel salvar
	pushq $hash
	call printf
	addq $4, %rsp
	movq salvar, %rax			# coloca o valor do inicio da Heap em rax

	movq %rax, salvar			# coloca rax em salvar
	movq 4(%rax), %rdx
	
	pushq %rdx					# empilha rdx
	pushq %rcx					# empilha rcx
	movq $0, %rcx
for1:
	cmpq %rdx, %rcx
	jge fimfor1

	movq %rcx, salvarc
	movq %rdx, salvard
	pushq $string_ocupado
	call printf
	addq $4, %rsp 				# restaurando valores dos registradores
	movq salvarc, %rcx
	movq salvard, %rdx

	addq $1, %rcx 				# restaurando valores dos registradores
	jmp for1
fimfor1:
	movq salvar, %rax
	movq %rax, salvar			# guarda o inicio da Heap na variavel salvar
	pushq $hash
	call printf
	addq $4, %rsp
	movq salvar, %rax			# coloca o valor do inicio da Heap em rax
	
	popl %rcx					# desempilha rcx
	popl %rdx					# desempilha rbx
	
	addq $16, %rax
	addq %rdx, %rax
	jmp loop_imprime
	
imprime_livre:
	movq %rax, salvar			# guarda o inicio da Heap na variavel salvar
	pushq $hash
	call printf
	addq $4, %rsp
	movq salvar, %rax			# coloca o valor do inicio da Heap em rax

	movq %rax, salvar			# coloca rax em salvar
	movq 4(%rax), %rdx
	
	pushq %rdx					# empilha rdx
	pushq %rcx					# empilha rcx
	movq $0, %rcx
for2:
	cmpq %rdx, %rcx
	jge fimfor2

	movq %rcx, salvarc
	movq %rdx, salvard
	pushq $string_livre
	call printf
	addq $4, %rsp 				# restaurando valores dos registradores
	movq salvarc, %rcx
	movq salvard, %rdx

	addq $1, %rcx 				# restaurando valores dos registradores
	jmp for2
fimfor2:
	movq salvar, %rax
	movq %rax, salvar			# guarda o inicio da Heap na variavel salvar
	pushq $hash
	call printf
	addq $4, %rsp
	movq salvar, %rax			# coloca o valor do inicio da Heap em rax
	
	popl %rcx					# desempilha rcx
	popl %rdx					# desempilha rbx
	
	addq $16, %rax
	addq %rdx, %rax
	jmp loop_imprime
	
final:

	
	movq salvar, %rax
	pushq $fim_heap
	call printf
	
	addq $4, %rsp
	movq salvar, %rax
	
	movq %rbp, %rsp
	popl %rbp
	ret
# -----------------------------# 


