#include<iostream>
#include<cstring>
using namespace std;
char s1[100],s2[100];
int main()
{
    cin>>s1>>s2;
    if(strstr(s2,s1))
    cout<<s1<<" is substring of "<<s2<<endl;
    else
    cout<<s1<<" is not substring of "<<s2<<endl;
    if(strstr(s1,s2))
    cout<<s2<<" is substring of "<<s1<<endl;
    else
    cout<<s2<<" is not substring of "<<s1<<endl;
    return 0;
}

