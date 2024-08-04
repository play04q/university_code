#include <iostream>
#include <stdlib.h>
using namespace std;
double h = 100;
double f1()
{
	h = h / 2;
	return h;
}
int main()
{
	double a, b = 0;
	for (int i = 1; i <= 10; i++)
	{
		b = b + f1();
	}
	a = b * 2 + 100;
	cout << a << endl;
	cout << f1() << endl;
	system("pause");
	return 0;
}