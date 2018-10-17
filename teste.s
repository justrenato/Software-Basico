.section  .data
.section  .text
.globl  _start
_start:
movq $12, %rax #12 é o numero da função brk
movq $124, %rdi # se rdi estiver com 0 brk retorna o valor atual em rax, se for outro valor diferente de 0 brk seta a variavel brk para o valor contido em rdi
syscall
movq %rax, %rdi
movq $60, %rax
syscall
