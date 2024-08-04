/*#include<iostream>
#include<stdlib.h>
using namespace std;
int main()
{
	int n, b = 0;
	int a[100][100];
	cin >> n;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < n; j++)
			cin >> a[i][j];
	for (int i = 0, j = 0; i < n; i++, j++)
		b = b + a[i][j];
	for (int i = n - 1, j = 0; i >= 0; i--, j++)
		b = b + a[i][j];
	cout << b << endl;
	system("pause");
	return 0;
}*/