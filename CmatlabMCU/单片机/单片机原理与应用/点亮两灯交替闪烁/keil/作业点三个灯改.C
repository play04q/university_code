#include <REGX51.H>
#define uint unsigned int
#define uchar unsigned char
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
				P0_0 = ~P0_0;
				P0_1 = ~P0_1;
			}
			if(t==40)
			{
				P0_0 = ~P0_0;
				P0_1 = ~P0_1;
			}
			if(t==60)
			{
				P0_0 = ~P0_0;
				P0_1 = ~P0_1;
			}
			TH0=0x3c;
			TL0=0xb0;
		}
	}
}