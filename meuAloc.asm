# -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt* -lc

.section .data
	brk_inicial: .quad 0
	brk_atual: .quad 0
	str: .string "oi\n"
.section .text

.globl _start
_start:
.globl iniciaAlocador
	.type iniciaAlocador, @function
	iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq $12, %rax
	movq $0, %rdi
	syscall
	movq %rax, brk_inicial

	popq %rbp
	ret

.globl aumenta
	.type aumenta, @function
	aumenta:
	pushq %rbp
	movq %rsp, %rbp

	# movq %rbx, %rdi
	movq $12, %rax
	movq 24(%rbp), %rax
	# syscall

	popq %rbp
	ret
