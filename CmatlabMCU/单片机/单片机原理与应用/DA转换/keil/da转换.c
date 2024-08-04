#include <REGX51.H>
#include <absacc.h>
#include <math.h>
#define DAC0832 XBYTE[0X7FFF]
code unsigned char Sin[128]={64,67,70,73,76,79,82,85,88,91,94,96,99,102,104,106,109,111,113,115,117,
118,120,121,123,124,125,126,126,127,127,127,127,127,127,127,126,126,125,124,123,121,120,118,
117,115,113,111,109,106,104,102,99,96,94,91,88,85,82,79,76,73,70,67,64,60,57,54,51,48,45,42,39,
36,33,31,28,25,23,21,18,16,14,12,10,9,7,6,4,3,2,1,1,0,0,0,0,0,0,0,1,1,2,3,4,
6,7,9,10,12,14,16,18,21,23,25,28,31,33,36,39,42,45,48,51,54,57,60};
void delay(unsigned int j)
{
	while(j--);
}
void fangbo()
{
	while(P1==0xfe)
	{
		DAC0832=0xff;
		delay(500);
		DAC0832=0x00;
		delay(500);
	}
}
void sanjiao()
{
	unsigned int i;
	while(P1==0xfd)
	{
		for(i=0;i<255;i++);
		DAC0832=i;
		for(i=255;i>0;i--);
		DAC0832=i;
		DAC0832=0;
	}
}
void juchi()
{
	int i;
	while(P1==0xfb)
	{
		for(i=0;i<255;i++);
		DAC0832=i;
	}
}
void zhengxian()
{
	int i;
	while(P1==0xf7)
	{
		for(i=0;i<128;i++)
			DAC0832=Sin[i];
	}
}
void main()
{
	char a;
	P1=0xff;
	while(1)
	{
		a=P1;
		switch(a)
		{
			case 0xfe:fangbo();break;
			case 0xfd:sanjiao();break;
			case 0xfb:juchi();break;
			case 0xf7:zhengxian();break;
			default:break;
		}
	}
}