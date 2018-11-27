.section .data
InicioHeap: .quad 0
AtualHeap: .quad 0
.section .text
.globl _start

_start:
	
	call IniciaAlocador
	
	movq InicioHeap, %rax
	movq %rax, AtualHeap
	call AlocaMem
	call LiberaMem
	call Fim

IniciaAlocador:
	movq $0, %rdi
	movq $12, %rax
	syscall
	movq %rax, InicioHeap
	ret

AlocaMem:
	movq %rdi, %r9
	movq AtualHeap, %rax
	addq $16, %rax
	addq %r9, %rax
	movq %rax, %rdi
	movq $12, %rax
	syscall
	movq AtualHeap, %rax
	movq $1, (%rax)
	movq %r9, 8(%rax)
	ret

LiberaMem:
	movq %rdi, %r8
	movq InicioHeap, %rdi
	movq $12, %rax
	syscall
	ret

Fim:
	movq $60, %rax
	syscall
