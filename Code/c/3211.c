#include <stdio.h>
#include <stdlib.h>
int main()
{
	int N, a[100][100];//��ά����
	int x = 1, m, n, i, j, square, b;
	scanf_s("%d", &N);
	square = N * N;
	a[1][N] = 1;//����ȷ��1��λ��
	m = 1;
	n = N;
	b = N;
	while (x < square)
	{//��Ϊ�����㷨N�ڱ仯��������square

		while (m < N && n == N)
		{//�����ұ�һ�е�ʱ��
			if (x == square)
				break;
			x++;
			m++;
			a[m][n] = x;
		}
		while (m == N && n > b - N + 1)
		{//��������һ��
			if (x == square)
				break;
			x++;
			n--;
			a[m][n] = x;
		}
		while (m > b - N + 1 && n == b - N + 1)
		{//�������һ��
			if (x == square)
				break;
			x++;
			m--;
			a[m][n] = x;
		}
		while (m == b - N + 1 && n < N - 1)
		{/*��������һ��ע����N-1�ˡ���Ϊ������һ�����һ���Ѿ�����һ����*/
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
