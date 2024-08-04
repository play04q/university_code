/*#include<iostream>
#include<stdlib.h>
using namespace std;
int main()
{
	int a[10][10];
	int n, b=0;
	cin >> n;
	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= n; j++)
			if (i == 1 || i == n || j == 1 || j == n)
				a[i][j] = 1;
	for (int i = 1; i <= n; i++)
	{
		for (int j = 1; j <= n; j++)
			cout << a[i][j] << " ";
		cout << endl;
	}
	system("pause");
	return 0;
}*/