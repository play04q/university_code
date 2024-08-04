#include <stdio.h>
#include "f1.h"
int main()
{
	int x, y;
	do
	{
		printf("x=");
		scanf("%d", &x);
		y = 10 * x;
		printf("%d\n", y);
		f1();
	} while (y == 10 * x);
	return 0;
}