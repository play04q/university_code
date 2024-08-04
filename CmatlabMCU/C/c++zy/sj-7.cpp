#include <stdio.h>
#include <stdlib.h>
int main()
{
	for (int a = 1; a <= 5; a++)
	{
		int b, c;
		for (c = 5; c >= a; c--)
		{
			printf(" ");
		}
		for (b = 1; b <= a; b++)
		{
			printf("%d", b);
		}
		printf("\n");
	}
	system("pause");
	return 0;
}