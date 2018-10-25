all: ob exec

ob: teste.s
	as teste.s -o teste.o

exec: teste.o
	ld teste.o -o teste

clean:
	-rm *.o

purge: clean
	-rm teste a.out