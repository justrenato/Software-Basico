.section .data
	topoInicialHeap: .quad 0
	primeiroVazio: .quad 0
	primeiroOcupado: .quad 0
	max_bytes: .quad 4096
	bestFitAux: .quad 0
	baseFinalHeap: .quad 0
	finalDaHeap: .quad 0
  variavelTeste: .quad 0
  tamBloco: .quad 0
  aux: .quad 0
	sinalMenos: .string "-"
  sinalMais: .string "+"
  str2: .string "#"
  str3: .string "\n\n"
.section .text
.globl iniciaAlocador
.globl meuAlocaMem
.globl meuLiberaMem
.globl imprMapa
.globl finalizaAlocador
.type iniciaAlocador, @function
.type meuAlocaMem, @function
.type meuLiberaMem, @function
.type imprMapa, @function
.type finalizaAlocador, @function

# ########################################################################
# #													Trab. Software Básico											 ##
# #																																		 ##
# #		-Infomações gerenciais:																					 ##
# #				-No primeiro espaço: Ocupado ou não (0 ou 1)								 ##
# #				-No segundo espaço : Endereço para o próx										 ##
# #				-No terceiro espaço: num_bytes pra alocar										 ##
# #				-A partir do quarto: O espaço alocado												 ##
# #		-Quando alocar 4096, as info. gerenciais já estarão incluídas		 ##
# #																																		 ##
# #																																		 ##
# ########################################################################
# ########################################################################
# #													Para domingo:															 ##
# #																																		 ##
# #				-Arrumar os ponteiros dos OCUPADOS no libera								 ##
# #				-Fazer Caso 3																								 ##
# #				-Fazer o print																							 ##
# #																																		 ##
# #																																		 ##
# #																																		 ##
# #																																		 ##
# #																																		 ##
# ########################################################################



# ##########################INICIA ALOCADOR###############################
# ########################################################################

iniciaAlocador:
	pushq %rbp				# Colocando funçao na pilha (Rotina)
	movq %rsp, %rbp		# Rotina

	movq $12, %rax		# Coloca o valor da BRK em rax
	movq $0, %rdi			# Quanto ele muda a BRK, nesse caso, 0.
	syscall
	movq %rax, topoInicialHeap # Coloca o valor de BRK em topoInicialHeap


	movq topoInicialHeap, %rbx
	addq $4096, %rbx
	addq $1000, %rbx
	movq $12, %rax		# Abro 4096 posições na BRK
	movq %rbx, %rdi		# Abro 4096 posições na BRK + a quantidade q ela já tá
	syscall


	movq topoInicialHeap, %rbx
	movq %rbx, primeiroVazio	# Coloco o endereço do primeiro em primeiroVazio
	movq $0, (%rbx)		# Coloco 0 para avisar q é vazio
	addq $8, %rbx			# Ando uma posição (estou agora na segunda informação gerencial)
	movq $-1, (%rbx)	# Adiciono -1 pra avisar que é o último nó livre
	addq $8, %rbx			# Ando uma posição (estou agora na terceira informação gerencial)
	movq $4072, (%rbx)# Adiciono o tamanho do bloco (neste caso, 4072, porque 24 são usados para informação gerencial entao nao sao contados)


	popq %rbp					# Rotina para tirar funçao da pilha
	ret

# ###########################ALOCA MEMÓRIA################################
# ########################################################################

meuAlocaMem:
	push %rbp
	movq %rsp, %rbp

	movq %rdi, %rbx		# rbx contém o valor a ser alocado
	movq $24, %r10		# r10 contém informações gerenciais e é temporário

	# Vamos primeiramente, tentar entrar no caso 1
	movq primeiroVazio, %rax	# rax, agora, contém o endereço do primeiro local vago
	movq $-1, %r11		# r11 é temporário só pra usar na condição (if)
	movq 8(%rax), %r10
	cmpq 8(%rax), %r11
	je caso1					# Jump pro caso 1
	jmp caso2					# Se não, jump pro caso 2


	popq %rbp
	ret

