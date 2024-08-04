#include <REGX51.H>
int t=0;
void time0_server_() interrupt 1
{
	TH0=0x3c;
	TL0=0xb0;
	t++;
	if(t==20)
	{
		t=0;
		P0_0=~P0_0;
		P0_1=~P0_1;
	}
	if(t==40)
	{
		t=20;
		P0_2=~P0_2;
		P0_1=~P0_1;
	}
	if(t==60)
	{
		t=40;
		P0_2=~P0_2;
		P0_0=~P0_0;
	}
}
void Init_t0()
{
	TMOD=0x01;
	TH0=0x3c;
	TL0=0xb0;
	EA=1;
	ET0=1;
	TR0=1;
}
void main()
{
	P0_0=0;
	P0_1=0;
	P0_2=1;
	Init_t0();
	while(1)
	{;}
}
