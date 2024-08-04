#include<iostream>
#include <string.h>
using namespace std;
int main()
{
    char *s1="hello";
    char s2[20]="boy";
    char *s3="zhd";
    char ss[20]="you";
    cout<<strncat(ss,s1,2)<<endl;
    cout<<strcat(ss,s1)<<endl;
    //cout<<strcat(s3,s1)<<endl;
    cout<<strcpy (s2,ss)<<endl;
    //cout<<strcpy(s3,s1)<<endl;
    cout<<strchr (s1,'e')<<endl;
    cout<<strstr(s1,"II")<<endl;
    return 0;    
}
