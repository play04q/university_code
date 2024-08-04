#include <stdio.h>
#include <stdlib.h>
int main()
{
    int i, n, m, a = 0, b = 0;
    scanf("%d%d", &n, &m);
    int c[n];
    for (i = 0; i < n; i++)
        c[i] = 0;
    for (i = 0; i < m; i++)
    {
        a = a % 10;
        c[a] = 1;
        a =a + i + 2;
    }
    for (i = 0; i < n; i++)
    {
        if (c[i] == 0)
        {
            b = i + 1;
            printf("%d ", b);
        }
    }
	printf("\n");
    system("pause");
    return 0;
}
