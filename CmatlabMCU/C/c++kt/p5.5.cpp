#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int x, y, z;
	cin >> x >> y;
	if (x > y)
	{
		z = x;
		x = y;
		y = z;
	}
	z = x;
	while (y % z != 0)
	{
		z--;
	}
	cout << z << endl;
	system("pause");
	return 0;
}