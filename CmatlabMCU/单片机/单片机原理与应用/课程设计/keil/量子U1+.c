#include <REGX51.H>
sbit p22=P2^2;
void main()
{
	char i = rand()%16;
	SCON=0x40;
	TMOD=0x20;
	TH1=0xFA;
	TL1=0xFA;
	TR1=1;
	P1=0x00;
	if(p22==0)
	{
		i = rand()%14;
		while(p22==0);
	}
	P1=i;
	while(1)
	{
		while(P1==i);
		i=P1;
		SBUF=i;
		while(TI==0);
		TI=0;
	}
}