/*#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int a, b, c, sa, sb, sc;
	for (a = 1; a <= 3; a++)
		for (b = 1; b <= 3; b++)
			for (c = 1; c <= 3; c++)
			{
				sa = (b > a) + (c == a);
				sb = (a > b) + (a > c);
				sc = (c>b) + (b > a);
				if ((sa == 2) && (a == 1) && (b = a) && (c > a))
					if (b > c)
						cout << "B C A" << endl;
					else
						cout << "C B A" << endl;
				if ((sb == 2) && (b == 1) && (a>b) && (c > b))
					if (a > c)
						cout << "A C B" << endl;
					else
						cout << "C A B" << endl;
				if ((sc == 2) && (c == 1) && (a>c) && (b>c))
					if (a>b)
						cout << "A B C" << endl;
					else
						cout << "B A C" << endl;
			}
	system("pause");
	return 0;
}*/