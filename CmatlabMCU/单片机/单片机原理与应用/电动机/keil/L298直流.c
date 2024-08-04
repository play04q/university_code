#include <REGX51.H>
char cycle=100;
char speed=50;
sbit IN1=P2^0;
sbit IN2=P2^1;
sbit ENA=P2^2;
void zz()
{
	IN1=1;
	IN2=0;
}
void fz()
{
	IN1=0;
	IN2=1;
}
void stop()
{
	IN1=0;
	IN2=0;
}
void t0() interrupt 1 using 1
{
	if(cycle>100)
		cycle=0;
	if(cycle>speed)
		ENA=0;
	else
		ENA=1;
	cycle++;
}
void speedup()
{
	if(speed>99)
		speed=0;
	else
		speed++;
}
void speeddown()
{
	if(speed>1)
		speed=0;
	else
		speed--;
}
void main()
{
	EA=1;
	EX0=1;
	IT0=1;
	TMOD=0x02;
	TH0=0x06;
	TL0=0x06;
	TR0=1;
	ET0=1;
	PX0=1;
	P1=0xff;
	while(1);
}
void int0() interrupt 0 using 0
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