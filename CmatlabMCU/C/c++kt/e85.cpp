/*#include <iostream>
#include <stdlib.h>
using namespace std;
int max(int a, int b)
{
	return a > b ? a : b;
}
int min(int c, int d)
{
	return c < d ? c : d;
}
int main()
{
	int n, x, p = 0, q = 100, sum = 0;
	cout << "����������";
	cin >> n;
	for (int i = 1; i <= n; i++)
	{
		cout << "input" << i << "���и��֣�";
		cin >> x;
		p = max(p, x);
		q = min(q, x);
		sum += x;
	}
	cout << "Score:" << (sum - p - q) / (n - 2) << endl;
	system("pause");
	return 0;
}*/