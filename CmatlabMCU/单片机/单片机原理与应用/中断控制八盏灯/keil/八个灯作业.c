#include <REGX51.H>
const tab1[]={0xff,0x00,0xff,0x00,0xff,0x00,
							0xff,0x00,0xff,0x00,0xff,0x00,};
const tab2[]={0xfe,0xfd,0xfb,0xf7,0xef,0xdf,0xbf,0x7f,
							0xfe,0xfd,0xfb,0xf7,0xef,0xdf,0xbf,0x7f,
							0xfe,0xfd,0xfb,0xf7,0xef,0xdf,0xbf,0x7f,
							0xfe,0xfd,0xfb,0xf7,0xef,0xdf,0xbf,0x7f,};
char a;
void delay()
{
	int i,j;
	for(i=0;i<256;i++)
	for(j=0;j<256;j++)
	{;}
}
void int0() interrupt 0
{
		char i;
		for(i=0;i<13;i++)
		{
			P0=tab1[i];
			delay();
		}
}
void int1() interrupt 2
{
	char i;
	for(i=0;i<32;i++)
	{
		P0=tab2[i];
		delay();
	}
}
void main()
{
	IE=0x85;
	IP=0x01;
	TCON=0x00;
	while(1)
	{
		char x;
		for(x=0;x<23;x++)
		{
			P0=~P0;
			delay();
		}
	}
}