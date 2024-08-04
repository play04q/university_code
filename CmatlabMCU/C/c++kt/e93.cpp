#include<iostream>
#include<cstring>
using namespace std;
char s[80];
int main()
{
    int n;
    gets(s);
    n=strlen(s);
    for (int i=0;i<n;++i)
    {
        if(s[i]=='z'||s[i]=='Z')
        s[i]=s[i]-25;
        else if(s[i]>='a'&&s[i]<'z'||s[i]>='A'&&s[i]<'Z')
        s[i]=s[i]+1;
        cout<<s[i];
    }
    return 0;
}
