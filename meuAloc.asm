 .section .data
 	text: .string "hello world\n"
 	sei: .string "%d\n" # IMPORTANTE SEMPRE COLOCAR \n PARA IMPRIMIR
 	tam: .quad 0
 .section .text
 	.globl main

 main:
	pushq %rbp                                      
	movq %rsp, %rbp  

	movq $12, %rax
	movq $0, %rdi
	syscall

	movq $sei, %rdi
	movq %rax, %rsi
	movq %rax, %rdx
	call printf


	movq $60, %rax
	movq $0, %rdi
	syscall

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
