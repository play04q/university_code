#include <REGX51.H>
sbit start=P2^5;
sbit eoc=P2^6;
sbit oe=P2^7;
sbit clock=P2^4;
sbit p21=P2^1;
sbit p22=P2^2;
sbit p23=P2^3;
char code tab[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x7f,0x6f};
void int1() interrupt 1 using 1
{
	clock=~clock;
}
void main()
{
	char date;
	char bzlc=220;
	double ddate;
	char bw,sw,gw;
	char i;
	TMOD=0x02;
	TH0=246;
	TL0=246;
	IE=0x82;
	TR0=1;
	while(1)
	{
		start=0;
		start=1;
		start=0;
		for(i=0;i<20;i++);
		while(eoc==0);
		oe=1;
		date=P1;
		oe=0;
		ddate=date;
		ddate=(ddate/225)*bzlc;
		date=ddate;
		bw=date/100;
		sw=(date-bw*100)/10;
		gw=date-bw*100-sw*10;
		if(bw)
		{
			p23=0;
			P0=tab[bw];
			for(i=0;i<25;i++);
			p23=1;
		}
		else
		{
			p23=0;
			P0=0x00;
			for(i=0;i<25;i++);
			p23=1;
		}
		if(bw==0)
		{
			if(sw)
			{
				p22=0;
				P0=tab[sw];
				for(i=0;i<25;i++);
				p22=1;
			}
			else
			{
				p22=0;
				P0=0x00;
				for(i=0;i<25;i++);
				p22=1;
			}
		}
		else
		{
			p22=0;
			P0=tab[sw];
			for(i=0;i<25;i++);
			p22=1;
		}
		p21=0;
		P0=tab[gw];
		for(i=0;i<25;i++);
		p21=1;
	}
}