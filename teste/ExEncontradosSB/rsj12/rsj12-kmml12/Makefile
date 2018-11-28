export LDFLAGS='-m32 -L/usr/lib32'

all: meu_alocador.o teste.c
	gcc -m32 -o teste meu_alocador.o teste.c 

meu_alocador.o: meu_alocador.s
	as --32 meu_alocador.s -o meu_alocador.o 

clean:
	rm *.o
	rm teste
