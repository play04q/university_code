#include <REGX51.H>
#define uchar unsigned char
#define uint unsigned int	
sbit DIP=P1^0;
sbit blue=P1^1;
sbit sounder=P0^7;
void delay()
{
	unsigned char i;
	{
		for(i=0;i<125;i++)
		{;}
	}
}
void main()
{
	P1=0xFF;
	while(1)
	{
		if(DIP==0)
		{
			blue=~blue;
			sounder=0;
			delay();
			sounder=1;
			delay();
		}
	}
}