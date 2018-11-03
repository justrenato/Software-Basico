.section .data
inicioHeap: .quad 0
str: .string "hello world!\n"

.section .text
.globl main
main:
    movq %rsp, %rbp #for correct debugging

	# movq $12, %rax
	# movq $0, %rdi
	# syscall

	movq %rax, %rbx
	movq $1, %rax
	movq $1, %rdi
	movq %rbx, %rsi
	movq $14, %rdx
	syscall

	movq %rax, %rdi
	movq $60, %rax
	syscall
