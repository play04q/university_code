#include <iostream>
#include <cstring>
using namespace std;
int main()
{
    char *s1="hello";
    char s2[20]="boy";
    char *s3="zhd";
    char ss [20]="you";
    cout<<strlen(s1)<<endl;
    cout<<strlen(s2)<<endl;
    cout<<strcmp(s1,s2)<<endl;
    cout<<strcmp (s2,s1)<<endl;
    cout<<strcmp(s1,s3)<<endl;
    return 0;
}
