#include <stdio.h>
#include <stdlib.h>
int main()
{
	int N, a[100][100];//二维数组
	int x = 1, m, n, i, j, square, b;
	scanf_s("%d", &N);
	square = N * N;
	a[1][N] = 1;//首先确定1的位置
	m = 1;
	n = N;
	b = N;
	while (x < square)
	{//因为这种算法N在变化，所以用square

		while (m < N && n == N)
		{//当在右边一列的时候
			if (x == square)
				break;
			x++;
			m++;
			a[m][n] = x;
		}
		while (m == N && n > b - N + 1)
		{//在下面那一排
			if (x == square)
				break;
			x++;
			n--;
			a[m][n] = x;
		}
		while (m > b - N + 1 && n == b - N + 1)
		{//在左边那一列
			if (x == square)
				break;
			x++;
			m--;
			a[m][n] = x;
		}
		while (m == b - N + 1 && n < N - 1)
		{/*在上面那一排注意是N-1了。因为上面那一排最后一个已经有了一个数*/
			if (x == square)
				break;
			x++;
			n++;
			a[m][n] = x;
		}
		N -= 1;
	}
	N = b;
	for (i = 1; i < N; i++)
	{
		for (j = 1; j < N; j++)
			printf("%d ", a[i][j]);
		printf("%d", a[i][N]);
		printf("\n");
	}
	for (j = 1; j < N; j++)
		printf("%d ", a[i][j]);
	printf("%d\n", a[i][N]);
	system("pause");
	return 0;
}
