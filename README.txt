lendo pg85
sasm : emulador assembly

############################ exemplo bom  ############################
/home/renato/UFPR/quartoSemestre/Software-Basico/ExEncontradosSB/rsj12/rsj12-kmml12

############################ IMPORTAR FUNÇÕES DO ASSEMBLY NO C ############################
# usando função em C
int fu
nc();
int main(int argc, char const *argv[])
{
	
	return func();
}


# criando função em Assembly

.section .data

.section .text

.globl func
.type func,@function
func:

movq $60, %rax
movq $3, %rdi
syscall


############################ TRABALHO ############################

5.1   implemente o algoritmo proposto na seção 5.1.2 pg 86 em assembly

5.2   implemente as seguintes variações:

a)   faça a fusão de nós livres;

c)   minimize o número de chamadas ao serviço brk alocando espaços múltiplos de 4096 bytes por vez. Se for solicitado um espaço maior, digamos 5000 bytes, então será alocado um espaço de 
4096 ∗ 2 = 8192 bytes para acomodá-lo.

5.4   implemente uma função que imprime um mapa da memória da região da
heap em todos os algoritmos propostos aqui. Cada byte da parte gerencial do nó deve ser impresso com o caractere "#". O caractere usado para a impressão dos bytes do bloco de cada nó depende se o bloco estiver livre ou ocupado.   Se estiver livre,  imprime o caractere -". Se estiver ocupado, imprime o caractere "+".

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