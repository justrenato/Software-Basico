#include <stdio.h>
#include <stdlib.h>

// void iniciaAlocador();
// void finalizaAlocador();
// void *meuAlocaMem(int);
// void meuLiberaMem(void *);
// void imprMapa();
// void iniciaAlocador();

long int iniciaAlocador();
long int aumenta(int a,int b,int c,int d,int e,int f, int g, int h);

int main(int argc, char const *argv[])
{
   printf("-----------------------INICIO DO PROGRAMA-----------------------\n");

   printf("iniciaAlocador: 0x%ld\n",iniciaAlocador());
   printf("0x%lx\n",aumenta(1,2,3,4,5,6,7,8));
   
   // iniciaAlocador();
   // imprimeBrk();
   // x=meuMalloc(100);
   // imprimeBrk();
   // y=meuMalloc(900);
   // imprimeBrk();
   // meufree(x);
   // imprimeBrk();
   // meufree(y);
   // imprimeBrk();
}

