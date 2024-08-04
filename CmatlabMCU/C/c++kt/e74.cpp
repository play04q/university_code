/*#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int i, key, aSize = 10, low, high, middle;
	low = 0;
	high = aSize - 1;
	const int a[] = {1,3,5,7,9,11,13,15,17,19};
	cin >> key;
	while (low <= high)
	{
		middle = (low + high) / 2;
		if (key = a[middle])
		{
			cout << middle << endl;
			break;
		}
		else if (key < a[middle])
			high = middle - 1;
		else
			low - middle + 1;
	}
	if (low > high)
		cout << "N";
	system("pause");
	return 0;
}*/