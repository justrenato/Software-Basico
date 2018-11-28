# DATA
.section .data

INICIO_HEAP: .quad 0
TOPO_HEAP: .quad 0

STR: .string %s
LIVRE: .string -
OCUPADO: .string +
HEADER: .string ###
LINHA: .string nn


# Constantes
# BSS
.section .bss

# TEXT
.section .text

.global liberaMem
.global finalizaAlocador
.global iniciaAlocador
.global alocaMem
.globl imprime

# Inicia Alocador
iniciaAlocador:
# Inicio registro de ativacao
pushq %rbp
movq %rsp, %rbp

# Chama brk e move para INICIO_HEAP
movq 2,%rax
movq -bash,%rdi
syscall
movq %rax,INICIO_HEAP
movq %rax,TOPO_HEAP
# Volta registro de ativacao
popq %rbp
ret
# # # FIM INICIA ALOCADOR # # #





# Finaliza Alocador
finalizaAlocador:
# Inicio registro de ativacao
pushq %rbp
movq %rsp, %rbp

movq INICIO_HEAP, %rdi
movq 2, %rax
syscall
# Chama brk e move para INICIO_HEAP
movq INICIO_HEAP,%rax
movq %rax,TOPO_HEAP
# Volta registro de ativacao
popq %rbp
ret
# # # FIM FINALIZA ALOCADOR # # #





# Aloca Memoria
# rbx = bloco anterior   (syscall altera r11)
# rax = bloco atual
# rcx = topoHeap


alocaMem:
# Inicio registro de ativacao
pushq %rbp
movq %rsp, %rbp
pushq %rbx

movq INICIO_HEAP,%rax
movq %rax,%rbx
movq TOPO_HEAP,%rcx

equal_topo:
cmpq %rcx,%rax# inicioHeap == topoHeap ?
jge aloca

while_0:seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s # while( rax < topoHeap )
cmpq %rcx,%rax
jge aloca
cmpq ,0(%rax)# ocupado / livre?
je if_1

movq 8(%rax), %r10
addq 4,%r10# livre!
cmpq %rdi, %r10# tamLivre >= parametro?
jge ajusta_header

if_1:seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s 
movq %rax,%rbx seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s # busca espaço livre
addq 8(%rax),%rax
addq 4,%rax
jmp while_0

# chama brk
aloca:seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s seila.s # inicioHeap == topoHeap
movq %rdi, %r10

movq %rdi,%rax
addq 4,%rax
movq 096,%rcx
movq -bash,%rdx
idiv %rcx# rax = (parametro + 24) / 4096;
addq ,%rax
imul 096,%rax
movq %rax,%rdi# rdi = tamanho para alocar (bits)

movq 2,%rax
addq TOPO_HEAP,%rdi# rdi = novo_topo_heap;
syscall
movq TOPO_HEAP,%r9# r9 = bloco atual
movq %rax, TOPO_HEAP seila.s seila.s seila.s seila.s seila.s seila.s seila.s # topoHeap atualiza
movq %r9, %rax
movq TOPO_HEAP, %rcx

movq -bash, 0(%rax)#  Ajusta header do novo bloco
subq %rax, %rdi#  rdi = tamanho alocado
subq 4, %rdi
movq %rdi, 8(%rax)

movq INICIO_HEAP, %r9
cmpq %rbx, %r9# Primeiro bloco?
jne not_first_block
movq -bash, %rbx
not_first_block:
movq %r10, %rdi


ajusta_header:
movq ,0(%rax)
movq 8(%rax),%rdx# rdx = espaçoLivre
movq %rdi,8(%rax)
movq %rbx,16(%rax)   seila.s seila.s seila.s 

movq %rax, %r10# #######
addq %rdi,%r10# Ajusta próximo bloco
addq 4, %r10# 
cmpq %r10, %rcx# Próximo bloco = topoHeap?
je end_0 seila.s seila.s     seila.s seila.s # 
seila.s seila.s seila.s seila.s seila.s seila.s seila.s #
cmpq , 0(%r10)# Próximo bloco está ocupado?
je end_0 seila.s seila.s seila.s seila.s seila.s #
seila.s seila.s seila.s seila.s seila.s seila.s seila.s #
movq -bash,0(%r10)#
subq %rdi,%rdx#
subq 4, %rdx#
movq %rdx,8(%r10)#
movq %rax, 16(%r10)# r10 = prox bloco
seila.s seila.s seila.s  seila.s seila.s seila.s seila.s # ######
# ################

