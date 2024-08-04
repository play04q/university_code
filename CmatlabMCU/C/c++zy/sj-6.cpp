#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int n, a = 1, b = 0;
	cin >> n;
	for (int i = 1; i <= n; i++)
	{
		a = a * i;
		b = b + a;
	}
	cout << b << endl;
	system("pause");
	return 0;
}