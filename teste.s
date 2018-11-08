.section .data
str: .string "brk: %d\n"
.section .text

.globl main
main:
	pushq %rbp
	movq %rsp, %rbp

	movq $12, %rax
	movq $0, %rdi
	syscall

	movq $str, %rdi
	movq %rax, %rsi
	call printf

	movq $12, %rax
	movq $0, %rdi
	syscall

	movq $str, %rdi
	movq %rax, %rsi
	call printf

	movq $12, %rax
	movq $0, %rdi
	syscall

	movq $str, %rdi
	movq %rax, %rsi
	call printf

	popq %rbp

	movq $60, %rax
	movq $0, %rdi
	syscall
