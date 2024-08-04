#include <REGX51.H>
#define uint unsigned int
#define uchar unsigned char
sbit P0_0=P0^0;
sbit P0_1=P0^1;
uint t=0;
void main()
{
	TMOD=0x01;
	TH0=0x3c;
	TL0=0xB0;
	TR0=1;
	P0_0=1;
	P0_1=0;
	while(1)
	{
		if(TF0==1)
		{
			t++;
			TF0=0;
			if(t==20)
			{
				t=0;
				P0_0 = ~P0_0;
				P0_1 = ~P0_1;
			}
			TH0=0x3c;
			TL0=0xb0;
		}
	}
}