# ######################################CASO 1############################
caso1:							# Caso 1 - PRIMEIRA ALOCAÇÃO NA HEAP

	movq $0, %r12							# Pra de fato checar se é a primeira inserção, o primeiroOcupado tem que ser 0
	cmpq %r12, primeiroOcupado
	jne caso2

	movq $1, (%rax)		# inseriu 1 na primeira posição da informação gerencial para avisar q foi alocado
	movq %rax, primeiroOcupado	# Agora, o primeiro ocupado tem o endereço do primeiro local

	addq $8, %rax 		# Mudando para a segunda informação gerencial
	movq $-1, (%rax)	# Coloca -1 na segunda informação gerencial para avisar que é o último da lista
	addq $8, %rax 		# Mudando para a terceira informação gerencial
	movq (%rax), %r13	# Guardando valor que sobrava antes pra usar + tarde
	movq %rbx, (%rax)	# Inserindo a terceira informação gerencial para avisar quantos bytes serão alocados	
	addq $8, %rax  		# Anda uma posição para conter o endereço do início do bloco pedido pra alocar

	movq %rax, %r12		# r12 contém o início do bloco alocado
	addq %rbx, %r12		# Adicionamos rbx posições em r12, pra chegar no restante que vai ser vazio
	movq %r12, primeiroVazio	# Avisamos q esse vai ser o primeiroVazio
	movq $0, (%r12)		# Colocamos 0 para avisar q está livre
	addq $8, %r12			# Andamos uma posição na informação gerencial
	movq $-1, (%r12)	# Adicionamos -1 para denotar que é o último nó livre
	addq $8, %r12			# Andamos uma posição na informação gerencial (agora estamos na terceira)
	subq %rbx, %r13		# Diminui a quantidade de bytes alocados de r13 (4096 - num_bytes) - Pra dps saber qnt sobrou ainda na brk
	subq $24, %r13		# Diminui 24 bytes porque esses 24 são usados pra informações gerenciais dele mesmo
	movq %r13, (%r12)	# Adiciona valor que sobrou para alocar


	popq %rbp
	ret

# ######################################CASO 2############################
# Só entra no caso 2 se alguém ja foi alocado
caso2:							# ALOCAÇÃO NORMAL
	
	movq primeiroVazio, %r13	# r13 contém o primeiro vazio
	movq $-1, %r11						# r11 contém -1
	movq $0, %r12							# r12 contém 0

para:			# for(i = primeiroVazio até -1)

	cmpq %r11, 8(%r13)				# checa se é o último nó (fim do loop)
	je ultimoNo								# acabou o for
	cmpq %rbx, 16(%r13)				# Se o bloco atual for menor que rbx, não serve, então vai para naoServeBestFit
	jl	naoServeBestFit				# jump pra lá
	cmpq $0, bestFitAux				# Aqui, estamos num bloco que pode ser colocado o rbx e não foi escolhido nenhum bloco, entao, por enquanto, este é o melhor
	je podeServirBestFit			# jump pra lá
	movq 16(%r13), %r15				# só uma auxiliar (resolver um erro q tava dando)
	cmpq %r15, bestFitAux 		# Checa se o bloco atual (que tem espaço para alocar o rbx), é melhor que o ultimo bloco escolhido em bestFitAux
	jl naoServeBestFit				# Se ele for menor do que o que tem no bestFitAux, não serve
	jmp podeServirBestFit			# Se chegou até aqui, é porque %r13 contém o melhor valor, até agora, para bestFitAux

naoServeBestFit:					# Não serve, passa pro próx
	movq %r13, %r14					# Copia r13 em r14
	movq 8(%r14), %r13			# Pega o endereço do próx vazio e coloca r13, agora r13 está apontando para o próximo vazio
	jmp para                # Volta pro loop

