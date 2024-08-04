#include <REGX51.H>
const char tab[]={0x3f,0x06,0x5b,0x4f,0x66,
									0x6d,0x7d,0x07,0x7f,0x6f,0x77,
									0x7c,0x39,0x5e,0x79,0x71};
char i;
sbit P32=P3^2;
void main()
{
	SCON=0x00;
	P32=1;
	SBUF=0x3F;
	while(TI==0);
	TI=0;
	while(1)
	{
		if(P32==0)
		{
			i++;
			if(i==16)
				i=0;
			SBUF=tab[i];
			while(TI==0);
			TI=0;
			while(P32==0);
		}
	}
}
