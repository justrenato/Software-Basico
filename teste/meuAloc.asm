.section .data
	brk_inicial: .quad 0
	brk_atual: .quad 0

	livre: .string "-"
	ocupado: .string "+"
	infoGen: .string "#"
.section .text

.globl iniciaAlocador
	.type iniciaAlocador, @function
	iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq $12, %rax
	movq $0, %rdi
	syscall
	movq %rax, brk_inicial
	movq %rax, brk_atual

	popq %rbp
	ret

.globl topoAtual
	.type topoAtual, @function
	topoAtual:	

	pushq %rbp
	movq %rsp, %rbp

	movq $12, %rax
	movq $0, %rdi
	syscall

	popq %rbp
	ret

.globl finalizaAlocador
	.type finalizaAlocador, @function
	finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq $12, %rax
	movq brk_inicial, %rdi
	syscall

	popq %rbp
	ret

.globl alocaMem
	.type alocaMem, @function
	alocaMem:	
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rbx # salva o numero de bytes (a ser alocado) de %rdi em %rbx
	movq %rdi, %rdx # salva o numero de bytes (a ser alocado) de %rdi em %rdx
	addq $16, %rbx # aumenta espaço para infos gerenciaveis

	movq brk_atual, %rcx # topo atual da heap em rcx

	movq %rcx, %rdi # brk atual em rdi
	addq %rbx, %rdi # aumenta brk atual somando o numero indicado no parametro
	movq $12, %rax # chamada de brk
	syscall # nesse momento brk esta aumentada numero de bytes solicitado + 16

	movq brk_atual, %rbx # brk_atual ainda aponta para antigo topo (que agora é inicio do novo bloco)
	movq $1, (%rbx) # indico que no endereço apontado pela brk_atual coloco valor 1 para demonstrar que esta sendo livre o bloco

	addq $8, %rbx # apontando para info que indica tamanho do bloco
	movq %rdx, (%rbx) # rdx tem valor de bytes alocados, insere no campo da info gerenciavel

	movq %rax, brk_atual # atualiza brk atual

	addq $8, %rbx # apontando agora para inicio do bloco alocado
	movq %rbx, %rax # joga no valor de retorno o endereço do bloco a ser usado 

	popq %rbp
	ret

.globl imprimeMapa
	.type imprimeMapa, @function
	imprimeMapa:	
	pushq %rbp
	movq %rsp, %rbp

	movq brk_inicial, %r12 # ponteiro que vai percorrer a heap desde o inicio
	movq brk_atual, %rbx # aponta para final da pilha
	while1:
		cmpq %rbx, %r12 # verifica se o ponteiro ja esta no final da pilha
		je fim_while1

		movq (%r12),%r14 # %r14 recebe info se é livre ou ocupado

		movq %r12, %r13 
		addq $8, %r13 # aponta para outro campo da info gerenciavel
		movq %r13, %rax

		for1:
			cmpq %r13, %r12 # compara r12 com r13
			je fim_for1
			movq $infoGen, %rdi
			call printf
			addq $1, %r12
			jmp for1
		fim_for1:

		movq (%r12), %r15 # salva em r15 tamanho do bloco
		addq $8, %r13 # aponta para inicio do bloco

		for2:
			cmpq %r13, %r12
			je fim_for2
			movq $infoGen, %rdi
			call printf
			addq $1, %r12
			jmp for2
		fim_for2:

		addq %r15, %r13 # aponta para fim do bloco

		# se for ocupado printa +
		cmpq $1, %r14
		jne else1

		for3:
			cmpq %r13, %r12
			je fim_for3
			movq $ocupado, %rdi
			call printf
			addq $1, %r12
			jmp for3
		fim_for3:

		# se for livre printa -
		else1:
			for4:
				cmpq %r13, %r12
				je fim_for4
				movq $livre, %rdi
				call printf
				addq $1, %r12
				jmp for4
			fim_for4:


		jmp while1
	fim_while1:

	popq %rbp
	ret

.globl liberaMem
	.type liberaMem, @function
	liberaMem:	
	pushq %rbp
	movq %rsp, %rbp

	subq $16, %rdi # rdi contem o parametro de onde é o endereço do bloco a ser livre, agora aponta para info gerenciavel livre/ocupado
	movq $0, (%rdi) # muda para zero p informar que esta livre 

	call fusao

	popq %rbp
	ret

.globl fusao
	.type fusao, @function
	fusao:	
	pushq %rbp
	movq %rsp, %rbp

	movq brk_inicial, %rax # aponta para inicio da heap para percorrer a procura de nos livres
	movq brk_atual, %rbx # aponta para final da heap

	while2:
		cmpq %rbx, %rax
		je fim_while2 # se chegar ao final da heap sai do while

		cmpq $0, (%rax) # se nó for livre
		jne fim_if1
			movq %rax, %rcx # rcx aponta para mesmo lugar q rax
			addq $8, %rcx # aponta para tamanho do bloco
			addq (%rcx), %rcx # adiciona o tamanho do bloco em rcx
			addq $8, %rcx # adiciona em rcx 8 bytes que faltaram referentes à info gerenciavel

			cmpq %rbx, %rcx # se auxiliar saiu do topo da heap sai da função
			jge fim_while2

			cmpq $0, (%rcx) # se próximo bloco n for livre n entra no if 
			jne fim_if2

			addq $8, %rcx # aponta para tamanho do bloco
			addq $8, %rax # aponta para tamanho do bloco

			movq (%rcx), %r12
			addq %r12,(%rax) # rax incrementa tamanho do no livre
			addq $16, (%rax) # rax incrementa 16 bytes das info gerenciaveis
			subq $8, %rax # aponta para tamanho do bloco

			fim_if2:
		fim_if1: # caso nó n seja livre pula pro proximo bloco

		addq $8, %rax # aponta para tamanho do bloco
		addq (%rax), %rax # adiciona em rax o tamanho do bloco
		addq $8, %rax # adiciona em rax 8 bytes que faltaram adionar referente à ultima info gerenciavel

		jmp while2

	fim_while2:

	popq %rbp
	ret
