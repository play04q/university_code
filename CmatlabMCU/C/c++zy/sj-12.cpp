#include <iostream>
using namespace std;
int f(int n)
{
    return n==0?1:f(n-1)/2;
}
int main()
{
 	double h=100,n=0;
 	for (int i = 1; i <= 10; i++)
 	{
  		n=n+h;
  		h=h/2;
   		n=n+h;
   	}
 	cout << n << endl;
	cout << h << endl;
 	return 0;
}