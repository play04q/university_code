#include <REGX52.H>
#include <INTRINS.H>
void Delay200ms()		//@12.000MHz
{
	unsigned char i, j, k;

	_nop_();
	i = 2;
	j = 134;
	k = 20;
	do
	{
		do
		{
			while (--k);
		} while (--j);
	} while (--i);
}

void main()
{
	while(1)
	{
		P2=0xFE;
		Delay200ms();
		P2=0xFD;
		Delay200ms();
	}
}