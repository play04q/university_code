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
	P1=0xff;
	SCON=0x00;
	SBUF=0x3f;
	while(TI==0);
	TI=0;
	while(1)
	{
		if(P1==0xff)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xef)
		{
			led1=0;
			SBUF=tab[2];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xdf)
		{
			led1=0;
			SBUF=tab[3];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xcf)
		{
			led1=0;
			SBUF=tab[4];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xbf)
		{
			led1=0;
			SBUF=tab[5];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xaf)
		{
			led1=0;
			SBUF=tab[6];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x9f)
		{
			led1=0;
			SBUF=tab[7];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}		
		if(P1==0x8f)
		{
			led1=0;
			SBUF=tab[8];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x7f)
		{
			led1=0;
			SBUF=tab[9];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x6f)
		{
			led1=0;
			SBUF=tab[10];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x5f)
		{
			led1=0;
			SBUF=tab[11];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x4f)
		{
			led1=0;
			SBUF=tab[12];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x3f)
		{
			led1=0;
			SBUF=tab[13];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x2f)
		{
			led1=0;
			SBUF=tab[14];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x1f)
		{
			led1=0;
			SBUF=tab[15];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x0f)
		{
			led1=0;
			SBUF=tab[16];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[1];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		
		/*---------QAQ---------*/
		
		if(P1==0xfe)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[2];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xfd)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[3];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xfc)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[4];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xfb)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[5];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xfa)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[6];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x9f)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[7];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}		
		if(P1==0xf8)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[8];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf7)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[9];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf6)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[10];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0x5f)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[11];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf4)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[12];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf3)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[13];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf2)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[14];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf1)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[15];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
		if(P1==0xf0)
		{
			led1=0;
			SBUF=tab[1];
			Delay5ms();
			led1=1;
			SBUF=0xff;
			
			led2=0;
			SBUF=tab[16];
			Delay5ms();
			led2=1;
			SBUF=0xff;
		}
	}
}