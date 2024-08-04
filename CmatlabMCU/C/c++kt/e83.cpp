/*#include <iostream>
#include <stdlib.h>
using namespace std;
int a[4];
void f1(int b[], int n)
{
	int t;
	for(int i=0;i<n-1;i++)
		for(int j=1;j<n-1;j++)
			if (b[i] > b[j + 1])
			{
				t = b[i];
				b[i] = b[j + 1];
				b[j + 1] = 1;
			}
}
int main()
{
	int n, x, y;
	cin >> n;
	while (1)
	{
		a[0] = n / 1000;
		a[1] = (n / 100) % 10;
		a[2] = (n / 10) % 10;
		a[3] = n % 10;
		f1(a, 4);
		x = a[0] + a[1] * 10 + a[2] * 100 + a[3] * 1000;
		y = a[3] + a[2] * 10 + a[1] * 100 + a[0] * 1000;
		n = x - y;
		cout << n << " ";
	}
	system("pause");
	return 0;
}*/