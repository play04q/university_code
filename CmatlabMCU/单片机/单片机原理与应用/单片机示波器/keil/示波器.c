#include <REGX51.H>
int t=0;
void main()
{
	TMOD=0x00;
	TH0=0xfc;
	TL0=0x1c;
	TR0=1;
	P1_0=1;
	while(1)
	{
		if(TF0==1)
		{
			t++;
			TF0=0;
			if(t==2)
			{
				P1_0=0;
			}
			if(t==10)
			{
				t=0;
				P1_0=1;
			}
			TH0=0xfc;
			TL0=0x1c;
		}
	}
}