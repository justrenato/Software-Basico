#include <stdio.h>
#include <stdlib.h>

// void iniciaAlocador();
void finalizaAlocador();
// void *alocaMem(int a);
// void meuLiberaMem(void *);
// void imprMapa();
// void iniciaAlocador();

long int iniciaAlocador();
long int alocaMem(int a);
// long int aumenta(int a,int b,int c,int d,int e,int f, int g, int h);
long int topoAtual();
void imprimeMapa();

int main(int argc, char const *argv[])
{
   printf("-----------------------INICIO DO PROGRAMA-----------------------\n");

   printf("iniciaAlocador: 0x%ld\n",iniciaAlocador());
   printf("alocaMem:       0x%ld\n",alocaMem(500));
   printf("alocaMem:       0x%ld\n",alocaMem(500));
   printf("topo atual:     0x%ld\n",topoAtual());
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