podeServirBestFit:				# Até agora tem o melhor valor, mas deve continuar no for para encontrar um possível valor melhor

	movq %r13, bestFitAux		# bestFitAux ganha o endereço do melhor valor
	movq %r13, %r14					# Copia r13 em r14
	movq 8(%r14), %r13			# Pega o endereço do próx vazio e coloca r13, agora r13 está apontando para o próximo vazio
	jmp para                # volta pro loop

ultimoNo:
	
	cmpq %rbx, 16(%r13)			# Compara o conteúdo disponível do último nó com o pedido pelo usuário
	jl fim_para							# Se for menor, fim do loop, e lá ele vai checar se é 0, se for 0, significa que não tem bloco disponível pra ele e necessita de + 4096.
	cmpq $0, bestFitAux			# Se bestFitAux estiver em 0 e o bloco atual for capaz de alocar rbx 
	je ultimoNoBestFit			# último nó eh o melhor pra ser alocado
	movq 16(%r13), %r15			# r15 é aux e guarda o valor do bloco de bytes do ultimo nó
	cmpq %r15, bestFitAux		# compara o valor do bloco bytes com o que tem
	jl fim_para							# Apenas termina o loop, já que bestFitAux tem um bloco melhor que o último nó
	movq %r13, bestFitAux		# Se continuou até aqui, é pq o último nó tem um valor melhor que todos os outros blocos
	jmp fim_para						# pula final do loop

ultimoNoBestFit:

	movq %r13, bestFitAux		# Se bestfitaux era 0 e o último nó tinha um bloco de bytes disponível com o tamanho q usuario pedia
	jmp fim_para						# bestfitaux recebe r13 

fim_para:	# Neste fim do para, deve ter no bestFitAux o melhor caso

	# cmpq $0, bestFitAux			# Se bestFitAux for 0 mesmo fora do loop, significa que não tem espaço pra ele e precisa ser alocado + 4096 bytes(caso3)
	# je caso3								# jump pro caso3
	# bestFitAux contém o melhor local para ser alocado

# ###########################################################################################
# #############################VEREMOS A NECESSIDADE DA CRIAÇÃO DO PRÓX. NÓ VAZIO (logo em seguida, caso sobre espaço, pós alocado############################exemplo: rbx = 100, mas o bestFitAux tem 50, então sobrariam 50 blocos q deve ser um novo nó vazio#######################	

	movq $0, %rcx								# utilizarei rcx como uma flag que será utilizada no "ARRUMANDO PONTEIRO VAZIO"
	movq bestFitAux, %r11				# r11 contem o melhor a ser ocupado
	movq 16(%r11), %r12					# Movo a quantidade de blocos disponíevis neste nó para r12
	subq %rbx, %r12							# Subtraio rbx (100 por exemplo) de (200 blocos disponiveis)
	cmpq $50, %r12							# Se sobrar mais que 50, é necessário abrir um bloco de sobra desses bytes
	jge necessidadeDeAlocarBlocoVazio
	jmp arrumandoPonteiroOcupado

necessidadeDeAlocarBlocoVazio:
	
	movq %r11, %r13							# r13 contém bestFitAux
	addq $24, %r13							# vou até o início do bloco
	addq %rbx, %r13							# ando %rbx bytes e agora estou no local que irá sobrar
	movq %r13, %rcx							# Utilizarei rcx como uma flag que será utilizada no "ARRUMANDO PONTEIRO VAZIO"
	movq $0, (%r13)							# adiciono 0 para mostrar q é um nó desocupado
	addq $8, %r13								# ando uma informação gerencial
	movq 8(%r11), %rdx
	movq %rdx, (%r13)				# Adiciono o endereço que o vazio apontava para a nova posição dele
	addq $8, %r13								# ando mais uma informação gerencial
	subq $24, %r12							# subtraio 24 de r12 por causa das informações gerenciais
	movq %r12, (%r13)						# Coloco na informação gerencial o tamanho de num_bytes q ta vazio
	
