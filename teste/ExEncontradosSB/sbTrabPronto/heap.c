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
#define NUM_OPER 32

static char* heap; //heap size
static ApSector rootSector;

ApSector meuAlocaMem (int num_bytes) {
	if (rootSector == NULL)
	  rootSector = makeSector(NULL, NULL, 0);

	ApSector sector = findSectorFree(rootSector, num_bytes);
	if (sector == NULL) {
		printf("[INFO] Sector not found %d\n", num_bytes);
		heap_extend(num_bytes);
		ApSector lastSector = heap_lastsector(rootSector);
		sector = makeSector(lastSector, NULL, num_bytes);
		printf("[INFO] Sector maked\n");
	} else {
		printf("[INFO] Sector HAS found %d\n", sector->size);
		int over = sector->size - num_bytes;
		if (over > 0) {
			printf("[INFO] Make Virtual Sector %d\n", over);
			ApSector sectorOver = makeSector(sector, sector->next, over);			
			sectorOver->free = 1;
		}
		sector->size = num_bytes;
		sector->free = 0;
	}
	return sector;
}

void deframent(ApSector sector) {
	if (sector->free) {
		heap_extend(sector->size * -1);
		sector->prev->next = NULL;
		deframent(sector->prev);
	}
}

void meuLiberaMem (ApSector sector) {
	sector->free = 1;
//tratamento de fim de setores livres redimensiona heap
	ApSector last = heap_lastsector(rootSector);
	deframent(last);
}

void imprSector(ApSector sector, int heapSize) {
	if (sector != NULL) {
		if (sector->size > 0) {
			//printf("> Sector size %d\n", sector->size);
			float sectorPerc = ((float) 100 / heapSize) * sector->size;
			if (sector->free) {
				printf("|  %d  ", (int) sectorPerc);
			} else {
				printf("|--%d--", (int) sectorPerc);
			}
		}
		imprSector(sector->next, heapSize);
	}
}

void imprMapa () {
//calcula tamanho total
	ApFragment h = heap_size(rootSector);
	printf("> Heap Size: %d\n", h->size);
	ApFragment occuped = heap_size_occuped(rootSector);
	printf("> Heap Occuped: %d\n", occuped->size);
	ApFragment free = heap_size_free(rootSector);
	printf("> Heap Free: %d\n", free->size);
//calcula percentual de cada setor
	imprSector(rootSector, h->size);
	printf("|\n");
//imprime texto conforme exemplo

//   |----%----|---%---|   %   |-%-|
}

/*---------------------------------------------------------------------------*/
/* Funcoes de gerenciamento da HEAP                                          */
/*---------------------------------------------------------------------------*/

ApSector makeSector(ApSector prev, ApSector next, int size) {
	ApSector sector = malloc(sizeof(ApSector));
	sector->free = 0;
	sector->size = size;
	if (prev != NULL) {
		sector->prev = prev;
		prev->next = sector;
	}
	if (next != NULL) {
		sector->next = next;
		next->prev = sector;
	}
	return sector;
}

ApSector findSectorFree(ApSector root, int num_bytes) {
	if (root == NULL) {
		return NULL;
	}
	if (root->free) {
		printf("[INFO] Sector test %d / %d\n", root->size, num_bytes);
		if (root->size >= num_bytes) {
			return root;
		}	
	}
	return findSectorFree(root->next, num_bytes);
}

ApSector heap_lastsector(ApSector root) {
	if (root->next == NULL) 
		return root;
	return heap_lastsector(root->next);	 
}

ApFragment makeFragment() {
	ApFragment f = malloc(sizeof(ApFragment));
	f->sectors = 0;
	f->size = 0;
	return f;
}

ApFragment heap_size_occuped(ApSector root) {
	if (root == NULL) return makeFragment();	
	ApFragment f = heap_size_occuped(root->next);
	if (!root->free) {
		f->size += root->size; 
		f->sectors++;
		return f;
	}
	return f;
}

ApFragment heap_size_free(ApSector root) {
	if (root == NULL) return makeFragment();	
	ApFragment f = heap_size_free(root->next);
	if (root->free) {
		f->size += root->size; 
		f->sectors++;
		return f;
	}
	return f;
}

ApFragment heap_size(ApSector root) {
	ApFragment free = heap_size_free(root);
	ApFragment occuped = heap_size_occuped(root);
	free->sectors += occuped->sectors;
	free->size += occuped->size;
	return free;
}

void heap_extend(int num_bytes) {
	printf("Extend %d\n", num_bytes);
	ApFragment heapSize = heap_size(rootSector);
	heap = malloc(heapSize->size + num_bytes); //sbrk increment / decrement
}

