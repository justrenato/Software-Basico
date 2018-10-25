/*
----------------------------
UFPR 
Arylson Arruda Bueno
GRR20111066
Software Básico
Gerenciador de HEAP
----------------------------
*/

#include <stdio.h>
#include <stdlib.h>
#include "heap.h"

#define MAX_ELEM 16
#define TAM_MAX  64
#define NUM_OPER 10

int main(int argc, char *argv[]){

  void *vetor[MAX_ELEM+1];
  int i, j, tam;

  // faz cada elemento do vetor apontar para NULL
  for (i=0; i<MAX_ELEM; i++)
    vetor[i] = NULL;

  // gera uma semente baseada no tempo atual para os números
  // aleatórios.
  srand (time(0));

  // inicia a metade superior do conjunto de elementos
  for ( i=0; i<MAX_ELEM/2; i++ ) {
    tam = rand () % TAM_MAX;  // tam = [0..TAM_MAX]
     printf("Alocadovetor[%d] %d\n", i, tam+1);
    vetor[i] = meuAlocaMem(tam+1); 
  }

  // Serão tentadas NUM_OPER operações de alocacao/liberacao 
  for (i=0; i<NUM_OPER; i++) 
    {
      j = rand () % MAX_ELEM;  // j = [0..TAM_MAX]
      if ( vetor[j] == NULL ) // aloca elemento
        { 
          tam = rand () % TAM_MAX;  // tam = [0..TAM_MAX]
	     printf("Alocado vetor[%d] %d\n", j, tam+1);
          vetor[j] = meuAlocaMem(tam+1);
        } 
      else
        {
          printf("Liberando vetor[%d]\n", j);
          meuLiberaMem(vetor[j]);
          vetor[j] = NULL;
        }
    }

	printf("OK\n");
	imprMapa();
}


