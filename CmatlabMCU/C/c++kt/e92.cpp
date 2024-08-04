#include<iostream>
#include <cstring>
using namespace std;
int main()
{
    int up=0,low=0,space=0,num=0,other=0;
    char str [100];
    gets(str);
    for(int j=0;j<strlen(str);j++)
    {
        if (str [j]>='A'&&str[j]<='Z')
            up++;
        else if (str[j]>='a'&&str[j]<='z')
            low++;
        else if (str[j]>='0'&&str[j]<='9')
            num++;
        else if(str[j]==' ')
            space++;
        else
            other++;
    } 
    cout<<up<<" "<<low<<" "<<num<<" "<<space<<" "<<other<<endl;
    return 0;
}
