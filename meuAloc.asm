 .section .data
 	hello: .string "hello world\n"
 	str1: .string "%x\n" # IMPORTANTE SEMPRE COLOCAR \n PARA IMPRIMIR
 	heapInicial: .quad 0
 	brk_atual: .quad 0
 	.equ BRK, 12

.section .text
	.globl main

	.globl iniciaAlocador
		.type iniciaAlocador, @function
		iniciaAlocador: # paranetri 16(%rbp) qual novo valor de topo da heap

		pushq %rbp
		movq %rsp, %rbp

		movq $BRK, %rax # brk
		movq $0, %rdi # 0 faz retornar valor atual da heap em %rax
		syscall

		movq %rax, heapInicial # salva valor da heap inicial
		movq %rax, brk_atual # inicializa brk_atual
		movq heapInicial, %rbx
		movq brk_atual, %rbx

		popq %rbp
		ret

	.globl finalizaAlocador
		.type finalizaAlocador, @function
		finalizaAlocador:

		pushq %rbp
		movq %rsp, %rbp

		movq $BRK, %rax
		movq heapInicial, %rdi # seta brk para a heap inicial e finaliza o programa
		syscall

		popq %rbp
		ret

	.globl meuAlocaMem
		.type meuAlocaMem, @function
		meuAlocaMem:
		
		pushq %rbp
		movq %rsp, %rbp

		movq $BRK, %rax # brk
		movq 16(%rbp), %rdi # novo valor pego do parametro
		addq $16, %rdi # aumento o espaço solicitado para caber infos gerenciaveis
		syscall

		movq 16(%rbp), %rbx
		subq %rbx, %rax # rax aponta para inicio do espaço livre
		subq $16, %rax # rax aponta para inicio das infos gerenciaveis

		movq $1,(%rax) # indica que o bloco esta sendo usado
		# addq $8,%rax	# aponta para outro campo da info gerenciavel
		# movq %rbx,%rcx # rcx recebe tamanho do espaço solicitado
		# movq %rcx,(%rax) # indica quanto espaço esse bloco tem livre
		# addq $8,%rax # rax sai da função apontando para o bloco livre

		popq %rbp
		ret

	.globl start
		.type start, @function
		start:
	 
		pushq %rbp                                      
		movq %rsp, %rbp  

		# movq $hello, %rdi
		# call printf

		call iniciaAlocador


		movq $BRK, %rax # brk
		movq $0, %rdi # 0 faz retornar valor atual da heap em %rax
		syscall

		# addq $100, %rax
		# pushq %rax
		# call meuAlocaMem
		# addq $8, %rsp

		movq $str1, %rdi
		movq %rax, %rsi
		movq heapInicial, %rbx
		call printf

		popq %rbp
		ret

# 	######### printar por syscall string na tela #########
# movq $1, %rax  # 1 = write
# movq $1, %rdi # 1 fd = stdout
# movq $text, %rsi # *buffer
# movq $14, %rdx # count
# syscall

# 	######### printf #########
# .section .data                                        
#     str1: .string "Digite dois numeros:\n"  
#     str2: .string "%d %d"                               
#     str3: .string "Os numeros digitados foram %d %d\n"   
# .section .text                                      
# .globl main                                          
# main:                                                
#    pushq %rbp             # empilha base pointer                                   
#    movq %rsp, %rbp        # cria novo registro de ativação

#    subq $16, %rsp         # cria espaço para duas variaveis

#    mov $str1, %rdi        # joga primeira string para primeiro parametro
#    call printf            # chama printf

#    movq %rbp, %rax        # pega valor do base pointer e joga em %rax            
#    subq $16, %rax         # aponta para a segunda variavel
#    movq %rax, %rdx        # joga no terceiro parametro do scanf
#    movq %rbp, %rax        # pega valor do base pointer e joga em %rax            
#    subq $8, %rax          # aponta para a primeira variavel
#    movq %rax, %rsi        # joga no segundo parametro do scanf
#    mov $str2, %rdi        # joga segunda string para primeiro parametro
#    call scanf             # chama scanf

#    movq -16(%rbp), %rdx   # joga segunda variavel no terceiro parametro
#    movq -8(%rbp), %rsi    # joga primeira variavel no segundo parametro
#    mov $str3, %rdi        # joga terceira string para primeiro parametro
#    call printf            # chama printf
   
#    movq $60, %rax         # valor de retorno que representa saida                       
#    syscall                # syscall para a saida
