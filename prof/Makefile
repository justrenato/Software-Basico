all: alocador

alocador: meuAloc.o alocadorEmC.c
	gcc alocadorEmC.c meuAloc.o -o alocador 

meuAloc.o: meuAloc.asm
	as meuAloc.asm -o meuAloc.o 

clean:
	-rm -f alocador *.o 
