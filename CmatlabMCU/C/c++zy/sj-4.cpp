#include <stdio.h>
#include <stdlib.h>
int main()
{
	int a, b, c;
	scanf_s("%d %d", &a, &b);
	c = a;
	a = b;
	b = c;
	printf("%d %d\n", a, b);
	system("pause");
	return 0;
}