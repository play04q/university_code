#include <iostream>
using namespace std;
void main()
{
	do 
	{
		printf("abc=");
		int a, b, c, d, e;
		cin >> d;
		a = d / 100;
		b = (d % 100) / 10;
		c = (d % 100) % 10;
		e = a + b + c;
		printf("%d\n", e);
	} while (true);
}