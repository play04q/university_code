#include <REGX51.H>
void main()
{
	char i=0;
	SCON=0x40;
	TMOD=0x20;
	TH1=0xFA;
	TL1=0xFA;
	TR1=1;
	P1=0xff;
	while(1)
	{
		while(P1==i);
		i=P1;
		SBUF=i;
		while(TI==0);
		TI=0;
	}
}