movq TOPO_HEAP,%r8
movq %r10, %r9

addq 8(%r10), %r9
addq 4, %r9
cmpq %r8,%r9
jge end_0

movq %r10, 16(%r9)
# ###############

end_0:

popq %rbx
popq %rbp
ret





# rdi = blodo liberado
# LIBERA
liberaMem:
pushq %rbp
movq %rsp, %rbp


movq -bash,0(%rdi)
movq 8(%rdi),%rax
addq 4,%rax
addq %rdi,%rax# rax = proximo bloco

movq TOPO_HEAP, %r10
cmpq %rax, %r10# rax == topoHeap?
je end_if_0

cmpq -bash,0(%rax)
jne end_if_0

movq 8(%rax),%r10# ########
addq 4,%r10#
movq 8(%rdi), %r9# junta próximo bloco com o liberado
addq %r9,%r10#
movq %r10,8(%rdi)# ########

movq %rdi, %r8
addq %r10, %r8
addq 4, %r8
movq TOPO_HEAP, %r9
cmpq %r9, %r8
jge end_if_0
movq %rdi, 16(%r8)




end_if_0:
movq 16(%rdi),%rax
cmpq -bash,%rax# unico bloco na heap?
je end_if_1

movq 0(%rax),%r10
cmpq -bash,%r10
jne end_if_1

movq 8(%rax), %r9# ########
addq 4, %r9#
movq 8(%rdi),%r10# junta bloco anterior com o liberado
addq %r10, %r9#
movq %r9,8(%rax)# #######

movq %rax, %r8
addq 8(%rax), %r8
addq 4, %r8
movq TOPO_HEAP, %r9
cmpq %r9, %r8
jge end_if_1
movq %rax, 16(%r8)

end_if_1:

popq %rbp
ret

# liberaMem(*endereco){
#  0(endereco) = 0#
#  if (8(endereco)+24)=0
#      8(endereco) = 8(endereco) + 8(8(endereco)+24) +24
#  }
# if(16(endereco)!=0)
#  if(0(16(endereco))=0{
#    8(16(endereco))=   8(16(endereco))+ 8(endereco)+24
#  }
# }




# imprime heap
imprime: 
pushq %rbp
movq %rsp, %rbp

movq INICIO_HEAP, %rcx
movq TOPO_HEAP, %rdx
jmp inicio

while1:
addq 8(%rcx), %rcx
addq 4, %rcx
inicio:
cmpq %rdx, %rcx
jge fim_while

pushq %rax
pushq %rcx
pushq %rdx
pushq %r11
pushq %r10

movq , %rdi
movq , %rsi
call printf

popq %r10
popq %r11
popq %rdx
popq %rcx
popq %rax

cmpq -bash, 0(%rcx)
je livre

movq 8(%rcx), %r10
movq -bash, %r11
while_ocupado:
cmpq %r10, %r11
je while1

pushq %rax
pushq %rcx
pushq %rdx
pushq %r11
pushq %r10

movq , %rdi
movq , %rsi
call printf

popq %r10
popq %r11
popq %rdx
popq %rcx
popq %rax

addq , %r11# 8
jmp while_ocupado


livre:
movq 8(%rcx), %r10
movq -bash, %r11
while_livre:
cmpq %r10, %r11
je while1

pushq %rax
pushq %rcx
pushq %rdx
pushq %r11
pushq %r10

movq , %rdi
movq , %rsi
call printf

popq %r10
popq %r11
popq %rdx
popq %rcx
popq %rax

addq , %r11# 8
jmp while_livre


fim_while:

pushq %rax
pushq %rcx
pushq %rdx
pushq %r11
pushq %r10

movq , %rdi
call printf

popq %r10
popq %r11
popq %rdx
popq %rcx
popq %rax

popq %rbp
ret


