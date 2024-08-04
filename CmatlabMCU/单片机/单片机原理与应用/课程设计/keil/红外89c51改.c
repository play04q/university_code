#include <REGX51.H>
#include <intrins.h>
sbit hw=P1^7;
sbit bell=P2^0;
sbit led=P2^7;
void delay100us()		//@12.000MHz
{
	unsigned char i;

	_nop_();
	i = 47;
	while (--i);
}
void main()
{
	P3=0xff;
	bell=1;
	led=1;
	while(1)
	{
		if(hw==0)
		{
			//bell=1; //(ÊµÎï)
			bell=!bell; //(·ÂÕæ)
			led=0;
			delay100us();
		}
		else
		{
			bell=0;
			led=1;
		}
	}
}