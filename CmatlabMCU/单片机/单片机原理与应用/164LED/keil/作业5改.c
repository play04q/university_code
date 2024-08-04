#include <REGX51.H>
#include <intrins.h>
const char tab[]={0x3f,0x06,0x5b,0x4f,0x66,
									0x6d,0x7d,0x07,0x7f,0x6f,0x77,
									0x7c,0x39,0x5e,0x79,0x71};
sbit led1=P3^6;
sbit led2=P3^7;
void Delay5ms()		//@12.000MHz
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
	char m=0;
	char n=0;
	char i=0;
	char j=0;
	P1=0xff;
	SCON=0x00;
	SBUF=0x3f;
	while(TI==0);
	TI=0;
	
	while(1)
	{
		while(P1==m);
		m=P1;
		n=~m;
		i=n&0xf0;
		j=n&0x0f;
		TI=0;
		SBUF=tab[i];
		while(TI==0);
		led1=0;
		Delay5ms();
		led1=1;
		SBUF=0xff;
		led2=0;		
		SBUF=tab[j];
		while(TI==0);
		TI=0;
		Delay5ms();
		led2=1;
		SBUF=0xff;
	}
}