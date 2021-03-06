#include <stdio.h>
#include <stdlib.h>
#include<unistd.h>

#define TAM_MAX 1024

struct ore{
  unsigned char *end;
  int vazio, livre;
};

struct ore heap[11][1024];
unsigned char *heap_i, *heap_f;

int achaBloco(int tam){
  int k, i;
  //printf("tam=%d\n", tam);
  for (k=tam; k<=10; ++k){
    for (i=0; i<TAM_MAX && heap[k][i].vazio != 1; ++i){
      if (heap[k][i].livre == 1){
	//printf("ret=%d\n", k);
	return k;
      }
    }
  }
  return -1;
}

void quebra(int i, int k){
  int aux,aux2,j,x;

  for (; k>i; ){
    //printf("i %d k %d\nheap=%d\n", i, k, heap[k][0].vazio);fflush(stdout);
    aux = 0;
    while(heap[k][aux].vazio != 1){
      aux++;
    }
    //printf("a=%d\n",aux);fflush(stdout);
    if (aux!=0)
      aux--;
    //fazer if?
    heap[k][aux].vazio = 1;
    k--;
    aux2=0;
    while(heap[k][aux2].vazio != 1)
      aux2++;
    for(x=1,j=0;j<k;j++)
      x *= 2;
    heap[k][aux2].vazio = 0;
    heap[k][aux2+1].vazio = 0;
    // printf("Vazio de algo %d,i %d,j %d\n",heap[k][aux2].vazio,k,aux2);
    //if(heap[k][aux2].end != 0)//desnecessario
    heap[k][aux2].end = heap[k+1][aux].end;
    heap[k][aux2+1].end = &heap[k][aux2].end[x];
    heap[k][aux2].livre = 1;
    //if(heap[k][aux2+1].end != 0)
    //heap[k][aux2+1].end= heap[k][aux2].end + x;
    heap[k][aux2+1].livre = 1;
    heap[k][aux2+2].vazio = 1;
  }
  return;
}

void initHeap(){
  int i;
  heap_i = sbrk(TAM_MAX);
  heap_f = sbrk(0);
  for (i=0; i<=10; i++)
    heap[i][0].vazio = 1;
  heap[10][0].end = heap_i;
  heap[10][0].vazio = 0;
  heap[10][0].livre = 1;
  heap[10][1].vazio = 1;

}

void* meuMalloc(int tam){
  int i, x, k, aux, j;
  
  for (i=0, x=1; tam>x; i++)
    x *= 2;

  k = achaBloco(i);

  if (k<0)
    return NULL;
  if (k==i){
    for (j=0; j<TAM_MAX && heap[i][j].vazio != 1; ++j){
      if (heap[i][j].livre == 1){
	heap[i][j].livre = 0;
	return (void*) heap[i][j].end;
      }
    }
  }
  if (k>i){
    quebra(i, k); 
  }
  for (j=0; heap[i][j].livre != 1; ++j);
  heap[i][j].livre = 0;
  //printf("certo %d,i %d,j %d\n",heap[i][j].livre,i,j);
  //printf("quebrou\n");
  return (void*)heap[i][j].end;
}

int achaEnd(int end, int *k, int *l){
  int i, j, aux;

  aux = end + (int) heap_i;
    
  for (i=0; i<=10; ++i){
    for (j=0; j<TAM_MAX && heap[i][j].vazio != 1; ++j){
      if (aux == (int) heap[i][j].end){
	*k = i;
	*l = j;
	return 1;
      }
    }
  }
  return 0;
}

int juntaBudd(int pot, int seq){
  int x=1, x2, i, j, end, endb, aux=0, ind;
  for (i=0; i<pot; ++i)
    x *= 2;
  x2 = x*2;

  end = (int) heap[pot][seq].end - (int) heap_i;
  
  if (end%x2 == 0)
    endb = end + x;
  else
    endb = end - x;

  if (!achaEnd(endb, &i, &j)){
    //printf("Nao achou buddy\n");
    return -1;
  }
  
  if (i == pot && heap[i][j].livre == 1){
    //printf("juntando os buddy\n");
    while (heap[i+1][aux].vazio != 1)
      aux++;
    if (j>seq)
      ind = j;
    else
      ind = seq;
    heap[i][j].vazio = 1;
    heap[pot][seq].vazio = 1;
    while (heap[i][ind+1].vazio != 1){
      heap[i][ind-1] = heap[i][ind+1];
      heap[i][ind+1].vazio = 1;
      ind++;
    }
    //printf("\n\ni=%d j=%d\n\n", i, ind);
    ind = 0;
    while (heap[i+1][ind].vazio != 1)
      ind++;
    //printf("i=%d, ind=%d\n", i, ind);
    if (end < endb){
      heap[i+1][ind] = heap[pot][seq];
      heap[i+1][ind].vazio = 0;
      heap[i+1][ind].livre = 1;
    }
    else{
      heap[i+1][ind] = heap[i][j];
      heap[i+1][ind].vazio = 0;      
      heap[i+1][ind].livre = 1;
    }
    //printf("\n\nv=%d l=%d\n\n", heap[i+1][ind].vazio, heap[i+1][ind].livre);
    //printf("\n\ni=%d j=%d\n\n", i+1, ind);
    heap[i+1][ind+1].vazio = 1;
    juntaBudd(i+1, ind);
    return 1;
  }
  //printf("retorna 0\n");
  return 0;
}

int meuFree(unsigned char *adr){
  int i, j, end, aux;

  end = (int) adr - (int) heap_i;
  

  if (!achaEnd(end, &i, &j)){
    printf("Nao achou endereco.\n");
    return 0;
  }

  aux = juntaBudd(i, j);

  if (aux == -1){
    //printf("nao juntou\n");fflush(stdout);
    heap[i][j].livre = 1;
    return 1;
  }

  if (aux == 1)
    return 1;
  if (aux == 0){
    heap[i][j].livre = 1;
    while (heap[i][j+1].vazio != 1){
      //heap[i][j] = heap[i][j+1];
		  
      j++;
    }

    heap[i][j+1].vazio = 1;
    return 1;
  }
  return 0;
}

void imprimeMapa(){
  int i,j,x,k;
  for(i=10;i>=0;i--){
    for (k=0,x=1;i>k; k++)
      x *= 2;
    for(j=0;j<TAM_MAX && heap[i][j].vazio == 0;j++){
      //printf("Tamanho bloco: %d\n",x);//printf("i=%d. j=%d, l=%d\n",i, j, heap[i][j].livre);
      printf("#");
      for(k=0;k<x;k++){
	if(heap[i][j].livre == 1)
	  printf("-");
	else
	  printf("+");
      }
      //printf("\n");
    }
  }
}

void* meuRealloc(unsigned char *adr, int ntam){
  unsigned char *nmal;
  int i, j, x, end, k, l, m, enda, endb;
  nmal = meuMalloc(ntam);
  //printf("alocou\n");fflush(stdout);
  if (!nmal)
    return NULL;
  end = (int) adr - (int) heap_i;
  achaEnd(end, &i, &j);
  for (k=0, x=1; k<i; ++k)
    x *= 2;
  end = (int) nmal - (int) heap_i;
  //enda = (int) adr;
  //endb = (int) nmal;
  achaEnd(end, &l, &m);
  for (k=0; k<x; ++k)
    heap[l][m].end[k] = heap[i][j].end[k];
  meuFree(adr);
  return nmal;
}
