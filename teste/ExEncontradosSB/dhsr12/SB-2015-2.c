#include <stdio.h>
#include <stdlib.h>

main (int argc, char **argv) {

  int i;
  char *a, *b, *c, *d;
  initHeap();
  imprimeMapa();
  printf("\n");
 a = meuMalloc(128);
  imprimeMapa();
  printf("\n");
  b = meuMalloc(128);
  imprimeMapa();
  printf("\n");
  c = meuMalloc(256);
  imprimeMapa();
  printf("\n");
  d = meuMalloc(512);
  imprimeMapa();
  printf("\n");
  meuFree (a);
  imprimeMapa();
  printf("\n");
  meuFree (b);
  a = meuMalloc(256);  
  imprimeMapa();
  printf("\n");
  meuFree (a);
  imprimeMapa();
  printf("\n");
  meuFree (c);
  imprimeMapa();
  printf("\n");
  meuFree (d);
  imprimeMapa();
  printf("\n");
}
