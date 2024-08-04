#include <REGX51.H>
sbit led1=P2^0;
sbit led2=P2^1;
sbit p22=P2^2;
const char tab[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,
									0x88,0x83,0xc6,0xa1,0x86,0x8e};
void delay5ms()		//@12.000MHz
{
	unsigned char i, j;

	i = 10;
	j = 183;
	do
	{
		while (--j);
	} while (--i);
}
void main()
{
	char i=0,a=0,b=0,h=0,l=0;
	SCON=0x50;
	TMOD=0x20;
	TH1=0xFA;
	TL1=0xFA;
	TR1=1;
	P1=0xff;
	while(1)
	{
		while(RI==i);
		RI=0;
		i=SBUF;
		a=i;b=P1;i=a&b;
		h=i>>4;l=i&0x0f;
		led1=1;
		P0=tab[h];
		delay5ms();
		led1=0;
		led2=1;
		P0=tab[l];
		delay5ms();
		led2=0;
	}
}