#include <REGX51.H>
#include <intrins.h>
char j;
int n;
const char tab1[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,};
const char tab2[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,};
/*void delay(int n)
{
	int i;
	for(i=0;i<n;i++);
}*/
void Delay600ms()		//@12.000MHz
{
	unsigned char i, j, k;

	_nop_();
	i = 5;
	j = 144;
	k = 71;
	do
	{
		do
		{
			while (--k);
		} while (--j);
	} while (--i);
}
void Int0_server_() interrupt 0
{
	char a;
	a=tab2[j];
	P0=a;
}
void Int1_server_() interrupt 2
{
	P0=0x00;
}
void Init_Int()
{
	EX0=1;
	IT0=1;
	EX1=1;
	IT1=0;
	EA=1;
}
void main()
{
	P0=0x00;
	Init_Int();
	while(1)
	{
		for(j=0;j<10;j++)
		{
			P2=tab1[j];
			Delay600ms();
		}
	}
}
