# LDFLAGS = -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt* -lc
# all: meuAloc
# meuAloc: alocadorEmC.o meuAloc.o
# 	ld alocadorEmC.o meuAloc.o -o meuAloc 

# alocadorEmC.o: alocadorEmC.c
# 	gcc -c  alocadorEmC.c -o alocadorEmC.o -g

# meuAloc.o: meuAloc.asm
# 	as meuAloc.asm -o meuAloc.o -g
	
# clean:
# 	-rm -f *.o

# purge: clean
# 	-rm -f meuAloc a.out


#FUNCIONA USANDO ESSE MAKE QUANDO NAO HA ACESSO A MEMORIA ATRAVES DAS INSTRUÇÔES.
all: meuAloc

meuAloc: meuAloc.o alocadorEmC.c
	gcc -no-pie alocadorEmC.c meuAloc.o -o meuAloc -g

meuAloc.o: meuAloc.asm
	as meuAloc.asm -o meuAloc.o -g
	
clean:
	-rm -f *.o

purge: clean
	-rm -f meuAloc a.out



#substituir por esse comando funciona da mesma forma que o make acima
#gcc -fno-pie -no-pie alocadorEmC.c meuAloc.o -o meuAloc -g
#gcc -static alocadorEmC.c meuAloc.o -o meuAloc -g
