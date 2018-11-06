all: ob exec

ob: meuAloc.asm
	as meuAloc.asm -o meuAloc.o

exec: meuAloc.o
	ld meuAloc.o -o meuAloc -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt* -lc
	
clean:
	-rm *.o

purge: clean
	-rm meuAloc a.out