# ############################ARRUMANDO PONTEIRO OCUPADO########################################
arrumandoPonteiroOcupado:

	movq primeiroOcupado, %r13	# r13 contém o primeiroOcupado
	movq bestFitAux, %r11				# r11 contém o local q será alocado

loop_acharAnteriorOcupado:
	movq 8(%r13), %r12					# r12 contém endereço próx
	cmpq $-1, %r12							# se for -1, ele era o último da fila
	je encontrouPonteiroAnterior
	cmpq %r11, %r12							# compara o endereço do próx com o q está sendo alocado
	jge encontrouPonteiroAnterior	# Se o endereço apontado por r12 for maior que o que bestFitAux, é esse quem eu devo mexer
	movq %r12, %r13							# Se não for, r13 vai para o endereço do próx e entra no loop novamente até achar
	jmp loop_acharAnteriorOcupado

encontrouPonteiroAnterior:		# Ele encontrou o alocado antes desse e vai arrumar os ponteiros

	addq $8, %r11								# r11 continha o local q esta sendo alocado (bestFitAux), +8 ele vai pra segunda informação gerencial
	movq (%r11), %r8						# r8 é um auxiliar para usar no "ARRUMANDO PONTEIRO VAZIO"
	movq 8(%r13), %rdx
	movq %rdx, (%r11)				# Agora, na segunda informação gerencial, ele terá o valor do próx endereço ocupado
	addq $8, %r13								# Vou para a segunda inforamação gerencial do ultimoOcupado
	movq bestFitAux, %rdx
	movq %rdx, (%r13)			# Salvo a posição do que está sendo alocado
# ################################################################################################
# #############################ARRUMANDO PONTEIRO VAZIO###########################################

arrumandoPonteiroVazio:

	movq primeiroVazio, %r13

encontrandoAntecessorDoBestFitAux:		# Loop que vai encontrar o anterior do q será alocado (para ajuste de ponteiro)
	
	cmpq bestFitAux, %r13								
	je umNoVazio												# Se só tem um nó vazio
	movq 8(%r13), %rdx
	cmpq %rdx, bestFitAux
	je encontrouAntecessorDoBestFitAux
	movq 8(%r13), %r13 
	jmp encontrandoAntecessorDoBestFitAux

umNoVazio:
	
	movq %rcx, primeiroVazio
	jmp ultimaParte

encontrouAntecessorDoBestFitAux:
	# r13 contém o ultimo vazio antecessor q está apontando para bestFitAux
	cmpq $0, %rcx								# Se estiver em 0 quer dizer que não sobrou bytes na ultima alocação
	je arruma1									# Vai para o caso 1 (que é mais simples) Se não der o jump, é q ele alocou algo
	addq $8, %r13								# ando para a prox informação gerencial
	movq %rcx, (%r13)						# coloco %rcx (q contém endereço do ultimo vazio) na segunda informação gerencial do segundo
	addq $8, %rcx								# vou para a segunda informação gerencial do ultimo vazio
	movq %r8, (%rcx)						# Coloco r8 la, q foi guardado o valor lá em cima no "ARRUMA PONTEIRO OCUPADO"
	jmp ultimaParte


arruma1:

	addq $8, %r13								# Vou para a segunda informação gerencial do ultimo vazio antecessor q está apontando para o bestFitAux
	movq %r8, (%r13)						# coloco r8 que foi salvo anteriormente, em r13
	

ultimaParte:

	movq bestFitAux, %r13				# r13 é um aux q tem o local q está sendo alocado
	movq $1, (%r13)							# coloco um na primeira informação gerencial
	addq $16, %r13							# vou para a terceira informação gerencial
	movq %rbx, (%r13)						# colo qnts num_bytes tem o próx bloco
	addq $8, %r13								# vou para o começo do bloco
	movq %r13, %rax							# coloco em rax o retorno do bloco para o usuário

	popq %rbp
	ret

# ###########################CASO 3#######################################
# caso3:

