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
// void *aumenta(int a,int b,int c,int d,int e,int f, int g, int h);
void *topoAtual();
void imprimeMapa();
void liberaMem();

int main(int argc, char const *argv[])
{
   printf("-----------------------INICIO DO PROGRAMA-----------------------\n");
   printf("iniciaAlocador: %p\n",iniciaAlocador());


   void *a= alocaMem(100);
   void *b= alocaMem(100);
   printf("alocaMem:       %p\n",a);
   printf("alocaMem:       %p\n",b);
   printf("topo atual:     %p\n",topoAtual());
   liberaMem(a);
   liberaMem(b);
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

// void *alocaMem(int num_bytes){
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