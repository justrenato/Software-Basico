OBJETOS = test.o $(addsuffix .o,$(MODULOS))

.PHONY : all clean

all : 	
#assembly into c
	as --32 heap.s -o heap.o
	gcc -m32 -c heap_test.c -o heap_test.o
	gcc -m32 -static heap_test.o heap.o -o heap_test
#make; ./heap_test

c : 
#pure c call
	gcc heap.c heap_test.c -o heap_test
	gcc -c heap.c -o heap.o
	gcc -c heap_test.c -o heap_test.o
	gcc heap_test.o heap.o -o heap_test
#./heap_test

teste : 
	$(OBJETOS)

clean : 
	$(RM) $(OBJETOS)
