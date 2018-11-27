.section .data
	brk_inicial: .quad 0
	brk_atual: .quad 0

	.equ TAM_MIN, 4096 

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

	movq %rdi, %rbx # numero de bytes para alocar vem como parametro em %rdi
	movq %rdi, %rdx # numero de bytes para alocar vem como parametro em %rdi
	addq $16, %rbx # espaço para infos gerenciaveis

	movq brk_atual, %rcx # endereço da variavel em rcx

	movq %rcx, %rdi # brk atual em rdi
	addq %rbx, %rdi # aumenta brk atual somando o numero indicado no parametro
	movq $12, %rax # chamada de brk
	syscall

	movq brk_atual, %rbx
	movq $1, (%rbx)

	addq $8, %rbx
	movq %rdx, (%rbx) # rdx tem valor de bytes alocados

	movq %rax, brk_atual # atualiza brk atual

	addq $8, %rbx
	movq %rbx, %rax

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
