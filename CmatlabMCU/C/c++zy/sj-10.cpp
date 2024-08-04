#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int a[8][8];
	int x = 1, c, d, i, j, e, b, n;
	cin >> n;
	e = n * n;
	a[1][n] = 1;
	for (c = 1, d = n, b = n; x < e; n = n - 1)
	{

		while (c < n && d == n)
		{
			if (x == e)
				break;
			x++;
			c++;
			a[c][d] = x;
		}
		while (c == n && d > b - n + 1)
		{
			if (x == e)
				break;
			x++;
			d--;
			a[c][d] = x;
		}
		while (c > b - n + 1 && d == b - n + 1)
		{
			if (x == e)
				break;
			x++;
			c--;
			a[c][d] = x;
		}
		while (c == b - n + 1 && d < n - 1)
		{
			if (x == e)
				break;
			x++;
			d++;
			a[c][d] = x;
		}
	}
	n = b;
	for (i = 1; i < n; i++)
	{
		for (j = 1; j < n; j++)
			cout << a[i][j] << " ";
		cout << a[i][n];
		cout << endl;
	}
	for (j = 1; j < n; j++)
		cout << a[i][j] << " ";
	cout << a[i][n] << endl;
	system("pause");
	return 0;
}
