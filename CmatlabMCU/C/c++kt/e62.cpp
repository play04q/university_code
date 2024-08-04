/*#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int c1, c2, c3, c4, c5, c6;
	for(int a=0;a<=1;a++)
		for (int b = 0; b <= 1; b++)
			for (int c = 0; c <= 1; c++)
				for (int d = 0; d <= 1; d++)
					for (int e = 0; e <= 1; e++)
						for (int f = 0; f <= 1; f++)
						{
							c1 = a | b;
							c2 = !(a && d);
							c3 = (a && c) || (a && f) || (c && f);
							c4 = (b && c) || (!b && !c);
							c5 = (c && !d) || (!c && d);
							c6 = d | (!d && !e);
							if (c1 + c2 + c3 + c4 + c5 + c6 == 6)
							{
								cout << "A:" << (a == 0 ? "n" : "y") << endl;
								cout << "B:" << (b == 0 ? "n" : "y") << endl;
								cout << "C:" << (c == 0 ? "n" : "y") << endl;
								cout << "D:" << (d == 0 ? "n" : "y") << endl;
								cout << "E:" << (e == 0 ? "n" : "y") << endl;
								cout << "F:" << (f == 0 ? "n" : "y") << endl;
							}
						}
	system("pause");
	return 0;
}*/