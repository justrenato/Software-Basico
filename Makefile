all: ob exec

ob: meuAloc.s
	as meuAloc.s -o meuAloc.o

exec: meuAloc.o
	ld meuAloc.o -o meuAloc

clean:
	-rm *.o

purge: clean
	-rm meuAloc a.out