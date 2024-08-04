#include <iostream>
#include <string.h>
using namespace std;
int main()
{
    char a[50],c='A',e[50];
    gets(a);
    int b=strlen(a),d,i;
    for(i=0;i<=b;i++)
    {
        if (c==a[i])
            cout<<a[i]<<" ";
        else
            cout<<a[i];
    }
    for(i=0;i<=b;i++)
    {
        if((a[i]<=90&&a[i]>=65)||(a[i]<=122&&a[i]>=97))
            e[i]=a[i];
        else
            e[i]=0;
        d=strlen(e);
    }
    cout<<endl;
    //puts(e);
    cout<<d<<endl;
    return 0;
}