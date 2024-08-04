#include<iostream>
using namespace std;
void t1(int n)
{
	if(n>0)
	{
		for (int i=1;i<=n;i++)
			cout<<n<<" ";
		cout<<endl;
		t1(n-1);
		for (int i=1;i<=n;i++)
			cout<<n<<" ";
		cout<<endl;
	}
}		
int main()
{
	t1(4);
	return 0;
}