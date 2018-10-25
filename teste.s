.section .data

str: .string "hello world!\n"

.section .text
.globl _start
_start:

	movq $1, %rax
	movq $1, %rdi
	movq $str, %rsi
	movq $14, %rdx
	syscall

	movq $60, %rax
	movq $0, %rdi
	syscall
