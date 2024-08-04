/*#include<iostream>
#include<stdlib.h>
using namespace std;
int main()
{
	int a[4][3], b[4][3], c[3][3];
	for (int i = 1; i <= 3; i++)
		for (int j = 1; j <= 4; j++)
			cin >> a[i][j];
	for (int i = 1; i <= 4; i++)
		for (int j = 1; j <= 3; j++)
			cin >> b[i][j];
	cout << endl;
	for (int i = 1; i <= 3; i++)
		for (int j = 1; j <= 3; j++) 
		{
			for(int k=1;k<4;k++)
				c[i][j] = a[i][k] * b[k][j];
			cout << c[i][j] << " ";
		}
	cout << endl;
	system("pause");
	return 0;
}*/