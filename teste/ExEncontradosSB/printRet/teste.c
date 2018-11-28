#include <stdio.h>

void iniciaAlocador();
void finalizaAlocador();
void *meuAlocaMem(int);
void meuLiberaMem(void *);
void imprMapa();

void main () {
	void *a,*b,*c,*d;

	iniciaAlocador();

	a=( void * ) meuAlocaMem(100);
	 imprMapa();
	b=( void * ) meuAlocaMem(200);
	 imprMapa();
	c=( void * ) meuAlocaMem(300);
	 imprMapa();
	d=( void * ) meuAlocaMem(400);
	 imprMapa();

	meuLiberaMem(b);
	 imprMapa(); 
	
	b=( void * ) meuAlocaMem(50);
	 imprMapa();
	
	meuLiberaMem(c);
	 imprMapa(); 
	meuLiberaMem(a);
	 imprMapa();
	meuLiberaMem(d);
	 imprMapa();
	meuLiberaMem(b);
	 imprMapa();

	 finalizaAlocador();
}