# 	movq $4096, %r8			#movemos 4096 ver se é suficiente para abrir
# 	cmpq %r8, %rbx			#comparamos pra ver se é suficiente
# 	jge aindaNaoAbriuEspacoSuficiente #Se nao for, incrementa mais 4096

	# ##Chamada a BRK para atualizá-la com o novo tamanho
# 	movq $12, %rax		#abro r8 bytes na brk
# 	movq %r8, %rdi
# 	syscall

# aindaNaoAbriuEspacoSuficiente:
# 	addq $4096, %r8
# 	jmp caso3

encontraUltimoNóVazio:


# ###########################LIBERA MEMÓRIA###############################
meuLiberaMem:

	
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rbx									# Rbx contém o bloco a ser desalocado, mas está no inicio do bloco utilizado
	subq $24, %rbx 									# Agora, rbx está no começo do bloco a ser desalocado

	movq $0, (%rbx)

	# movq $0, %rax
	# movq $str1, %rdi
	# call printf

	movq primeiroOcupado, %r13									# r13 contém o bloco a ser desalocado
	# ###############################ARRUMANDO PONTEIROS OCUPADOS############################################################
arrumaOcupados:
	
	# movq $0, %rax
	# movq $str1, %rdi
	# movq primeiroOcupado	, %rsi
	# call printf

	cmpq %rbx, %r13					# Compara o no que esta sendo desalocado com o primeiroOcupado
	jne maisDeUmaAlocacao		# Se eles não são os mesmos, pula para o caso geral maisDeUmaAlocacao
	cmpq $-1, 8(%rbx)				# Se está aqui, é pq eles são os mesmos. Verifica se é o unico nó alocado (porq aponta pra -1)
	je apenasUmaAlocacao		# Se for, pula pra apenas uma alocação
	movq 8(%rbx), %r14			# linha que arruma bug
	movq %r14, primeiroOcupado		# Se não, o nó apontado pelo que está sendo desalocado, será apontado pelo anterior ao nó desalocado
	jmp arrumaVazios

	# movq $0, %rax
	# movq $str1, %rdi
	# call printf


apenasUmaAlocacao:
	# movq $0, %rax
	# movq $str1, %rdi
	# call printf

	movq $0, primeiroOcupado
# 	movq $0, %rax
# 	movq $str1, %rdi
# 	call printf
	jmp arrumaVazios

maisDeUmaAlocacao:									# Rotulo para ter base para o jump
	movq primeiroOcupado, %r12					# r12 tem o primeiro Ocupado
loop_UltimoOcupado:															# loop para encontrarUltimoOcupad
	cmpq 8(%r12), %rbx														# Compara se o endereço do Ocupado Atual aponta pro que está sendo desocupado
	jne naoEncontrouAnteriorAinda									# Se não for, pula pra condição
	movq 8(%rbx), %rcx							# linha que arruma bug
	movq %rcx, 8(%r12)													# Se for, move o endereço que o Desocupado aponta para o que o anterior dele aponta
	jmp arrumaVazios															# Vai pra arrumar o vazio

naoEncontrouAnteriorAinda:						# Loop para encontrar o último nó anterior ao que está sendo desalocado
	movq 8(%r12), %r12
	jmp loop_UltimoOcupado


arrumaVazios:
	
	movq primeiroVazio, %r13

	cmpq primeiroVazio, %rbx					# Confere se o primeiroVazio está apontando para um cara maior que o nó desalocado
	jg loop_encontrarUltimoVazio			# Se o rbx for maior, quer dizer que o primeiroVazio não precisa ser alterado
	movq %r13, %rcx
	movq %rcx, 8(%rbx)								# Se não, movemos o endereço que o nó seguinte vazio estava apontando para rbx
	movq %rbx, primeiroVazio					# Dizemos que o primeiroVazio é o cara que acabou de ser desalocado
	jmp arrumaNosLivres

