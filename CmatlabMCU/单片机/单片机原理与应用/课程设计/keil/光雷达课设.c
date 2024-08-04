#include <REGX51.H>
#define uchar unsigned char
sbit start=P0^0;
sbit eoc=P0^2;
sbit oe=P0^1;
sbit clock=P0^3;
sbit l1=P0^4;
sbit l2=P0^5;
sbit l3=P0^6;
sbit l4=P0^7;
sbit arm=P1^2;
sbit safe=P1^0;
const char tab[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f};
void int1() interrupt 1 using 1
{
	clock=~clock;
}
void armf()
{
	if(safe==0)
	{
		arm=1;
		P1_1=1;
	}
	else
	{
		arm=0;
		P1_1=0;
	}
}
void main()
{
	uchar date;
	uchar miwei=6000;
	double ddate;
	uchar qw,bw,sw,gw;
	uchar i;
	//
	SCON=0x00;
	l1=l2=l3=l4=0;
	SBUF=0x3f;
	while(TI==0);
	TI=0;
	//
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
		while(eoc==0)
		oe=1;
		date=P2;
		oe=0;
		ddate=date;
		ddate=(ddate/255)*miwei;
		date=ddate;
		qw=date%1000;
		bw=(date-qw*1000)%100;
		sw=(date-qw*1000-bw*100)%10;
		gw=date-qw*1000-bw*100-sw*10;
		if(qw)
		{
			l1=0;
			SBUF=tab[qw];
			while(TI==0);
			TI=0;
			for(i=0;i<25;i++);
			l1=1;
		}
		else
		{
			l1=0;
			SBUF=0x3f;
			while(TI==0);
			TI=0;
			for(i=0;i<25;i++);
			l1=1;
		}
		if(qw==0)
		{
			if(bw)
			{
				l2=0;
				SBUF=tab[bw];
				while(TI==0);
				TI=0;
				for(i=0;i<25;i++);
				l2=1;
			}
			else
			{
				l2=0;
				SBUF=0x3f;
				while(TI==0);
				TI=0;
				for(i=0;i<25;i++);
				l2=1;
			}
			if(bw==0)
			{
				if(sw)
				{
					l3=0;
					SBUF=tab[sw];
					while(TI==0);
					TI=0;
					for(i=0;i<25;i++);
					l3=1;
				}
				else
				{
					l3=0;
					SBUF=0x3f;
					while(TI==0);
					TI=0;
					for(i=0;i<25;i++);
					l3=1;
				}
			}
		}
		else
		{
			l2=0;
			SBUF=tab[bw];
			while(TI==0);
			TI=0;
			for(i=0;i<25;i++);
			l2=1;
		}
		l4=0;
		SBUF=tab[gw];
		while(TI==0);
		TI=0;
		for(i=0;i<25;i++);
		l4=1;
	}
	armf();
}