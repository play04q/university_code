#include <iostream>
#include <cstring>
using namespace std;
char s[100];
int main()
{
    int i,j,k;
    cin>>s;
    j=strlen(s)-1;
    k=j;
    for (i=0;i<=k/2;i++)
    if(s[i]!=s[j--])
    break;
    if (i>=j)
    cout<<"yes"<<endl;
    else
    cout<<"no"<<endl;
    return 0;    
}
