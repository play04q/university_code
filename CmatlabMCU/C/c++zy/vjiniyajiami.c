#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main()
{
	char mingwen[1000]="/0";
	char miwen[1000]="/0";
	char key1[100]="/0";
	int num=0,keynum=0;
	int signal = 1;
	printf("加密还是解密?加密1,解密0\n");
	scanf("%d", &signal);
	getchar();//吞掉前面scanf剩下的一个回车，若没有此句，下面的gets语句直接读取回车就会结束
	if (signal) 
    {
		printf("请输入密钥：（要求小写英文字母且无空格，输入结束按回车键）\n");
		
		gets(key1);
		keynum = strlen(key1);//密钥长度

		printf("请输入明文：\n");
		gets(mingwen);
		int mingnum;
		mingnum = strlen(mingwen);//明文长度

		//加密
		int i = 0;
		for (i = 0; i < mingnum; i++)
		{
			miwen[i] = (mingwen[i] - 'a' + key1[i % keynum] - 'a') % 26 + 'a';

		}
		printf("密文是: %s \n", miwen);
	}
	else 
    {
		printf("请输入密钥：（要求小写英文字母且无空格，输入结束按回车键）\n");

		gets(key1);
		keynum = strlen(key1);//密钥长度

		printf("请输入密文：\n");//agtycz
		gets(miwen);
		int minum;
		minum = strlen(miwen);//明文长度

		//解密
		int i = 0;
		for (i = 0; i < minum; i++)
		{
			mingwen[i] = (miwen[i] - key1[i % keynum] + 26 ) % 26 + 'a';

		}
		printf("明文是: %s \n", mingwen);
	}

	system("pause");

} 