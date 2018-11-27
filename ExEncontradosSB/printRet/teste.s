.section .data
.section .text

.globl teste
	.type teste, @function
	teste:

	movq $12, %rax
	movq $0, %rdi
	syscall

	ret
