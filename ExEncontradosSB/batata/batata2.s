.section .data
InicioHeap: .quad 0
AntesHeap: .quad 0
AtualHeap: .quad 0
.equ TCABECALHO, 12 # Tamanho do cabeçalho, para alocar uma posicao a mais  a do tam anterior, e somar com tam
.equ POSICAO, 0 # Posicao de DISP ou INDISP no cabeçalho
.equ POS_TAM, 4 # Posicao do tamanho no cabeçalho
.equ TAM_ANT, 8
.section .text

.globl meuAlocaMem
.type meuAlocaMem, @function

meuAlocaMem:
	pushq %rbp
	movq %rsp, %rbp

	cmpq $0, InicioHeap
	jne end_if #verifica tamheap
	movq $12, %rax
	movq $0, %rbx
	syscall

	incq %rax#incrementa brk em 1
	movq %rax, AtualHeap
	movq %rax, InicioHeap

end_if:
	movq InicioHeap, %rax #carrega variáveis globais
	movq AtualHeap, %rbx #tamanho a ser alocado
	movq 8(%rbp), %rcx #tamanho malloc

encontra_livre:
	cmpq %rbx, %rax #compara endereço atual a brk
	je aumenta_brk#se igual aumenta brk
	movq POS_TAM(%rax), %rdx #rdx recebe o tamanho do segmento
	cmpq $0, POSICAO(%rax)#se estiver ocupado
	je prox_segmento	  #pula para o proximo segmento
	cmpq %rdx, %rcx #se o segmento é do tamanho necessario
	je aloca_igual
	cmpq %rdx, %rcx #se o tamanho é maior 
	jl aloca_menor

prox_segmento:
	movq POS_TAM(%rax), %rbx
	movq %rdx, AntesHeap
	addq POS_TAM(%rax), %rax #soma tam do segmento com cabecalho
	addq $TCABECALHO, %rax   #para chegar no prox seg
	jmp encontra_livre

aumenta_brk:
	addq %rcx, %rbx #soma em rbx o tamanho a ser alocado
	addq $TCABECALHO, %rbx #soma o tamanho do cabecalho
	pushq %rax
	pushq %rbx
	pushq %rcx
	movq $12, %rax #brk
	syscall #faz syscall para mexer na brk
	cmp $0, %eax #verifica se aumentou brk
	je erro #mostra erro caso não tenha aumentado
	popq %rcx #tamanho do malloc
	popq %rbx #tamanho do malloc + cabecalho
	popq %rax #inicio da heap
	movq $0, POSICAO(%rax)
	movq %rcx, POS_TAM(%rax)#informa tam do segmento
	movq AntesHeap, %rcx
	movq %rcx, TAM_ANT(%rax)
	addq $TCABECALHO, %rax
	movq %rbx, AtualHeap #novo valor da brk
	popq %rbp
	ret

aloca_igual:
	movq $0, POSICAO(%rax)
	addq $TCABECALHO, %rax
	popq %rbp
	ret

aloca_menor:
	subq $TCABECALHO, %rbx #verifica se o segmento tem
	cmpq %rcx, %rdx		   #o tamanho que queremos alocar
	jle prox_segmento
	movq $0, POSICAO(%rax)
	movq %rcx, POS_TAM(%rax)
	addq %rcx, %rax #vai para o pedaço livre do segmento
	addq $TCABECALHO, %rax
	subq %rcx, %rdx
	movq %rdx, POS_TAM(%rax)#define o tamanho que restou do segmento
	movq $1, POSICAO(%rax)
	subq %rcx, %rax #volta para segmento anterior
	popq %rbp       #na primeira posicao apos o cabecalho
	ret

erro:
	movq $0, %rax #retorna 0 para informar erro
	popq %rbp
	ret

loop_seguinte:
	cmpq AtualHeap, %rax
	je fim_loop

if_ocupado:
	cmpq $0, POSICAO(%rax) #verifica se segmento ocupado
	jne else_livre #pula para else livre caso esteja livre
	addq $1, OCUPADOS(%rbp)#incremente ocupados
	movq POS_TAM(%rax), %rbx
	addq %rbx, SEGM_OCUPADOS_T(%rbp)#soma tam do seg atual no total de segm ocupados
	pushq %rax
	pushq POS_TAM(%rax)#empilha para usar o printf
	pushq INC(%rbp)
	pushq $msg2
	call printf
	addq $12, %rsp #restaura pilha
	popq %rax #tem o endereco do segmento
	jmp proximo_seg

else_livre:
	addq $1, LIVREST(%rbp) #incrementa o total de livres
	movq POS_TAM(%rax), %rbx
	addq %rbx, SEGM_LIVRES_T(%rbp) #soma o tam do seg atual
	pushq %rax
	pushq POS_TAM(%rax) #empilha para usar o printf
	pushq INC(%rbp)
	pushq $msg3
	call printf
	addq $12, %rsp #restaura pilha
	popq %rax

