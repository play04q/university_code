#include<iostream>
using namespace std;
int main()
{
    char *s1="hello";
    char s2[20]="boy";
    cout<<"s1="<<s1<<endl;
    cout<<"s2="<<s2<<endl;
    cout<<"&s1="<<&s1<<endl;
    cout<<"&s2="<<&s2<<endl;
    cout<<"*s1="<<s1<<endl;
    cout<<"*s2="<<*s2<<endl;
    cout<<"*&s1="<<*&s1<<endl;
    cout<<"*&s2="<<*&s2<<endl;
    cout<<"**&s1="<<**&s1<<endl;
    cout<<"**&s2="<<*&s2<<endl;
    return 0;
}
