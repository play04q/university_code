#include<reg51.h>
#include<absacc.h>
#include<intrins.h>
sbit P3_5=P3^5;					//控制MAX487发送（1）和接收（0）
sbit P2_0=P2^0;					//控制LED亮灭，通信成功显示
void serial (void) interrupt 4 	//串行口中断子程序
{
 	ES=0;						//关闭串口中断，准备处理数据
	RI=0;
	if(SBUF==0x02)				//判断从主机接收地址是否与本机一致
	{	
		P2_0=~P2_0;				//通信成功显示
		P3_5=1;	 				//准备向主机发送数据
		SBUF=0x20;				//向主机发送数据，高4位供BCD数码管显示
		while(TI!=1);
		TI=0;
		SM2=0;					//准备接收主机TB8=0的数据
		//add your code here!
	}
	ES=1;						//允许串口中断
	P3_5=0;						//准备从主机接收
	SM2=1;	  					//准备从主机接收TB8=1的地址							
}
void main(void)
{	 
	P2_0=0;
	SCON=0xf0;  		//串行口工作于方式3，REN=1可接收数据（也可发送）
						// SM2=1, 从主机接收TB8=1的地址,对TB8=0的数据不予理睬
	TMOD=0x20;		   	//定时器1自动重装载,同主机程序
	TL1=0xfd;			//波特率设置,同主机程序
	TH1=0xfd;
	TR1=1;
	EA=1;
	ES=1;
	P3_5=0;				//准备接收主机发来的地址(TB8=1)或数据(TB8=0)
	while(1)
	{
		_nop_();			
	}
}
