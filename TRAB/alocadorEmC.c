#include <stdio.h>
#include <stdlib.h>

// void iniciaAlocador();
void finalizaAlocador();
// void *alocaMem(int a);
// void meuLiberaMem(void *);
// void imprMapa();
// void iniciaAlocador();

void *iniciaAlocador();
void *alocaMem(int a);
void *topoAtual();
void imprimeMapa();
void liberaMem();

int main(int argc, char const *argv[])
{
   printf("-----------------------INICIO DO PROGRAMA-----------------------\n");
   printf("iniciaAlocador: %p\n",iniciaAlocador());

   printf("\nIMPRIME MAPA:\n");
   imprimeMapa();
   printf("\n");

   void *a= (void *)alocaMem(100);
   void *b= (void *)alocaMem(100);
   void *c= (void *)alocaMem(100);

   printf("topo atual:     %p\n",topoAtual());

   liberaMem(a);
   // liberaMem(b);
   liberaMem(c);
   printf("\nIMPRIME MAPA:\n");
   imprimeMapa();
   printf("\n");
   
   // iniciaAlocador();
   // imprimeBrk();
   // x=alocaMem(100);
   // imprimeBrk();
   // y=alocaMem(900);
   // imprimeBrk();
   // meufree(x);
   // imprimeBrk();
   // meufree(y);
   // imprimeBrk();
   finalizaAlocador();
}

// void *alocaMemSimples(int num_bytes){
//    aloca num_bytes + 16
//    brk_atual= 1; /*ocupado*/
//    brk_atual+8= num_bytes; quantos blocos estao sendo usados
//    rax = brk_atual + 16; /*aponta para inicio do bloco*/
//    brk_atual = num_bytes + 16; /* seta novo topo*/
// }

// imprime(){
//    %r14 = ocuOuLivr;
//    for (int i = 0; i < 8; ++i)
//    {
//       printf("#");
//    }
//    %r15 = tamBloco;
//    for (int i = 0; i < 8; ++i)
//    {
//       printf("#");
//    }


//    if (%r14 = ocupado)
//    {
//       for (int i = 0; i < %r15; ++i)
//       {
//          printf("+");
//       }
//    } else{
//       for (int i = 0; i < %r15; ++i)
//       {
//          printf("-");
//       }
//    }
// }

// alocaCerto(num_bytes){
//    while (ponteiro != brk_atual){
//       procura bloco livre E tam maior ou igual a num_bytes
//       se achar indica que esta ocupado e retorna o endereço inical

//       senao abre 4096 (ou mais se for maior a solicitação)na heap 
//    }
// }


// fusaoNoLivre(){
//    while(rax != brk_atual){
//       if (rax=livre)
//       {
//          rcx aponta para proximo bloco
//          if (rcx = livre)
//          {
//             rcx aponta para tamanho do bloco
//             rax aponta para tamanho do bloco
//             rax muda tamanho para tamanho atual + tamanho do outro livre + 16
//          }
//       }
//       rax = proximo bloco
//    }
// }


// void *alocaMem(num_bytes){
//    rcx = 0 // pra dizer se achou ou nao bloco livre e com espaço suficiente
//    while (rax != rbx){ //enquanto n percorrer heap inteira

//    }
// }