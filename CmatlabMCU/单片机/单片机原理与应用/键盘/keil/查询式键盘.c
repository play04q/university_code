#include <REGX51.H>
char j;
char t;
int n;
const char tab[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f};
void delay(int n)//us
{
	int i;
	for(i=0;i<n;i++);
}
void main()
{
	char key;
	P2=0x00;
	P3=0xff;
	while(1)
	{
		while(P3==0xff);
		delay(2000);
		while(P3==0xff);
		key=P3;
		switch(key)
		{
			case 0xfe:P2=tab[1];break;
			case 0xfd:P2=tab[2];break;
			case 0xfb:P2=tab[3];break;
			case 0xf7:P2=tab[4];break;
			case 0xef:P2=tab[5];break;
			case 0xdf:P2=tab[6];break;
			case 0xbf:P2=tab[7];break;
			case 0x7f:P2=tab[8];break;
		}
	}
}