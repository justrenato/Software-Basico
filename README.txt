lendo pg85

############################ função brk ############################
movq $12, %rax #12 é o numero da função brk
movq $0, %rdi # se rdi estiver com 0 brk retorna o valor atual em rax, se for outro valor diferente de 0 brk seta a variavel brk para o valor contido em rdi
syscall
movq %rax, %rdi
movq $60, %rax
syscall

############################ compilação resumida em 'run' ############################
alias run='as teste.s -o teste.o && ld teste.o -o teste && ./teste && echo valor de retorno: $?'

############################ makes ############################
all: cria objeto e executavel

ob: cria objeto

exec: cria executavel

clean: remove objeto

purge: remove objeto e executavel