LDFLAGS = -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt* -lc
all: ob exec

ob: meuAloc.asm alocadorEmC.c
	as meuAloc.asm -o meuAloc.o
	gcc -c alocadorEmC.c -o alocadorEmC.o

exec: meuAloc.o
	ld meuAloc.o alocadorEmC.o -o meuAloc $(LDFLAGS)
	
clean:
	-rm -f *.o

purge: clean
	-rm -f meuAloc a.out