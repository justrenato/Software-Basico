/*
----------------------------
UFPR 
Arylson Arruda Bueno
GRR20111066
Software Básico
Gerenciador de HEAP
----------------------------
*/

typedef struct Sector *ApSector;
typedef struct Sector {
	int free;       //1 1-0
	int size;	    //4 sector size (with header)
	ApSector prev;  //4 address header
	ApSector next;  //4 address header
} TipoSector;

typedef struct Fragment *ApFragment;
typedef struct Fragment {
	int sectors;       
	int size;	    	   //byte size
} TipoFragment;

/*---------------------------------------------------------------------------*/
/* Funcoes de gerenciamento da HEAP                                          */
/*---------------------------------------------------------------------------*/
ApSector meuAlocaMem (int num_bytes);
void  meuLiberaMem (ApSector sector);
void  imprMapa ();

/*---------------------------------------------------------------------------*/
/* Funcoes internas                                                          */
/*---------------------------------------------------------------------------*/
ApSector makeSector();
ApSector findSectorFree(ApSector root, int num_bytes);
ApSector heap_lastsector(ApSector root);
ApFragment heap_size_free(ApSector root);
ApFragment heap_size_occuped(ApSector root);
ApFragment heap_size(ApSector root);
void heap_extend(int num_bytes);

