.section .data
	topoHeap: .quad 0
	inicioHeap: .quad 0
	A: .quad 0

.section .text
.globl _start
iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq $0, %rdi
	movq $12, %rax
	syscall
	movq %rax, topoHeap
	movq %rax, inicioHeap
	popq %rbp
	ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq $0, topoHeap
	movq topoHeap, %rdi
	movq $12, %rax
	syscall
	popq %rbp
	ret


liberaMen:

alocaMem:
	pushq %rbp
	movq %rsp, %rbp						
	movq inicioHeap, %rbx				
	movq topoHeap, %rcx	
	movq 16(%rbp), %r12

	pesquisa:
		cmpq %rbx, %rcx
		je aloca		
		movq %rbx, %r11
	pesquisa2:
		cmpq %rcx, %rbx
		je aloca
		cmpq $0, (%r11)
		je fim_pesquisa
		addq $8, (%r11)
		addq %r11, (%r11)
		jmp pesquisa2

	fim_pesquisa:
		addq $8, (%r11)
		cmpq %r12, %r11 
		jle aloca
		addq %r11, (%r11)
		jmp pesquisa2

	aloca:
		movq %r12, %r10
		addq $16, %r10
		movq %r10, %rdi
		movq $12, %rax
		syscall
		movq $0, %rdi
		movq $12, %rax
		syscall
		subq %r10, %rax
		movq $1, (%rax)
		addq $8, (%rax)
		movq %r12, (%rax)
		movq %rax, topoHeap
		jmp termina

	termina:
		popq %rbp
		ret




_start:
	call iniciaAlocador
	
	movq $100, A
	pushq A
	call alocaMem

	movq $100, A
	pushq A
	call alocaMem


	call finalizaAlocador



	movq %rax, %rdi
	movq $60, %rax
	syscall                                           