proximo_seg:
	addq $1, INC(%rbp)
	addq POS_TAM(%rax), %rax #soma tamanho do segm e cabecalho
	addq $TCABECALHO, %rax	 #para chegar no prox segm
	jmp loop_seguinte

fim_loop:
	pushq SEGM_OCUPADOS_T(%rbp) #empilha para usar o printf
	pushq OCUPADOS(%rbp)
	pushq $msg4
	call printf
	addq $12, %rsp #restaura pilha
	pushq SEGM_LIVRES_T(%rbp)
	pushq LIVREST(%rbp)
	pushq $msg5
	call printf
	addq $12, %rsp
	addq $24, %rsp
	popq %rbp
	ret

##########################Libera Memoria
.globl meuLiberaMem
.type meuLiberaMem, @function
.equ LIBERA, 4
meuLiberaMem:
	movq LIBERA(%rsp), %rax
	subq $TCABECALHO, %rax #rax vai para o inicio do segm
	movq $1, POSICAO(%rax)
	movq POS_TAM(%rax), %rcx
	movq %rax, %rbx
	addq %rcx, %rbx
	addq $TCABECALHO, %rbx
	cmpq AtualHeap, %rbx
	jge passo_1
	cmpq $1, POSICAO(%rbx)
	jne passo_1
	movq POS_TAM(%rax), %rcx #rcx recebe tam do segm atual
	movq POS_TAM(%rbx), %rdx #rdx recebe tam do segm de rbx
	addq $TCABECALHO, %rdx
	addq %rcx, %rdx
	movq %rdx, POS_TAM(%rax)

passo_1:
	movq %rax, %rbx
	cmpq $0, TAM_ANT(%rax)
	je passo_2
	subq TAM_ANT(%rax), %rbx
	subq $TCABECALHO, %rbx
	cmpq $1, POSICAO(%rbx)
	jne passo_2
	movq POS_TAM(%rax), %rcx
	movq TAM_ANT(%rax), %rdx
	addq $TCABECALHO, %rdx
	addq %rcx, %rdx
	movq %rdx, POS_TAM(%rbx)
	movq %rbx, %rax

passo_2:
	movq %rax, %rbx
	addq $TCABECALHO, %rbx
	addq POS_TAM(%rax), %rbx
	cmpq AtualHeap, %rbx
	jl fim

diminui_brk:
	movq %rax, %rbx
	movq $12, %rax
	syscall
	movq %rax, AtualHeap

fim:
	ret

.globl imprMapa
.type imprMapa, @function
.equ HEAP_ATUAL, -4
.equ OCUPADOS, -8 # guarda quantos segmentos são ocupados
.equ LIVREST, -12 # Guarda quantos segmentos são livres
.equ SEGM_OCUPADOS_T, -16
.equ SEGM_LIVRES_T, -20
.equ INC, -24 # Número segmento atual


msg1: .string "Segmento %d \n"
msg2: .string "#"
msg3: .string ""
msg4: .string "+"
msg5: .string "-"

imprMapa:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	movq InicioHeap, %rax
	movq $0, -8(%rbp)

verifica_imprime:
	cmpq AtualHeap, %rax #se igual sai do imprime
	je fim_mapa

recarrega_cabecalho: #recarrega em rcx
	addq $1, -8(%rbp)
	movq -8(%rbp), %rcx #imprime o segmento que estamos
	pushq %rax
	pushq %rcx
	pushq $msg1
	call printf
	addq $8, %rsp
	popq %rax
	movq $12, -4(%rbp)
	movq -4(%rbp), %rcx

loop_cabecalho:
	pushq %rax
	pushq $msg2
	addq $4, %rsp
	popq %rax
	subq $1, -4(%rbp)
	movq -4(%rbp), %rcx
	cmpq $0, %rcx
	je continua
	jmp loop_cabecalho

continua:
	pushq %rax
	pushq $msg3
	call printf
	addq $4, %rsp
	popq %rax
	cmpq $1, POSICAO(%rax)
	jne indisponivel
	movq POS_TAM(%rax), %rdx
	movq %rdx, -4(%rbp)
	mov -4(%rbp), %rcx

loop_disponivel:
	pushq %rax
	pushq $msg5
	call printf
	addq $4, %rsp
	popq %rax
	subq $1, -4(%rbp)
	movq -4(%rbp), %rcx
	cmpq $0, %rcx
	je proximo_segmento
	jmp loop_disponivel

indisponivel:
    movq POS_TAM(%rax), %rdx
    movq %rdx,-4(%rbp)
    movq -4(%rbp), %rcx

loop_indisponivel:
	pushq %rax
	pushq $msg4
	call printf
	addq $4, %rsp
	popq %rax
	subq $1, -4(%rbp)
	movq -4(%rbp), %rcx
	cmpq $0, %rcx
	je proximo_segmento
	jmp loop_indisponivel

proximo_segmento:
	pushq %rax
	pushq $msg3
	call printf
	addq $4, %rsp
	popq %rax
	addq POS_TAM(%rax), %rax
	addq $TCABECALHO, %rax
	jmp verifica_imprime

fim_mapa:
	addq $8, %rsp
	popq %rbp
	ret

