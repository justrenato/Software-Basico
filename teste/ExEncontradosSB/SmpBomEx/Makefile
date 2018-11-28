LDFLAGS = -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt* -lc

all: alocador


alocador: teste.o smpBom.o
	ld teste.o smpBom.o -o teste  $(LDFLAGS) -g

teste.o: teste.c
	gcc -c teste.c -o teste.o -g

smpBom.o: smpBom.s
	as smpBom.s -o smpBom.o -g

clean:
	-rm -f *.o

purge: clean
	-rm -f teste a.out