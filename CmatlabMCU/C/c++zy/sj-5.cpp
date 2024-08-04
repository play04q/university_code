#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int a, b, c, d, e;
	cin >> a >> b >> c >> d;
	if (a > b)
	{
		e = a;
		a = b;
		b = e;
	}
	if (a > c)
	{
		e = a;
		a = c;
		c = e;
	}
	if (a > d)
	{
		e = a;
		a = d;
		d = e;
	}
	if (b > c)
	{
		e = b;
		b = c;
		c = e;
	}
	if (b > d)
	{
		e = b;
		b = d;
		d = e;
	}
	if (c > d)
	{
		e = c;
		c = d;
		d = e;
	}
	cout << a << " " << b << " " << c << " " << d << endl;
	system("pause");
	return 0;
}