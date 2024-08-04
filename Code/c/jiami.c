#include <stdio.h>
#include <string.h>
int main()
{
	char a[10000];
	gets(a);
	int b,c=strlen(a),d;
	printf("key=");
	scanf("%d", &b);
	for (int i = 0; i < c; i++)
	{
		d=a[i]+b;
		printf("%d ",d);
	}
	printf("\n");
	return 0;
}