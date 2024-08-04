#include <REGX51.H>
const char tab[]={0xfe,0xfd,0xfd,0xf7,0xef,0xdf,0xbf,0x7f};
char i;
void main()
{
	SCON=0x00;
	IT0=1;
	EA=1;
	EX0=1;
	SBUF=0xFE;
	while(TI==0);
	TI=0;
	while(1);
}
void it0() interrupt 0 using 1
{
	i++;
	if(i==8)
		i=0;
	SBUF=tab[i];
	while(TI==0);
	TI=0;
}