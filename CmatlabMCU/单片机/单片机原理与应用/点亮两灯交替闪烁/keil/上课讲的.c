#include <REGX52.H>
sbit DIP=P1^2;
sbit blue=P1^0;
sbit green=P1^1;
void main()
{
	P1=0xFF;
	while(1)
	{
		if(DIP==0)
		{
			blue=0;
			green=1;
		}
		else
		{
			blue=1;
			green=0;
		}
	}
}