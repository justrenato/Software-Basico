#include <stdio.h>
#include <stdlib.h>

void start();

int main(int argc, char const *argv[])
{
  for (int i = 0; i < 5; ++i)
	{
		start();
	}
	return 0;
}


/*#include  <stdio.h>
#include  <unistd.h>
int  main(int argc , char **argv) {

	for (int i = 0; i < 30; ++i)
	{
		printf("%p\n",sbrk (0));
	}

}*/