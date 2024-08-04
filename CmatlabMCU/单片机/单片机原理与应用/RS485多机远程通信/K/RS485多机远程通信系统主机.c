#include<reg51.h>
#include<absacc.h>
#include<intrins.h>
unsigned char cort=0;
sbit P3_5=P3^5;				//控制MAX487发送（1）和接收（0）
void master(void)			//发送子程序
{
	if(cort==1)				//与1#从机通信
	{	
		SBUF=0x01;		   	//发送1#从机地址
		while(TI!=1);
		TI=0;
		P3_5=0;		   		//准备接收1#从机发来的数据
		SM2=0;				//准备接收第9位TB8为0的数据
		while(RI!=1);
		RI=0;
		P2=SBUF;		 	//BCD数码管显示1#从机发来的数据的高4位
		//add your code here!
	}		
	if(cort==2)	 			//与2#从机通信
	{
		SBUF=0x02; 			//发送2#从机地址
		while(TI!=1);
		TI=0;
		P3_5=0;				//准备接收2#从机发来的数据
		SM2=0;				//准备接收第9位TB8为0的数据	
		while(RI!=1);
		RI=0;
		P2=SBUF;  			//BCD数码管显示2#从机发来的数据的高4位
		//add your code here!		
	}							 
	if(cort==2)
	cort=0;
	SM2=1;				//准备向所有从机发送新的地址
	P3_5=1;			   	//准备发送		
}
key_serial() interrupt 0 	//按键扫描子程序
{	 
	 ++cort;				//按键次数
	 master(); 				//发送子程序
}
void main(void)
{
	
	P2=0xf0;	 			//BCD数码管显示F（P2口高4位控制）
	SCON=0xf8;				//串行口工作于方式3，SM2=1多机通信，
	   						//REN=1可接收数据，TB8=1发送地址			
	TMOD=0x20;				//T1工作于方式2，作波特率发生器用
	TL1=0xfd;				//波特率＝fosc/32/12/（256-253）
	TH1=0xfd;
	TR1=1;	
	EA=1;
	EX0=1;
	IT0=1;
	P3_5=1;					//准备发送地址
	while(1)
	{
		_nop_();
	}
}
