#include <iostream>
#include <string.h>
using namespace std;
char mingwen[100],miwen[100],key[100];
int a,b,i;
int main()
{
    cout<<"密钥"<<endl;
	gets(key);
	a=strlen(key);
	cout<<"密文"<<endl;
	gets(miwen);
	b=strlen(miwen);
	for (i=0;i<b;i++)
		mingwen[i]=((miwen[i]-'a'+1)-(key[i%a]-'a'+1)+26)%26+'a'-1;
	cout<<"明文"<<endl;
    puts(mingwen);
    return 0;
}