#include <REGX51.H>
void main()
{
	char i=0;
	SCON=0x50;
	TMOD=0x20;
	TH1=0xFA;
	TL1=0xFA;
	TR1=1;
	while(1)
	{
		while(RI==i);
		RI=0;
		i=SBUF;
		P1=i;
	}
}