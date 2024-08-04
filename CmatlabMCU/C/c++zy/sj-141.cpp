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
	cout<<"明文"<<endl;
	gets(mingwen);
	b=strlen(mingwen);
	for (i=0;i<b;i++)
		miwen[i]=((mingwen[i]-'a'+1)+(key[i%a]-'a'+1))%26+'a'-1;
	cout<<"密文"<<endl;
    puts(miwen);
    return 0;
}
