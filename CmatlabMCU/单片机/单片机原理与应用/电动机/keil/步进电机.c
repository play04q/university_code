#include <REGX51.H>
int i=0;
char flag0=0,flag1=0;
long t=5000;
code tab[]={0x01,0x03,0x02,0x06,0x04,0x0c,0x08,0x09};//正转
code tab1[]={0x09,0x08,0x0c,0x04,0x06,0x02,0x03,0x01};//反转
void zz()
{
	flag0=1;
	flag1=0;
}
void fz()
{
	flag0=0;
	flag1=1;
}
void stop()
{
	flag0=0;
	flag1=0;
}
void speedup()
{
	t-=100;
	if(t<0)
		t=0;
}
void speeddown()
{
	t+=100;
	if(t>65535)
		t=65534;
}
void delay(long m)
{
	long n;
	for(n=0;n<m;n++);
}
void main()
{
	EX0=1;
	IT0=1;
	EA=1;
	P1=0xff;
	P2=0x00;
	while(1)
	{
		while(flag1==flag0)
		{
			P2=tab[i];
			delay(t);
		}
		if(flag0==1)
		{
			for(i=0;i<8;i++)
			{
				P2=tab[i];
				delay(t);
			}
		}
		if(flag1==1)
		{
			for(i=0;i<8;i++)
			{
				P2=tab1[i];
				delay(t);
			}
		}
	}
}
void int0() interrupt 0
	{
		switch(P1)
		{
			case 0xfe:zz();break;
			case 0xfd:fz();break;
			case 0xfb:stop();break;
			case 0xf7:speedup();break;
			case 0xef:speeddown();break;
			default:P1=0xff;break;
		}
	}