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
  for (i=0;i<128;i++){
    if (i<32) a[i]='a';
    else if (i<64) a[i]='b';
    else if (i<96) a[i]='c';
    else a[i]='d';
  }
  imprimeMapa();
  printf("\n");
  b = meuMalloc(128);
  imprimeMapa();
  printf("\n");
  //printf("\n\n%s\n\n\n", a);
  a = meuRealloc(a,256);
  imprimeMapa();
  printf("\n");
  //printf("\n\n%s\n\n\n", a);
  for (i=0;i<256;i++){
    if (a[i]==0) printf("-");
    else printf("%c", (char) a[i]);
  }
  printf("\n");
}