loop_encontrarUltimoVazio:					# loop para encontrar o ultimoVazio antes do bloco alocado
	cmpq 8(%r13), %rbx								# Compara o que o nóVazio está apontando com o que está sendo desalocado
	jg AindaNaoEncontrouUltimoVazio		# Se o rbx for maior, ainda não encontrou o UltimoVazio, vai pro loop
	movq 8(%r13), %rcx
	movq %rcx, 8(%rbx)							# Se encontrou, coloco o endereço que o nó vazioAnterior está apontando para o nó que está sendo desalocado, apontar
	movq %rbx, 8(%r13)								# faz o nó vazioAnterior apontar para o atual deslocado
	movq $0, (%r13)
	jmp arrumaNosLivres


AindaNaoEncontrouUltimoVazio:				# Loop para ir para o próx vazio
	movq 8(%r13), %r13
	jmp loop_encontrarUltimoVazio

arrumaNosLivres:
	
	movq primeiroVazio, %r13		# r13 contém o primeiro vazio

loop_uniaoNosLivres:
	
	movq %r13, %r12							# r12 é aux
	addq $24, %r12						 	# r12 vai para o inicio
	addq 16(%r13), %r12					# r12 está no início do prox. bloco
	cmpq $1, (%r12)
	je final
	cmpq $-1, 8(%r13)
	je final
	cmpq $0, (%r12)							# Se for um 0, tem dois nós livres em sequencia, tem que unir
	je temQueUnir
	movq 8(%r13), %r13
	jmp loop_uniaoNosLivres

temQueUnir:
	movq 8(%r12), %r10				# r10 é aux
	addq $8, %r13
	movq %r10, (%r13)
	movq 16(%r12), %r10
	addq $8, %r13
	movq (%r13), %r9
	addq %r10, (%r13)
	addq $24, (%r13)				# VERIFICAR SE ISTO ESTÁ CORRETO(COMO ELE TA UNINDO OS BLOCOS E SOMANDO APENAS O QNT TINHA DE ESPAÇO NO NÓ SEGUINTE, ELE NÃO TA CONTANDO AS INFO. GERAIS DO NÓ SEGUINTE, ENTÃO ELE DEVE SOMAR 24)
	subq $16, %r13
	movq $0, (%r13)
	movq %r13, %rax

final:

	popq %rbp
	ret

	
# ##################ARRUMANDO PONTEIROS VAZIOS############################
# ##################ARRUMANDO PONTEIROS OCUPADOS##########################
# ########################################################################
# ##################IMPRIMINDO MAPA#######################################

imprMapa:
	pushq %rbp
	movq $4096, %r12
	addq topoInicialHeap, %r12
	movq topoInicialHeap, %r13
forimprime:
	cmpq %r12, %r13
	jge fim_for
	cmpq $0, (%r13)
	je igual
	movq $sinalMais, %rbx
	jmp cont
igual:
	movq $sinalMenos, %rbx
cont:
	movq $1, %r15
while1:
	cmpq $24, %r15
	jg fim_while1
	movq $0, %rax
	movq $str2, %rdi
	call printf
	addq $1, %r15
	jmp while1
fim_while1:
	addq $16, %r13
	movq (%r13), %r14
	addq $8, %r13
	movq $1, %r15
while2:
	cmpq %r14, %r15
	jg fim_while2
	movq $0, %rax
	movq %rbx, %rdi
	call printf
	addq $1, %r15
	jmp while2
fim_while2:
	addq %r14, %r13
	jmp forimprime
fim_for:
	movq $0, %rax
	movq $str3, %rdi
	call printf

	popq %rbp
	ret


# ###########################FINALIZA ALOCADOR############################
# ########################################################################

finalizaAlocador:
	pushq %rbp				# Colocando funçao na pilha (Rotina)
	movq %rsp, %rbp		# Rotina

	movq $12, %rax
	movq topoInicialHeap, %rdi		# Faço o rdi voltar pro topoInicialHeap
	syscall

	popq %rbp					# Rotina para tirar funçao da pilha
	ret


# ########################################################################
# ########################################################################
